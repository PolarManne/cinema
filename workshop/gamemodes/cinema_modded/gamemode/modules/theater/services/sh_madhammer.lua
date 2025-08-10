--[[
	This is an experimental service implementation for Jellyfin. The code is not elegant, but it works.
	Shows and movies are currently supported, and every domain with the path “/web” is taken into account.
	No titles are fetched, as these API queries require authentication, which is to be avoided here.
	Please make sure that the video sources can be played without logging in and use the links with “/#/details?id=<videoid>” in them.
]]--

-- we DO publicly expose our api keys here brother
local JELLYFIN_API_KEY = "d3d0f4c05d5540a2822a6acaaabc6c70"
local JELLYFIN_USER_ID = "da63609ce9d9467eaa0be65fb92e64aa"

local SERVICE = {
	Name = "madhammer URL",
	IsTimed = true,
	NeedsCodecFix = true,
	ExtentedVideoInfo = true,
	IsCacheable = true
}

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

	return url.host and (params and params["id"] and params["serverId"] )
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
		local directURL = baseURL .. "/Videos/" .. itemId .. "/stream?static=true"
		return { Data = directURL }
	end

	return false
end

if CLIENT then
	function SERVICE:LoadProvider(Video, panel)
		local html = [[
		<html>
		<head>
			<meta charset="utf-8">
			<meta name="viewport" content="width=device-width, initial-scale=1.0">
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
			<video id="cinema-player" src="]] .. Video:Data() .. [[" autoplay controls preload="metadata"></video>
			<script>
				(function() {
					const video = document.getElementById('cinema-player');
					video.addEventListener('loadedmetadata', function() {
						window.cinema_controller = video;
						exTheater.controllerReady();
					});
					video.addEventListener('error', function(e) {
						console.error('Video error:', e);
					});
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
	local baseURL = GetJellyfinBaseURL(url)
	local itemId = url.path:match("/Videos/([^/]+)/stream")
	
	if not itemId then
		return onFailure("Could not extract item ID")
	end
	
	local apiURL = baseURL .. "/Users/" .. JELLYFIN_USER_ID .. "/Items/" .. itemId
	local headers = {
		["Authorization"] = 'MediaBrowser Client="Cinema", Device="Chromium", DeviceId="sneedsfeedandseed", Version="1.0.0", Token="' .. JELLYFIN_API_KEY .. '"'
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