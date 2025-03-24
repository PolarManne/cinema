local SERVICE = {
	Name = "URL (HLS Video)",
	IsTimed = true,

	Dependency = DEPENDENCY_COMPLETE,
	ExtentedVideoInfo = true
}

local validExtensions = {
	["m3u8"] = true,
}

function SERVICE:Match( url )

	if url.file and validExtensions[ url.file.ext ] then
		return true
	end

	return false
end

if (CLIENT) then

	local HTML_BASE = [[
		<!DOCTYPE html>

		<head></head>
		<html>
			<body>
				<style>
					body {
						margin: 0px;
						background-color: black;
						overflow: hidden;
					}

					.videoWrapper video {
						position: absolute;
						top: 0;
						left: 0;
						width: 100%;
						height: 100%;
					}
				</style>

				<div class="videoWrapper">
					<video id="video"></video>
				</div>

				<script src="https://cdn.jsdelivr.net/npm/hls.js@1"></script>
				<script>
					var video = document.getElementById('video');

					if (Hls.isSupported()) {
						var hls = new Hls();
						hls.loadSource("{@VideoSrc}");
						hls.attachMedia(video);

						{@JS_Content}
					}
				</script>
			</body>
		</html>
	]]

	local THEATER_HTML = HTML_BASE:Replace("{@JS_Content}", [[
		video.autoplay = true

		hls.once(Hls.Events.LEVEL_LOADED, function(event, data) {
			window.cinema_controller = video;
			exTheater.controllerReady();
		});
	]])

	local METADATA_HTML = HTML_BASE:Replace("{@JS_Content}", [[
		hls.once(Hls.Events.LEVEL_LOADED, function(event, data) {
			var metadata = {
				duration: data.details.totalduration,
				live: data.details.live
			}

			console.log("METADATA:" + JSON.stringify(metadata))
		});

		hls.on(Hls.Events.ERROR, function(event, data) {
			console.log("ERROR:" + data.details )
		});
	]])

	function SERVICE:LoadProvider( Video, panel )
		local url = Video:Data()

		panel:SetHTML(THEATER_HTML:Replace("{@VideoSrc}", url))
		panel.OnDocumentReady = function(pnl)
			self:LoadExFunctions( pnl )
		end
	end

	function SERVICE:GetMetadata( data, callback )

		local panel = self:CreateWebCrawler(callback)
		panel:SetHTML(METADATA_HTML:Replace( "{@VideoSrc}", data ))

	end
end

function SERVICE:GetURLInfo( url )
	if url and url.encoded then
		return { Data = url.encoded }
	end

	return false
end

function SERVICE:GetVideoInfo( data, onSuccess, onFailure )

	theater.FetchVideoMedata( data:GetOwner(), data, function(metadata)

		if metadata.err then
			return onFailure(metadata.err)
		end

		local info = {}
		info.title = ("HLS: %s"):format(data:Data())

		if metadata.live then
			info.type = "url_hlslive"
			info.duration = 0
		else
			info.duration = math.Round(tonumber(metadata.duration))
		end

		if onSuccess then
			pcall(onSuccess, info)
		end
	end)

end

<<<<<<< HEAD:workshop/gamemodes/cinema_modded/gamemode/modules/theater/services/sh_hls.lua
theater.RegisterService( "hls", SERVICE )

=======
theater.RegisterService( "url_hls", SERVICE )
theater.RegisterService( "url_hlslive", {
	Name = "URL (HLS Live)",
	IsTimed = false,
	Dependency = DEPENDENCY_COMPLETE,
	Hidden = true,
	LoadProvider = CLIENT and SERVICE.LoadProvider or function() end
} )
>>>>>>> upstream/master:workshop/gamemodes/cinema_modded/gamemode/modules/theater/services/sh_url_hls.lua
