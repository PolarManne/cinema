--[[
	This is an experimental service implementation for Jellyfin. The code is not elegant, but it works.
	Shows and movies are currently supported, and every domain with the path “/web” is taken into account.
	No titles are fetched, as these API queries require authentication, which is to be avoided here.
	Please make sure that the video sources can be played without logging in and use the links with “/#/details?id=<videoid>” in them.
]]--

local JELLYFIN_VIDEO_HOST = "video.madhammer.club"
local JELLYFIN_TV_HOST = "tv.madhammer.club"

local JELLYFIN_API_KEY_VIDEO = "d3d0f4c05d5540a2822a6acaaabc6c70"
local JELLYFIN_API_KEY_TV = "23bc7d59276448ff9b54f9f301e1eb34"
local JELLYFIN_USER_ID_VIDEO = "da63609ce9d9467eaa0be65fb92e64aa"
local JELLYFIN_USER_ID_TV = "7c098e85337f438cae231586a1517015"

local SERVICE = {
	Name = "madhammer URL",
	IsTimed = true,
	NeedsCodecFix = true,
	ExtentedVideoInfo = true,
	IsCacheable = true
}

local function IsSupportedJellyfinHost(host)
	return host == JELLYFIN_VIDEO_HOST or host == JELLYFIN_TV_HOST
end

local function IsTVHost(host)
	return host == JELLYFIN_TV_HOST
end

local function GetApiKeyForHost(host)
	if IsTVHost(host) then
		return JELLYFIN_API_KEY_TV
	end

	return JELLYFIN_API_KEY_VIDEO
end

local function GetUserIdForHost(host)
	if IsTVHost(host) then
		return JELLYFIN_USER_ID_TV
	end

	return JELLYFIN_USER_ID_VIDEO
end

local function BuildAuthHeader(apiKey)
	return 'MediaBrowser Client="Cinema", Device="Chromium", DeviceId="sneedsfeedandseed", Version="1.0.0", Token="' .. apiKey .. '"'
end

local function GetJellyfinBaseURL(url)
	local protocol = url.scheme or "https"
	local host = url.host
	local port = url.port and (":" .. url.port) or ""

	-- Extract path up to "/web" (excluding "/web" itself)
	local basePath = ""
	if url.path then
		local webIndex = url.path:find("/web")
		if webIndex then
			basePath = url.path:sub(1, webIndex - 1)
		end
	end

	return protocol .. "://" .. host .. port .. basePath
end

function SERVICE:Match(url)
	local params = (url.fragment and url.fragment["params"] )

	return url.host and IsSupportedJellyfinHost(url.host) and (params and params["id"] and params["serverId"] )
end

function SERVICE:GetURLInfo(url)
	if not url or not url.encoded then return false end

	local baseURL = GetJellyfinBaseURL(url)
	local params = (url.fragment and url.fragment["params"] )
	local itemId

	-- Extract item ID from parsed fragment table
	if params then
		itemId = params["id"]
	end

	if itemId then
		local directURL

		if IsTVHost(url.host) then
			directURL = baseURL .. "/Videos/" .. itemId .. "/stream"
		else
			directURL = baseURL .. "/Videos/" .. itemId .. "/stream?static=true"
		end

		return { Data = directURL }
	end

	return false
end

if CLIENT then
	function SERVICE:LoadProvider(Video, panel)
		local videoData = Video:Data()
		local html = [[
		<html>
		<head>
			<meta charset="utf-8">
			<meta name="viewport" content="width=device-width, initial-scale=1.0">
			<script src="https://cdn.jsdelivr.net/npm/hls.js@1"></script>
		</head>
		<body>
			<style>
				* { margin: 0; padding: 0; box-sizing: border-box; }
				body {
					margin:0px;
					background-color:black;
					overflow:hidden;
				}
				video {
					width: 100%;
					height: 100%;
				}
			</style>
			<video id="cinema-player" autoplay controls preload="metadata"></video>
			<script>
				(function() {
					const video = document.getElementById('cinema-player');
					const source = "]] .. videoData .. [[";
					const isHLS = /\.m3u8(\?|$)/i.test(source);

					const ready = function() {
						window.cinema_controller = video;
						exTheater.controllerReady();
					};

					video.addEventListener('error', function(e) {
						console.error('Video error:', e);
					});

					if (isHLS && window.Hls && Hls.isSupported()) {
						const hls = new Hls();
						hls.loadSource(source);
						hls.attachMedia(video);
						hls.once(Hls.Events.LEVEL_LOADED, ready);
						hls.on(Hls.Events.ERROR, function(event, data) {
							console.error('HLS error:', data && data.details ? data.details : data);
						});
					} else {
						video.src = source;
						video.addEventListener('loadedmetadata', ready);
					}
				})();
			</script>
		</body>
		</html>
		]]

		panel:SetHTML(html)
		panel.OnDocumentReady = function(pnl)
			self:LoadExFunctions(pnl)
		end
	end

	function SERVICE:GetMetadata(data, callback)
		local panel = self:CreateWebCrawler(callback)
		panel:SetHTML([[
			<html>
			<head><meta charset="utf-8"></head>
			<body>
				<video id="metadata-video" src="]] .. data .. [[" preload="metadata" style="display:none;"></video>
				<script>
					const video = document.getElementById('metadata-video');
					video.onloadedmetadata = function() {
						const metadata = {
							duration: video.duration,
							videoWidth: video.videoWidth || 0,
							videoHeight: video.videoHeight || 0
						};
						console.log("METADATA:" + JSON.stringify(metadata));
					};
					video.onerror = function() {
						console.log("ERROR:" + (video.error ? video.error.code : 'unknown'));
					};
				</script>
			</body>
			</html>
		]])
	end
end

function SERVICE:GetVideoInfo(data, onSuccess, onFailure)
	local url = url.parse(data:Data())

	if not url or not url.host then
		return onFailure("Could not parse media URL")
	end

	if IsTVHost(url.host) then
		local baseURL = GetJellyfinBaseURL(url)
		local itemId = url.path and url.path:match("/Videos/([^/]+)/")

		if not itemId then
			return onFailure("Could not extract item ID for live stream")
		end

		local apiKey = GetApiKeyForHost(url.host)
		local userId = GetUserIdForHost(url.host)
		local playbackInfoURL = baseURL .. "/Items/" .. itemId .. "/PlaybackInfo"
		local itemInfoURL = baseURL .. "/Users/" .. userId .. "/Items/" .. itemId
		local requestBody = util.TableToJSON({
			UserId = userId,
			IsPlayback = true,
			AutoOpenLiveStream = true,
			DeviceProfile = {
				TranscodingProfiles = {
					{
						Container = "ts",
						Type = "Video",
						AudioCodec = "aac,mp3,mp2",
						VideoCodec = "h264",
						Context = "Streaming",
						Protocol = "hls",
						MaxAudioChannels = "2",
						MinSegments = "1",
						BreakOnNonKeyFrames = true
					}
				},
				CodecProfiles = {
					{ Type = "VideoAudio", Codec = "aac", Conditions = {} },
					{ Type = "Video", Codec = "h264", Conditions = {} }
				}
			}
		})

		HTTP({
			url = playbackInfoURL,
			method = "POST",
			headers = {
				["Authorization"] = BuildAuthHeader(apiKey)
			},
			type = "application/json",
			body = requestBody,
			success = function(code, body)
				code = tonumber(code) or 0
				if code ~= 200 and code ~= 0 then
					return onFailure("PlaybackInfo request failed with HTTP " .. tostring(code))
				end

				local jsonData = util.JSONToTable(body)
				if not jsonData then
					return onFailure("Invalid PlaybackInfo JSON response")
				end

				local mediaSources = jsonData.MediaSources
				local mediaSource = istable(mediaSources) and mediaSources[1] or nil
				local transcodingPath = mediaSource and mediaSource.TranscodingUrl

				if not isstring(transcodingPath) or transcodingPath == "" then
					return onFailure("PlaybackInfo did not return TranscodingUrl")
				end

				local liveURL = transcodingPath
				if not transcodingPath:match("^https?://") then
					if transcodingPath:sub(1, 1) ~= "/" then
						transcodingPath = "/" .. transcodingPath
					end
					liveURL = baseURL .. transcodingPath
				end

				HTTP({
					url = itemInfoURL,
					headers = {
						["Authorization"] = BuildAuthHeader(apiKey)
					},
					success = function(itemCode, itemBody)
						itemCode = tonumber(itemCode) or 0
						if itemCode ~= 200 and itemCode ~= 0 then
							return onFailure("Item info request failed with HTTP " .. tostring(itemCode))
						end

						local itemData = util.JSONToTable(itemBody)
						if not itemData then
							return onFailure("Invalid item info JSON response")
						end

						local title = itemData.Name or "Madhammer TV"
						if itemData.SeriesName then
							title = itemData.SeriesName .. " - " .. title
						end

						local info = {
							title = title,
							type = "jellyfin_url_live",
							duration = 0,
							data = liveURL
						}

						if onSuccess then
							pcall(onSuccess, info)
						end
					end,
					failed = function(err)
						onFailure("Item info request failed: " .. tostring(err))
					end
				})
			end,
			failed = function(err)
				onFailure("PlaybackInfo request failed: " .. tostring(err))
			end
		})

		return
	end

	local baseURL = GetJellyfinBaseURL(url)
	local itemId = url.path and url.path:match("/Videos/([^/]+)/")
	
	if not itemId then
		return onFailure("Could not extract item ID")
	end
	
	local userId = GetUserIdForHost(url.host)
	local apiURL = baseURL .. "/Users/" .. userId .. "/Items/" .. itemId
	local apiKey = GetApiKeyForHost(url.host)
	local headers = {
		["Authorization"] = BuildAuthHeader(apiKey)
	}
	
	HTTP({
		url = apiURL,
		headers = headers,
		success = function(code, body)
			local jsonData = util.JSONToTable(body)
			if not jsonData then
				return onFailure("Invalid JSON response")
			end
			
			local title = jsonData.Name or "Unknown"
			if jsonData.SeriesName then
				title = jsonData.SeriesName .. " - " .. title
			end
			
			theater.FetchVideoMedata(data:GetOwner(), data, function(metadata)
				local info = {
					title = title,
					duration = math.max(0, math.Round(tonumber(metadata.duration) or 0))
				}
				if onSuccess then pcall(onSuccess, info) end
			end)
		end,
		failed = function(err)
			onFailure("API request failed: " .. tostring(err))
		end
	})
end

theater.RegisterService("jellyfin_url", SERVICE)
theater.RegisterService("jellyfin_url_live", {
	Name = "madhammer URL (Live)",
	IsTimed = false,
	NeedsCodecFix = true,
	IsCacheable = false,
	Hidden = true,
	LoadProvider = CLIENT and SERVICE.LoadProvider or function() end
})