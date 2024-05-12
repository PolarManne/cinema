local SERVICE = {}

SERVICE.Name = "Pomf.TV Stream"
SERVICE.IsTimed = false

SERVICE.Dependency = DEPENDENCY_COMPLETE

local THUMB_URL = "https://pomf.tv/img/streamonline/%s.jpg"

function SERVICE:Match( url )
	return url.host and url.host:match("pomf.tv")
end

if (CLIENT) then
	local POMF_URL = "https://pomf.tv/stream/%s"
	local THEATER_JS = [[
		$('#pomf-age-verification-modal').modal('hide');
		var myPlayer = videojs('pomf-player');

		myPlayer.ready(function() {
			myPlayer.play();
			// chromium seems to be blocking this because it's not a user input
			myPlayer.requestFullscreen();
		});
	]]

	function SERVICE:LoadProvider( Video, panel )

		panel:OpenURL( POMF_URL:format( Video:Data() ) )
		panel.OnDocumentReady = function(pnl)
			self:LoadExFunctions( pnl )
			pnl:QueueJavascript(THEATER_JS)
		end

	end
end

function SERVICE:GetURLInfo( url )
	if url.path then
		local data = url.path:match("/stream/([%w_]+)")
		if (data) then return { Data = data } end
	end

	return false
end

function SERVICE:GetVideoInfo( data, onSuccess, onFailure )
	local info = {}
	info.title = ("Pomf Stream: %s"):format(data)
	info.thumbnail = THUMB_URL:format(data)

	if onSuccess then
		pcall(onSuccess, info)
	end
end

theater.RegisterService( "pomfstream", SERVICE )