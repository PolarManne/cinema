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

	if (window.MediaCodecChecker.shouldInspectUrl(url)) {
		setRequestStatus('Inspecting container and codecs...', true);
		let inspection = null;
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

	setRequestStatus('Request sent!', true);

	setTimeout(() => {
		setRequestStatus('', false);
		finishRequest();
	}, 2000);

	if (typeof gmod !== 'undefined' && gmod.requestUrl) {
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
