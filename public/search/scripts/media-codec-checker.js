'use strict';

(function() {
	const SUPPORTED_VIDEO_CODECS = new Set(['H.264', 'VP8', 'VP9', 'AV1']);
	const SUPPORTED_AUDIO_CODECS = new Set(['AAC', 'Vorbis', 'Opus', 'WAV', 'FLAC', 'MPEG-2', 'MP3']);
	const INSPECTED_MEDIA_EXTENSIONS = new Set(['mp4', 'mkv', 'webm', 'ogg', 'mov']);
	const MATROSKA_SUPPORTED_CODEC_IDS = new Set([
		'V_AV1', 'V_MPEG4/ISO/AVC', 'V_VP8', 'V_VP9',
		'A_AAC', 'A_AAC/MPEG2/LC', 'A_AAC/MPEG2/LC/SBR', 'A_AAC/MPEG2/MAIN',
		'A_AAC/MPEG2/SSR', 'A_AAC/MPEG4/LC', 'A_AAC/MPEG4/LC/SBR',
		'A_AAC/MPEG4/LTP', 'A_AAC/MPEG4/MAIN', 'A_AAC/MPEG4/SSR',
		'A_FLAC', 'A_MPEG/L2', 'A_MPEG/L3', 'A_OPUS', 'A_PCM/FLOAT/IEEE',
		'A_PCM/INT/BIG', 'A_PCM/INT/LIT', 'A_VORBIS'
	]);
	const MATROSKA_CODEC_NAMES = {
		V_AV1: 'AV1',
		V_AVS2: 'AVS2-P2/IEEE.1857.4',
		V_AVS3: 'AVS3-P2/IEEE.1857.10',
		V_CAVS: 'AVS1-P2, JiZhun profile',
		V_DIRAC: 'Dirac',
		V_FFV1: 'FFV1',
		V_JPEG2000: 'JPEG 2000',
		V_MJPEG: 'Motion JPEG',
		'V_MPEGH/ISO/HEVC': 'HEVC / H.265',
		'V_MPEGI/ISO/VVC': 'VVC / H.266',
		V_MPEG1: 'MPEG-1',
		V_MPEG2: 'MPEG-2',
		'V_MPEG4/ISO/AVC': 'AVC / H.264',
		'V_MPEG4/ISO/AP': 'MPEG-4 AP',
		'V_MPEG4/ISO/ASP': 'MPEG-4 ASP / Xvid',
		'V_MPEG4/ISO/SP': 'MPEG-4 SP',
		'V_MPEG4/MS/V3': 'Microsoft MPEG4 V3',
		'V_MS/VFW/FOURCC': 'VP6',
		V_QUICKTIME: 'QuickTime',
		V_PRORES: 'Apple ProRes',
		'V_REAL/RV10': 'RV10',
		'V_REAL/RV20': 'RV20',
		'V_REAL/RV30': 'RV30',
		'V_REAL/RV40': 'RV40',
		V_THEORA: 'Theora',
		V_UNCOMPRESSED: 'Uncompressed Video',
		V_VC1: 'VC-1',
		V_VP8: 'VP8',
		V_VP9: 'VP9',
		A_AAC: 'AAC',
		'A_AAC/MPEG2/LC': 'AAC',
		'A_AAC/MPEG2/LC/SBR': 'AAC',
		'A_AAC/MPEG2/MAIN': 'AAC',
		'A_AAC/MPEG2/SSR': 'AAC',
		'A_AAC/MPEG4/LC': 'AAC',
		'A_AAC/MPEG4/LC/SBR': 'AAC',
		'A_AAC/MPEG4/LTP': 'AAC',
		'A_AAC/MPEG4/MAIN': 'AAC',
		'A_AAC/MPEG4/SSR': 'AAC',
		A_AC3: 'Dolby Digital / AC-3',
		'A_AC3/BSID9': 'Dolby Digital / AC-3',
		'A_AC3/BSID10': 'Dolby Digital / AC-3',
		A_ALAC: 'ALAC',
		'A_ATRAC/AT1': 'ATRAC1',
		A_DTS: 'DTS',
		'A_DTS/EXPRESS': 'DTS',
		'A_DTS/LOSSLESS': 'DTS-HD MA',
		A_EAC3: 'Dolby Digital Plus / E-AC-3',
		A_FLAC: 'FLAC',
		A_MLP: 'MLP',
		'A_MPEG/L1': 'MP1',
		'A_MPEG/L2': 'MP2',
		'A_MPEG/L3': 'MP3',
		'A_MS/ACM': 'Microsoft Audio Codec Manager (ACM)',
		'A_REAL/14_4': 'RealAudio 1',
		'A_REAL/28_8': 'RealAudio 2',
		'A_REAL/ATRC': 'ATRAC3',
		'A_REAL/COOK': 'RealAudio 6',
		'A_REAL/RALF': 'RealAudio Lossless Format',
		'A_REAL/SIPR': 'Sipro',
		A_OPUS: 'Opus',
		'A_PCM/FLOAT/IEEE': 'PCM',
		'A_PCM/INT/BIG': 'PCM',
		'A_PCM/INT/LIT': 'PCM',
		A_QUICKTIME: 'QuickTime',
		'A_QUICKTIME/QDMC': 'QDesign Music',
		'A_QUICKTIME/QDM2': 'QDesign Music v2',
		A_TRUEHD: 'Dolby TrueHD',
		A_TTA1: 'TTA',
		A_VORBIS: 'Vorbis',
		A_WAVPACK4: 'WavPack'
	};
	const MAX_METADATA_SIZE = 16 * 1024 * 1024;

	class CodecCheckError extends Error {}

	function inspectionOrigin() {
		return window.location && window.location.origin && window.location.origin !== 'null' ?
			window.location.origin : 'this Cinema page';
	}

	class RangeReader {
		constructor(url) {
			this.url = url;
			this.size = null;
		}

		async read(offset, length) {
			const end = offset + length - 1;
			let response;

			try {
				response = await fetch(this.url, {
					headers: { Range: `bytes=${offset}-${end}` }
				});
			} catch (error) {
				throw new CodecCheckError(
					`The file host rejected the request needed to scan it for security reasons.`
				);
			}

			if (!response.ok) {
				throw new CodecCheckError(`The file could not be inspected (HTTP ${response.status}).`);
			}

			const contentRange = response.headers.get('Content-Range');
			if (contentRange) {
				const match = contentRange.match(/bytes\s+\d+-\d+\/(\d+|\*)/i);
				if (match && match[1] !== '*') this.size = Number(match[1]);
			} else {
				const contentLength = Number(response.headers.get('Content-Length'));
				if (response.status === 200 && Number.isFinite(contentLength)) this.size = contentLength;
			}

			if (response.status === 200 && offset !== 0) {
				throw new CodecCheckError('The file host does not support the request needed to scan it.');
			}

			let data;
			if (response.status === 200 && response.body && response.body.getReader) {
				const streamReader = response.body.getReader();
				const chunks = [];
				let received = 0;
				while (received < length) {
					const chunk = await streamReader.read();
					if (chunk.done) break;
					const remaining = length - received;
					const value = chunk.value.length > remaining ? chunk.value.subarray(0, remaining) : chunk.value;
					chunks.push(value);
					received += value.length;
				}
				await streamReader.cancel();
				data = new Uint8Array(received);
				let position = 0;
				for (const chunk of chunks) {
					data.set(chunk, position);
					position += chunk.length;
				}
			} else {
				data = new Uint8Array(await response.arrayBuffer());
			}
			if (response.status === 200 && data.length > length) return data.subarray(0, length);
			return data;
		}
	}

	function getExtension(url) {
		try {
			const pathname = new URL(url).pathname;
			const match = pathname.match(/\.([a-z0-9]+)$/i);
			return match ? match[1].toLowerCase() : '';
		} catch (error) {
			return '';
		}
	}

	function shouldInspectUrl(url) {
		return INSPECTED_MEDIA_EXTENSIONS.has(getExtension(url));
	}

	function ascii(data, offset, length) {
		let value = '';
		for (let index = offset; index < offset + length && index < data.length; index++) {
			value += String.fromCharCode(data[index]);
		}
		return value;
	}

	function uint32(data, offset) {
		return ((data[offset] * 0x1000000) +
			(data[offset + 1] << 16) +
			(data[offset + 2] << 8) +
			data[offset + 3]) >>> 0;
	}

	function uint64(data, offset) {
		return uint32(data, offset) * 0x100000000 + uint32(data, offset + 4);
	}

	function littleUint16(data, offset) {
		return data[offset] + (data[offset + 1] << 8);
	}

	function littleUint32(data, offset) {
		return (data[offset] +
			(data[offset + 1] << 8) +
			(data[offset + 2] << 16) +
			(data[offset + 3] * 0x1000000)) >>> 0;
	}

	function track(type, codec, supportedOverride) {
		codec = typeof codec === 'string' && codec.trim() ? codec.trim() : 'Unknown';
		const supported = typeof supportedOverride === 'boolean' ? supportedOverride : type === 'video' ?
			SUPPORTED_VIDEO_CODECS.has(codec) : SUPPORTED_AUDIO_CODECS.has(codec);
		return { type, codec, supported };
	}

	function result(container, tracks) {
		const supportedTracks = tracks.filter(item => item.supported);
		const unsupportedTracks = tracks.filter(item => !item.supported);
		return {
			container,
			tracks,
			supportedTracks,
			unsupportedTracks,
			allowed: supportedTracks.length > 0
		};
	}

	function mp4Codec(type, sampleEntry) {
		const videoCodecs = {
			avc1: 'AVC / H.264', avc3: 'AVC / H.264', vp08: 'VP8', vp09: 'VP9', av01: 'AV1',
			hev1: 'HEVC / H.265', hvc1: 'HEVC / H.265', mp4v: 'Xvid', vvc1: 'VVC / H.266', vvi1: 'VVC / H.266'
		};
		const audioCodecs = {
			mp4a: 'AAC', Opus: 'Opus', fLaC: 'FLAC', '.mp3': 'MP3',
			'.mp2': 'MPEG-2', lpcm: 'PCM', sowt: 'PCM', twos: 'PCM',
			in24: 'PCM', in32: 'PCM', fl32: 'PCM', fl64: 'PCM',
			ac_3: 'Dolby Digital / AC-3', 'ac-3': 'Dolby Digital / AC-3',
			ec_3: 'Dolby Digital / AC-3', 'ec-3': 'Dolby Digital / AC-3',
			'dts-': 'DTS', dtsc: 'DTS', dts3: 'DTS', dtsh: 'DTS-HD MA'
		};
		const map = type === 'video' ? videoCodecs : audioCodecs;
		return map[sampleEntry] || sampleEntry || 'Unknown';
	}

	function findChildBoxes(data, start, end, wantedType) {
		const boxes = [];
		let offset = start;
		while (offset + 8 <= end) {
			let size = uint32(data, offset);
			const type = ascii(data, offset + 4, 4);
			let headerSize = 8;
			if (size === 1 && offset + 16 <= end) {
				size = uint64(data, offset + 8);
				headerSize = 16;
			} else if (size === 0) {
				size = end - offset;
			}
			if (size < headerSize || offset + size > end) break;
			if (!wantedType || type === wantedType) {
				boxes.push({ type, start: offset + headerSize, end: offset + size });
			}
			offset += size;
		}
		return boxes;
	}

	function firstChild(data, parent, type, prefixLength) {
		return findChildBoxes(data, parent.start + (prefixLength || 0), parent.end, type)[0] || null;
	}

	function parseMp4Tracks(moovData, container) {
		const root = { start: uint32(moovData, 0) === 1 ? 16 : 8, end: moovData.length };
		const tracks = [];
		for (const trak of findChildBoxes(moovData, root.start, root.end, 'trak')) {
			const mdia = firstChild(moovData, trak, 'mdia');
			if (!mdia) continue;
			const hdlr = firstChild(moovData, mdia, 'hdlr');
			if (!hdlr || hdlr.start + 12 > hdlr.end) continue;
			const handler = ascii(moovData, hdlr.start + 8, 4);
			const type = handler === 'vide' ? 'video' : handler === 'soun' ? 'audio' : null;
			if (!type) continue;
			const minf = firstChild(moovData, mdia, 'minf');
			const stbl = minf && firstChild(moovData, minf, 'stbl');
			const stsd = stbl && firstChild(moovData, stbl, 'stsd');
			if (!stsd || stsd.start + 16 > stsd.end) {
				tracks.push(track(type, 'Unknown'));
				continue;
			}
			const entryCount = uint32(moovData, stsd.start + 4);
			let offset = stsd.start + 8;
			let parsedEntries = 0;
			for (let index = 0; index < entryCount && offset + 8 <= stsd.end; index++) {
				const size = uint32(moovData, offset);
				if (size < 8 || offset + size > stsd.end) break;
				tracks.push(track(type, mp4Codec(type, ascii(moovData, offset + 4, 4))));
				parsedEntries++;
				offset += size;
			}
			if (parsedEntries === 0) tracks.push(track(type, 'Unknown'));
		}
		return result(container, tracks);
	}

	async function inspectMp4(reader, firstBytes, extension) {
		const container = extension === 'm4a' ? 'M4A' : extension === 'mov' ? 'MOV' : 'MP4';
		let offset = 0;
		let header = firstBytes;
		for (let boxCount = 0; boxCount < 128; boxCount++) {
			if (header.length < 16) header = await reader.read(offset, 16);
			if (header.length < 8) break;
			let size = uint32(header, 0);
			const type = ascii(header, 4, 4);
			let headerSize = 8;
			if (size === 1) {
				size = uint64(header, 8);
				headerSize = 16;
			} else if (size === 0 && reader.size !== null) {
				size = reader.size - offset;
			}
			if (!Number.isSafeInteger(size) || size < headerSize) break;
			if (type === 'moov') {
				if (size > MAX_METADATA_SIZE) throw new CodecCheckError('The MP4 metadata is too large to inspect safely.');
				const moovData = offset + size <= firstBytes.length ?
					firstBytes.subarray(offset, offset + size) : await reader.read(offset, size);
				if (moovData.length < size) throw new CodecCheckError('The MP4 metadata could not be read completely.');
				return parseMp4Tracks(moovData, container);
			}
			offset += size;
			if (reader.size !== null && offset >= reader.size) break;
			header = offset + 16 <= firstBytes.length ?
				firstBytes.subarray(offset, offset + 16) : await reader.read(offset, 16);
		}
		throw new CodecCheckError('No readable MP4 track metadata was found.');
	}

	function readEbmlVint(data, offset, keepMarker) {
		if (offset >= data.length || data[offset] === 0) return null;
		let mask = 0x80;
		let length = 1;
		while (length <= 8 && !(data[offset] & mask)) {
			mask >>= 1;
			length++;
		}
		if (length > 8 || offset + length > data.length) return null;
		let value = keepMarker ? data[offset] : data[offset] & (mask - 1);
		let unknown = !keepMarker && (data[offset] & (mask - 1)) === mask - 1;
		for (let index = 1; index < length; index++) {
			value = value * 256 + data[offset + index];
			unknown = unknown && data[offset + index] === 0xff;
		}
		return { length, value, unknown };
	}

	function ebmlUnsigned(data, start, end) {
		let value = 0;
		for (let index = start; index < end; index++) value = value * 256 + data[index];
		return value;
	}

	function parseTrackEntry(data, start, end) {
		let offset = start;
		let type = null;
		let codec = null;
		while (offset < end) {
			const id = readEbmlVint(data, offset, true);
			if (!id) break;
			const size = readEbmlVint(data, offset + id.length, false);
			if (!size || size.unknown) break;
			const valueStart = offset + id.length + size.length;
			const valueEnd = valueStart + size.value;
			if (valueEnd > end) break;
			if (id.value === 0x83) type = ebmlUnsigned(data, valueStart, valueEnd);
			if (id.value === 0x86) codec = ascii(data, valueStart, size.value);
			offset = valueEnd;
		}
		if (type !== 1 && type !== 2) return null;
		const codecName = codec ? MATROSKA_CODEC_NAMES[codec] || codec : 'Unknown';
		return track(type === 1 ? 'video' : 'audio', codecName, MATROSKA_SUPPORTED_CODEC_IDS.has(codec));
	}

	function findEbmlTracks(data, start, end, tracks) {
		let offset = start;
		const masterIds = new Set([0x18538067, 0x1654ae6b]);
		while (offset < end) {
			const id = readEbmlVint(data, offset, true);
			if (!id) break;
			const size = readEbmlVint(data, offset + id.length, false);
			if (!size) break;
			const valueStart = offset + id.length + size.length;
			const valueEnd = size.unknown ? end : valueStart + size.value;
			if (valueEnd > end) break;
			if (id.value === 0xae) {
				const parsedTrack = parseTrackEntry(data, valueStart, valueEnd);
				if (parsedTrack) tracks.push(parsedTrack);
			} else if (masterIds.has(id.value)) {
				findEbmlTracks(data, valueStart, valueEnd, tracks);
			}
			if (size.unknown) break;
			offset = valueEnd;
		}
	}

	function parseEbmlElementHeader(data, offset) {
		const id = readEbmlVint(data, offset, true);
		if (!id) return null;
		const size = readEbmlVint(data, offset + id.length, false);
		if (!size) return null;
		return {
			id: id.value,
			size: size.value,
			unknownSize: size.unknown,
			headerSize: id.length + size.length
		};
	}

	async function readEbmlElementHeader(reader, offset, firstBytes) {
		const data = offset + 16 <= firstBytes.length ?
			firstBytes.subarray(offset, offset + 16) : await reader.read(offset, 16);
		return parseEbmlElementHeader(data, 0);
	}

	async function readEbmlElement(reader, offset, header, description) {
		if (header.unknownSize || header.size > MAX_METADATA_SIZE) {
			throw new CodecCheckError(`The ${description} metadata is too large to inspect safely.`);
		}
		const totalSize = header.headerSize + header.size;
		const data = await reader.read(offset, totalSize);
		if (data.length < totalSize) {
			throw new CodecCheckError(`The ${description} metadata could not be read completely.`);
		}
		return data;
	}

	function findTracksPositionInSeekHead(data, header) {
		let offset = header.headerSize;
		const end = offset + header.size;
		while (offset < end) {
			const seek = parseEbmlElementHeader(data, offset);
			if (!seek || seek.unknownSize) break;
			const seekStart = offset + seek.headerSize;
			const seekEnd = seekStart + seek.size;
			if (seekEnd > end) break;
			if (seek.id === 0x4dbb) {
				let childOffset = seekStart;
				let targetId = null;
				let targetPosition = null;
				while (childOffset < seekEnd) {
					const child = parseEbmlElementHeader(data, childOffset);
					if (!child || child.unknownSize) break;
					const valueStart = childOffset + child.headerSize;
					const valueEnd = valueStart + child.size;
					if (valueEnd > seekEnd) break;
					if (child.id === 0x53ab) targetId = ebmlUnsigned(data, valueStart, valueEnd);
					if (child.id === 0x53ac) targetPosition = ebmlUnsigned(data, valueStart, valueEnd);
					childOffset = valueEnd;
				}
				if (targetId === 0x1654ae6b && targetPosition !== null) return targetPosition;
			}
			offset = seekEnd;
		}
		return null;
	}

	async function readEbmlTracksAt(reader, offset, firstBytes) {
		const header = await readEbmlElementHeader(reader, offset, firstBytes);
		if (!header || header.id !== 0x1654ae6b) return null;
		const data = await readEbmlElement(reader, offset, header, 'MKV/WebM track');
		const tracks = [];
		findEbmlTracks(data, 0, data.length, tracks);
		return tracks.length ? tracks : null;
	}

	async function inspectEbml(reader, firstBytes) {
		const segmentId = 0x18538067;
		const tracksId = 0x1654ae6b;
		const seekHeadId = 0x114d9b74;
		let offset = 0;
		let segmentDataStart = null;

		for (let index = 0; index < 16; index++) {
			const header = await readEbmlElementHeader(reader, offset, firstBytes);
			if (!header) break;
			if (header.id === segmentId) {
				segmentDataStart = offset + header.headerSize;
				break;
			}
			if (header.unknownSize) break;
			offset += header.headerSize + header.size;
		}

		if (segmentDataStart === null) {
			throw new CodecCheckError('No readable Matroska segment was found.');
		}

		offset = segmentDataStart;
		let tracks = null;
		for (let index = 0; index < 4096; index++) {
			if (reader.size !== null && offset >= reader.size) break;
			const header = await readEbmlElementHeader(reader, offset, firstBytes);
			if (!header) break;

			if (header.id === tracksId) {
				tracks = await readEbmlTracksAt(reader, offset, firstBytes);
				break;
			}

			if (header.id === seekHeadId && !header.unknownSize && header.size <= MAX_METADATA_SIZE) {
				const seekHead = await readEbmlElement(reader, offset, header, 'MKV/WebM seek');
				const tracksPosition = findTracksPositionInSeekHead(seekHead, header);
				if (tracksPosition !== null) {
					tracks = await readEbmlTracksAt(reader, segmentDataStart + tracksPosition, firstBytes);
					if (tracks) break;
				}
			}

			if (header.unknownSize) break;
			offset += header.headerSize + header.size;
		}

		if (!tracks) throw new CodecCheckError('No readable MKV/WebM track metadata was found.');
		const headerText = ascii(firstBytes, 0, Math.min(firstBytes.length, 4096)).toLowerCase();
		return result(headerText.includes('webm') ? 'WebM' : 'MKV', tracks);
	}

	function inspectOgg(data) {
		const firstPackets = new Map();
		let offset = 0;
		while (offset + 27 <= data.length && ascii(data, offset, 4) === 'OggS') {
			const segmentCount = data[offset + 26];
			if (offset + 27 + segmentCount > data.length) break;
			const serial = uint32(new Uint8Array([data[offset + 17], data[offset + 16], data[offset + 15], data[offset + 14]]), 0);
			let bodyOffset = offset + 27 + segmentCount;
			let packetLength = 0;
			for (let index = 0; index < segmentCount; index++) {
				packetLength += data[offset + 27 + index];
				if (data[offset + 27 + index] < 255 && !firstPackets.has(serial)) {
					firstPackets.set(serial, data.subarray(bodyOffset, bodyOffset + packetLength));
				}
			}
			let bodyLength = 0;
			for (let index = 0; index < segmentCount; index++) bodyLength += data[offset + 27 + index];
			offset = bodyOffset + bodyLength;
		}
		const tracks = [];
		for (const packet of firstPackets.values()) {
			const signature = ascii(packet, 0, Math.min(packet.length, 8));
			if (signature.startsWith('OpusHead')) tracks.push(track('audio', 'Opus'));
			else if (packet[0] === 1 && ascii(packet, 1, 6) === 'vorbis') tracks.push(track('audio', 'Vorbis'));
			else if (signature.startsWith('fLaC') || (packet[0] === 0x7f && ascii(packet, 1, 4) === 'FLAC')) tracks.push(track('audio', 'FLAC'));
			else if (packet[0] === 0x80 && ascii(packet, 1, 6) === 'theora') tracks.push(track('video', 'Theora'));
			else if (signature.startsWith('Speex   ')) tracks.push(track('audio', 'Speex'));
		}
		if (!tracks.length) throw new CodecCheckError('No recognizable audio or video tracks were found in the Ogg file.');
		return result('Ogg', tracks);
	}

	function inspectWav(data) {
		let offset = 12;
		while (offset + 8 <= data.length) {
			const type = ascii(data, offset, 4);
			const size = littleUint32(data, offset + 4);
			const valueStart = offset + 8;
			if (type === 'fmt ' && valueStart + 16 <= data.length) {
				let format = littleUint16(data, valueStart);
				if (format === 0xfffe && size >= 40 && valueStart + 26 <= data.length) {
					format = littleUint16(data, valueStart + 24);
				}
				const codec = format === 1 || format === 3 ? 'WAV' : `WAV format 0x${format.toString(16)}`;
				return result('WAV', [track('audio', codec)]);
			}
			offset = valueStart + size + (size % 2);
		}
		throw new CodecCheckError('No readable WAV audio format metadata was found.');
	}

	async function inspectMpegAudio(reader, data) {
		let offset = 0;
		if (ascii(data, 0, 3) === 'ID3' && data.length >= 10) {
			offset = 10 + ((data[6] & 0x7f) << 21) + ((data[7] & 0x7f) << 14) +
				((data[8] & 0x7f) << 7) + (data[9] & 0x7f);
			if (offset + 4 > data.length) {
				data = await reader.read(offset, 64 * 1024);
				offset = 0;
			}
		}
		for (; offset + 4 <= data.length; offset++) {
			if (data[offset] !== 0xff || (data[offset + 1] & 0xe0) !== 0xe0) continue;
			const version = (data[offset + 1] >> 3) & 0x03;
			const layer = (data[offset + 1] >> 1) & 0x03;
			const bitrate = (data[offset + 2] >> 4) & 0x0f;
			const sampleRate = (data[offset + 2] >> 2) & 0x03;
			if (version === 1 || layer === 0 || bitrate === 0 || bitrate === 15 || sampleRate === 3) continue;
			if (layer === 1) return result('MP3', [track('audio', 'MP3')]);
			if (layer === 2) return result('MP3', [track('audio', 'MPEG-2 Audio')]);
			return result('MP3', [track('audio', 'MPEG Audio Layer I')]);
		}
		throw new CodecCheckError('No valid MPEG audio frames were found in the MP3 file.');
	}

	function identifyContainer(data) {
		if (ascii(data, 4, 4) === 'ftyp') return 'mp4';
		if (data[0] === 0x1a && data[1] === 0x45 && data[2] === 0xdf && data[3] === 0xa3) return 'ebml';
		if (ascii(data, 0, 4) === 'OggS') return 'ogg';
		if (ascii(data, 0, 4) === 'fLaC') return 'flac';
		if (ascii(data, 0, 4) === 'RIFF' && ascii(data, 8, 4) === 'WAVE') return 'wav';
		if (ascii(data, 0, 3) === 'ID3' || (data[0] === 0xff && (data[1] & 0xe0) === 0xe0)) return 'mp3';
		return null;
	}

	async function inspectUrl(url) {
		const extension = getExtension(url);
		const reader = new RangeReader(url);
		const firstBytes = await reader.read(0, 64 * 1024);
		const container = identifyContainer(firstBytes);
		if (!container) throw new CodecCheckError('The URL does not contain a supported media file.');
		if (container === 'mp4') return inspectMp4(reader, firstBytes, extension);
		if (container === 'ebml') return inspectEbml(reader, firstBytes);
		if (container === 'ogg') return inspectOgg(firstBytes);
		if (container === 'flac') return result('FLAC', [track('audio', 'FLAC')]);
		if (container === 'wav') return inspectWav(firstBytes);
		return inspectMpegAudio(reader, firstBytes);
	}

	window.MediaCodecChecker = { CodecCheckError, inspectUrl, shouldInspectUrl };
})();
