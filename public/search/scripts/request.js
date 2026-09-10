'use strict';

// Service definitions with codec requirements
const services = [
	{ name: 'YouTube', icon: 'youtube', url: 'https://youtube.com/', action: 'select', requiresCodec: false },
	{ name: 'TikTok', icon: 'tiktok', url: 'https://tiktok.com/', action: 'select', requiresCodec: true },
	{ name: 'SoundCloud', icon: 'soundcloud', url: 'https://soundcloud.com/discover', action: 'select', requiresCodec: false },
	{ name: 'Dailymotion', icon: 'dailymotion', url: 'https://www.dailymotion.com/', action: 'select', requiresCodec: true },
	{ name: 'Twitch', icon: 'twitch', url: 'https://www.twitch.tv/', action: 'select', requiresCodec: true },
	{ name: 'Rumble', icon: 'rumble', url: 'https://rumble.com/', action: 'select', requiresCodec: true },
	{ name: 'Kick', icon: 'kick', url: 'https://kick.com/', action: 'select', requiresCodec: true },
	{ name: 'Bilibili', icon: 'bilibili', url: 'https://www.bilibili.com/', action: 'open', requiresCodec: true },
	{ name: 'Archive', icon: 'archive', url: 'https://archive.org/details/movies', action: 'select', requiresCodec: true },
	{ name: 'Secret Stash', icon: 'madhammer', url: 'https://video.madhammer.club', action: 'select', requiresCodec: true },
	{ name: 'Live TV', icon: 'tv', url: 'https://tv.madhammer.club', action: 'select', requiresCodec: true },
	{ name: 'Upload Video', icon: 'upload', url: 'https://files.madhammer.club', action: 'open', requiresCodec: true },
];

const webRelayMode = window.location.hash === '#webrelay';
const directMetadataExtensions = new Set([
	'webm', 'mp3', 'wav', 'ogg', 'm4a', 'aac', 'flac', 'mp4', 'mov', 'mkv'
]);
let hlsLibraryPromise = null;

function loadHlsLibrary() {
	if (window.Hls) return Promise.resolve(window.Hls);
	if (hlsLibraryPromise) return hlsLibraryPromise;
	hlsLibraryPromise = new Promise((resolve, reject) => {
		const script = document.createElement('script');
		script.src = 'https://cdn.jsdelivr.net/npm/hls.js@1';
		script.async = true;
		script.onload = () => window.Hls ? resolve(window.Hls) : reject(new Error('HLS unavailable'));
		script.onerror = () => reject(new Error('HLS unavailable'));
		document.head.appendChild(script);
	}).catch((error) => {
		hlsLibraryPromise = null;
		throw error;
	});
	return hlsLibraryPromise;
}

function extractYouTubeId(value) {
	try {
		const parsed = new URL(value);
		if (/(^|\.)youtube\.com$/i.test(parsed.hostname)) {
			const queryId = parsed.searchParams.get('v');
			if (queryId && /^[A-Za-z0-9_-]{11}$/.test(queryId)) return queryId;
			const match = parsed.pathname.match(/^\/(?:shorts|v|embed)\/([A-Za-z0-9_-]{11})(?:\/|$)/);
			return match ? match[1] : null;
		}
		if (/^(?:www\.)?youtu\.be$/i.test(parsed.hostname)) {
			const match = parsed.pathname.match(/^\/([A-Za-z0-9_-]{11})(?:\/|$)/);
			return match ? match[1] : null;
		}
	} catch {}
	return null;
}

function collectYouTubeMetadata(videoId) {
	return new Promise((resolve) => {
		const token = `${Date.now().toString(36)}-${Math.random().toString(36).slice(2)}`;
		const frame = document.createElement('iframe');
		frame.setAttribute('aria-hidden', 'true');
		frame.style.cssText = 'position:fixed;width:1px;height:1px;opacity:0;pointer-events:none;border:0';
		let settled = false;
		const finish = (metadata) => {
			if (settled) return;
			settled = true;
			window.removeEventListener('message', receive);
			frame.remove();
			resolve(metadata);
		};
		const receive = (event) => {
			if (event.origin !== window.location.origin || event.source !== frame.contentWindow ||
				!event.data || event.data.v !== 1 || event.data.token !== token) return;
			if (event.data.type === 'cinema_metadata') finish(event.data.value);
			else if (event.data.type === 'cinema_metadata_error') finish(undefined);
		};
		window.addEventListener('message', receive);
		frame.src = `../youtube_meta.html#relay=1&token=${encodeURIComponent(token)}&v=${encodeURIComponent(videoId)}`;
		document.body.appendChild(frame);
		setTimeout(() => finish(undefined), 10000);
	});
}

function collectDirectMetadata(value, inspection) {
	let parsed;
	try {
		parsed = new URL(value);
	} catch {
		return Promise.resolve(undefined);
	}
	const extension = parsed.pathname.split('.').pop().toLowerCase();
	if (extension === 'm3u8') {
		return loadHlsLibrary().then((Hls) => new Promise((resolve) => {
			const media = document.createElement('video');
			media.style.cssText = 'position:fixed;width:1px;height:1px;opacity:0;pointer-events:none';
			media.setAttribute('aria-hidden', 'true');
			document.body.appendChild(media);
			const hls = new Hls();
			let settled = false;
			const finish = (metadata) => {
				if (settled) return;
				settled = true;
				hls.destroy();
				media.remove();
				resolve(metadata);
			};
			hls.on(Hls.Events.MANIFEST_PARSED, () => finish({ duration: 0, isLive: true }));
			hls.on(Hls.Events.ERROR, (_event, data) => {
				if (data && data.fatal) finish(undefined);
			});
			hls.loadSource(parsed.href);
			hls.attachMedia(media);
			setTimeout(() => finish(undefined), 10000);
		})).catch(() => undefined);
	}
	if (!directMetadataExtensions.has(extension)) return Promise.resolve(undefined);
	if (inspection && Number.isFinite(inspection.duration) && inspection.duration > 0) {
		return Promise.resolve({ duration: Math.round(inspection.duration), isLive: false });
	}

	return new Promise((resolve) => {
		const media = document.createElement('video');
		media.style.cssText = 'position:fixed;width:1px;height:1px;opacity:0;pointer-events:none';
		media.setAttribute('aria-hidden', 'true');
		document.body.appendChild(media);
		let settled = false;
		const finish = (metadata) => {
			if (settled) return;
			settled = true;
			media.removeAttribute('src');
			media.load();
			media.remove();
			resolve(metadata);
		};
		media.preload = 'metadata';
		const inspectDuration = () => {
			if (Number.isFinite(media.duration) && media.duration > 0) {
				finish({ duration: Math.round(media.duration), isLive: false });
			}
		};
		media.onloadedmetadata = inspectDuration;
		media.ondurationchange = inspectDuration;
		media.onerror = () => finish(undefined);
		media.src = parsed.href;
		media.load();
		setTimeout(() => finish(undefined), 10000);
	});
}

async function collectWebRelayMetadata(value, inspection) {
	if (!webRelayMode) return undefined;
	const youtubeId = extractYouTubeId(value);
	return youtubeId ? collectYouTubeMetadata(youtubeId) : collectDirectMetadata(value, inspection);
}

// Codec support detection
let hasCodecSupport = false;

function checkCodecSupport() {
	return new Promise((resolve) => {
		const video = document.createElement('video');
		const support = video.canPlayType('video/mp4; codecs="avc1.42E01E"') === "probably";
		hasCodecSupport = support;
		resolve({ hasCodecSupport: support });
	});
}

// Initialize service grid
async function initializeServices() {
	const grid = document.getElementById('services-grid');
	const codecCheck = await checkCodecSupport();

	services.forEach(service => {
		const card = document.createElement('div');
		card.className = 'service-card';
		card.dataset.href = service.url;
		card.dataset.action = service.action;
		card.dataset.serviceName = service.name;

		const isDisabled = service.requiresCodec && !codecCheck.hasCodecSupport;

		if (isDisabled) {
			card.classList.add('service-disabled');
			card.addEventListener('click', (e) => {
				e.preventDefault();
				showCodecPopup(service.name);
			});
		} else {
			card.addEventListener('click', () => selectService(card));
			card.addEventListener('mouseenter', hoverService);
		}

		card.innerHTML = `
			<div class="service-card-inner">
				<div class="service-icon logo-${service.icon}"></div>
				<div class="service-name">${service.name}</div>
				${isDisabled ? '<div class="disabled-overlay">Codec Required</div>' : ''}
			</div>
		`;

		grid.appendChild(card);
	});
}

function showCodecPopup(serviceName) {
	const popup = document.getElementById('codec-popup');
	const serviceNameElement = document.getElementById('service-name-popup');

	serviceNameElement.textContent = serviceName;
	popup.classList.remove('hidden');
	document.body.style.overflow = 'hidden';
}

function closeCodecPopup() {
	const popup = document.getElementById('codec-popup');
	popup.classList.add('hidden');
	document.body.style.overflow = '';
}

function openCodecInstructions() {
	const url = 'https://www.solsticegamestudios.com/fixmedia/';

	if (typeof gmod !== 'undefined' && gmod.openUrl) {
		gmod.openUrl(url);
	} else {
		window.open(url, '_blank');
	}
	closeCodecPopup();
}

function selectService(elem) {
	if (elem.classList.contains('service-disabled')) {
		return;
	}

	playUISound(true);

	const href = elem.dataset.href;
	const action = elem.dataset.action;
	if (webRelayMode) {
		window.open(href, '_blank', 'noopener,noreferrer');
		return;
	}

	if (action === 'open') {
		openService(elem);
	} else {
		window.location.href = href;
	}
}

function openService(elem) {
	const href = elem.dataset.href;
	if (typeof gmod !== 'undefined' && gmod.openUrl) {
		gmod.openUrl(href);
	} else {
		window.open(href, '_blank');
	}
}

let requestInProgress = false;
let mediaPopupResolver = null;

function setRequestStatus(message, visible) {
	const statusIndicator = document.getElementById('status-indicator');
	const statusText = document.getElementById('status-text');
	statusText.textContent = message;
	statusIndicator.classList.toggle('hidden', !visible);
}

function finishRequest() {
	requestInProgress = false;
	document.getElementById('submit-btn').disabled = false;
}

function closeMediaPopup(confirmed) {
	const popup = document.getElementById('media-check-popup');
	popup.classList.add('hidden');
	document.body.style.overflow = '';
	if (mediaPopupResolver) {
		const resolve = mediaPopupResolver;
		mediaPopupResolver = null;
		resolve(Boolean(confirmed));
	}
}

function showMediaPopup(title, message, tracks, allowContinue) {
	const popup = document.getElementById('media-check-popup');
	const trackList = document.getElementById('media-check-tracks');
	document.getElementById('media-check-title').textContent = title;
	document.getElementById('media-check-message').textContent = message;
	document.getElementById('media-check-continue').classList.toggle('hidden', !allowContinue);
	trackList.replaceChildren();

	for (const mediaTrack of tracks || []) {
		const item = document.createElement('li');
		item.className = mediaTrack.supported ? 'track-supported' : 'track-unsupported';
		const codec = mediaTrack.codec || 'Unknown';
		item.textContent = `${mediaTrack.type === 'video' ? 'Video' : 'Audio'}: ${codec}`;
		trackList.appendChild(item);
	}

	popup.classList.remove('hidden');
	document.body.style.overflow = 'hidden';
	return new Promise(resolve => {
		mediaPopupResolver = resolve;
	});
}

async function requestUrl() {
	const elem = document.getElementById('urlinput');
	const url = elem.value.trim();
	const submitBtn = document.getElementById('submit-btn');

	if (url.length === 0 || requestInProgress) return;
	requestInProgress = true;
	submitBtn.disabled = true;

	let inspection = null;
	if (window.MediaCodecChecker.shouldInspectUrl(url)) {
		setRequestStatus('Inspecting container and codecs...', true);
		try {
			inspection = await window.MediaCodecChecker.inspectUrl(url);
		} catch (error) {
			setRequestStatus('', false);
			const confirmed = await showMediaPopup(
				'Video could not be verified',
				`${error.message || 'Your file could not be inspected.'} The video might not be playable. Do you want to request it anyway?`,
				[],
				true
			);
			if (!confirmed) {
				finishRequest();
				return;
			}
		}

		if (inspection && !inspection.allowed) {
			setRequestStatus('', false);
			showMediaPopup(
				'Video cannot be played',
				`Your file contains no supported audio or video tracks.`,
				inspection.tracks,
				false
			);
			finishRequest();
			return;
		}

		if (inspection && inspection.unsupportedTracks.length > 0) {
			setRequestStatus('', false);
			const confirmed = await showMediaPopup(
				'Some tracks cannot be played',
				`One or more audio and/or video tracks in your file cannot be played.`,
				inspection.tracks,
				true
			);
			if (!confirmed) {
				finishRequest();
				return;
			}
		}
	}

	let metadata;
	if (webRelayMode) {
		setRequestStatus('Collecting video information...', true);
		metadata = await collectWebRelayMetadata(url, inspection);
	}

	setRequestStatus('Request sent!', true);

	setTimeout(() => {
		setRequestStatus('', false);
		finishRequest();
	}, 2000);

	if (webRelayMode && window.parent !== window) {
		window.parent.postMessage({
			v: 1,
			type: 'cinema_request',
			url: url,
			...(metadata ? { metadata } : {})
		}, '*');
	} else if (typeof gmod !== 'undefined' && gmod.requestUrl) {
		gmod.requestUrl(url);
	}
}

function onUrlKeyDown(event) {
	const key = event.keyCode || event.which;
	if (key === 13) {
		requestUrl();
	}
}

function playUISound(click) {
	if (typeof gmod !== 'undefined' && gmod.clickSound) {
		gmod.clickSound(click);
	}
}

function hoverService() {
	playUISound(false);
}

function initializeUrlInput() {
	const urlInput = document.getElementById('urlinput');
	if (urlInput) {
		urlInput.addEventListener('keydown', onUrlKeyDown);
	}
}

function initializeMediaPopup() {
	document.getElementById('media-check-overlay').addEventListener('click', () => closeMediaPopup(false));
	document.getElementById('media-check-close').addEventListener('click', () => closeMediaPopup(false));
	document.getElementById('media-check-cancel').addEventListener('click', () => closeMediaPopup(false));
	document.getElementById('media-check-continue').addEventListener('click', () => closeMediaPopup(true));
}

function initializeAutoInput() {
	const urlInput = document.getElementById('urlinput');
	if (!urlInput) return;

	// Focus input on keypress
	document.addEventListener('keydown', (event) => {
		if (document.activeElement === urlInput ||
			event.ctrlKey || event.metaKey || event.altKey ||
			event.key === 'Tab' || event.key === 'Escape') {
			return;
		}

		urlInput.focus();
	});
}

function isValidURL(string) {
	try {
		new URL(string);
		return true;
	} catch {
		return /^https?:\/\//.test(string) ||
			   /^www\./.test(string) ||
			   string.includes('.') && string.length > 5;
	}
}

document.addEventListener('DOMContentLoaded', () => {
	initializeServices();
	initializeUrlInput();
	initializeAutoInput();
	initializeMediaPopup();
});

// Global function exports
window.requestUrl = requestUrl;
window.selectService = selectService;
window.openService = openService;
window.hoverService = hoverService;
