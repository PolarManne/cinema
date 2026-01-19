CreateConVar( "cinema_queue_mode", 1, { FCVAR_ARCHIVE, FCVAR_DONTRECORD, FCVAR_REPLICATED }, "1 = Videos may be voted up or down\n2 = Videos are played in the order they're requested" )
CreateConVar( "cinema_url", "https://madhammer.club/cinema/", { FCVAR_NOT_CONNECTED, FCVAR_REPLICATED }, "Cinema url to load on theater screens.") -- don't edit, use server config!

if CLIENT then

	CreateClientConVar( "cinema_drawnames", 1, true, false )
	CreateClientConVar( "cinema_volume", 50, true, false )
	CreateClientConVar( "cinema_resolution", 1080, true, false )
	local MuteNoFocus = CreateClientConVar( "cinema_mute_nofocus", 1, true, false )
	local HidePlayers = CreateClientConVar( "cinema_hideplayers", 0, true, false )
	local HideAmount = CreateClientConVar( "cinema_hide_amount", 0.11, true, false )

	cvars.AddChangeCallback( "cinema_resolution", function(cmd, old, new)
		new = tonumber(new)

		if not new then
			return
		elseif new < 2 then
			RunConsoleCommand( "cinema_resolution", 2 )
		elseif new > 1080 then
			RunConsoleCommand( "cinema_resolution", 1080 )
		else
			theater.ResizePanel()
		end
	end)

	cvars.AddChangeCallback( "cinema_volume", function(cmd, old, new)
		new = tonumber(new)

		if not new then
			return
		elseif new < 0 then
			RunConsoleCommand( "cinema_volume", 0 )
		elseif new > 100 then
			RunConsoleCommand( "cinema_volume", 100 )
		else
			theater.SetVolume(new)
		end
	end)

	concommand.Add( "cinema_toggle_controls", function()
		local panel = theater.ActivePanel()
		if panel then
			if panel._controlsEnabled then
				panel:SetPaintedManually(true)
				panel:SetKeyboardInputEnabled(false)
				panel:SetMouseInputEnabled(false)
				panel:RunJavascript(
					"if (window.theater) theater.toggleControls(false);")
				panel._controlsEnabled = nil
			else
				panel:SetPaintedManually(false)
				panel:SetKeyboardInputEnabled(true)
				panel:SetMouseInputEnabled(true)
				panel:RunJavascript(
					"if (window.theater) theater.toggleControls(true);")
				panel._controlsEnabled = true
			end
		end
	end )
	
	concommand.Add( "cinema_refresh", function()
		theater.RefreshPanel(true)
	end )

	concommand.Add( "cinema_fullscreen", theater.ToggleFullscreen )

	-- Hide Players
	local amount = 0
	local undomodelblend = false
	local matWhite = Material("models/debug/debugwhite")
	hook.Add( "PrePlayerDraw", "TheaterHidePlayers", function( ply )

		-- Local player in a theater and hide players enabled
		if LocalPlayer():InTheater() then
			if theater.Fullscreen then
				return true
			end

			if HidePlayers:GetBool() then
				amount = HideAmount:GetFloat()

				-- Hide model
				render.SetBlend( amount )
				render.ModelMaterialOverride(matWhite)
				render.SetColorModulation(0.2, 0.2, 0.2)

				undomodelblend = true
			end
		end

	end )

	hook.Add( "PostPlayerDraw", "TheaterHidePlayers", function( ply )
		if undomodelblend then
			render.SetBlend(1.0) -- always show model
			render.ModelMaterialOverride()
			render.SetColorModulation(1, 1, 1)
			undomodelblend = nil
		end
	end )

	-- Mute theater on losing focus to Garry's Mod window
	local HasFocus, LastVolume = true, theater.GetVolume()
	hook.Add( "Think", "TheaterMuteOnFocusChange", function()

		if not MuteNoFocus:GetBool() then return end

		HasFocus = system.HasFocus()

		if ( LastState and not HasFocus ) or ( not LastState and HasFocus ) then

			if HasFocus == true then
				theater.SetVolume( LastVolume )
				LastVolume = nil
			else
				LastVolume = theater.GetVolume()
				theater.SetVolume( 0 )
			end

			LastState = HasFocus

		end

	end )

else

	local fcvar = { FCVAR_ARCHIVE, FCVAR_DONTRECORD }

	-- Settings
	CreateConVar( "cinema_video_duration_max", 3 * 60 * 60, fcvar, "Maximum video duration for requests in public theaters." )
	CreateConVar( "cinema_skip_ratio", 0.66, fcvar, "Ratio between 0-1 determining how many players are required to voteskip a video." )
	-- Permissions
	CreateConVar( "cinema_allow_reset", 0, fcvar, "Reset the theater after all players have left." )
	CreateConVar( "cinema_allow_voice", 0, fcvar, "Allow theater viewers to talk amongst themselves." )
	CreateConVar( "cinema_allow_3dvoice", 1, fcvar, "Use 3D voice chat." )

	concommand.Add("cinema_fullscreen_freeze", function(ply,cmd,args)
		ply:Freeze(tobool(args[1]))
	end)

	concommand.Add("cinema_truncate_history", function(ply,cmd,args)

		if (IsValid(ply) and ply:IsPlayer() and ply:IsSuperAdmin()) then
			theater.Query("DELETE FROM cinema_history")
		end

	end)

	local function TheaterCommand( name, Function )

		if not Function then return end

		concommand.Add( name, function( ply, ... )

			if not IsValid(ply) then return end

			local Theater = ply:GetTheater()
			if Theater then

				local status, err = pcall(Function, Theater, ply, ...)

				if not status then
					Msg("ERROR: There was a problem running the command '" .. name .. "'\n")
					Msg(tostring(err) .. "\n")
				end

			end

		end)

	end

	TheaterCommand( "cinema_video_request", function( Theater, ply, cmd, args )

		local Video = args[1]
		if not Video then return end

		Theater:RequestVideo(ply, Video)

	end)

	TheaterCommand( "cinema_video_remove", function( Theater, ply, cmd, args )

		local id = tonumber(args[1])
		if not id then return end

		Theater:RemoveQueuedVideo(ply, id)

	end)

	TheaterCommand( "cinema_name", function( Theater, ply, cmd, args )

		local name = args[1]
		if not name then return end

		Theater:SetName( name, ply )

	end)

	TheaterCommand( "cinema_voteskip", function( Theater, ply, cmd, args )

		-- Prevent player from spamming command
		if ply.LastVoteSkip and ply.LastVoteSkip + 1 > CurTime() then
			return
		end

		Theater:VoteSkip(ply)

		ply.LastVoteSkip = CurTime()

	end)

	TheaterCommand( "cinema_voteup", function( Theater, ply, cmd, args )

		local QueueId = tonumber(args[1])
		if not QueueId then return end

		Theater:VoteQueuedVideo(ply, QueueId, true)

	end)

	/*
		Admin/Developer Commands
	*/
	local function TheaterPrivilegedCommand( name, Function )

		if not Function then return end

		concommand.Add( name, function( ply, ... )

			if not IsValid(ply) then return end

			local Theater = ply:GetTheater()
			if Theater then

				if ply:IsAdmin() or
					( Theater:IsPrivate() and Theater:GetOwner() == ply ) then

					local status, err = pcall(Function, Theater, ply, ...)

					if not status then
						Msg("ERROR: There was a problem running the command '" .. name .. "'\n")
						Msg(tostring(err) .. "\n")
					end

				end

			end

		end)

	end

	TheaterPrivilegedCommand( "cinema_video_set", function( Theater, ply, cmd, args )

		local VideoUrl = args[1]
		if not VideoUrl then return end

		Theater:RequestVideo(ply, VideoUrl, true)

	end )

	TheaterPrivilegedCommand( "cinema_seek", function( Theater, ply, cmd, args )

		local seconds = args[1]
		if not seconds then return end

		Theater:Seek(seconds)

	end )

	TheaterPrivilegedCommand( "cinema_forceskip", function( Theater, ply, cmd, args )

		Theater:AnnounceToPlayers( {
			"Theater_ForceSkipped",
			ply:Nick()
		} )

		Theater:SkipVideo()

	end )

	TheaterPrivilegedCommand( "cinema_lock", function( Theater, ply, cmd, args )

		Theater:ToggleQueueLock( ply )

	end )

	TheaterPrivilegedCommand( "cinema_video_priority", function( Theater, ply, cmd, args )

		local id = tonumber(args[1])
		if not id then return end

		Theater:ToggleVideoPriority(ply, id)

	end )

	TheaterPrivilegedCommand( "cinema_reset", function( Theater, ply, cmd, args )

		if not ply:IsAdmin() then return end

		Theater:AnnounceToPlayers( {
			"Theater_PlayerReset",
			ply:Nick()
		} )

		Theater:Reset()

	end )

	/*
		Admin/server commands
	*/
	concommand.Add("cinema_now_playing", function(ply, cmd, args)

		if IsValid(ply) and not ply:IsAdmin() then return end

		local Theaters = theater.GetTheaters()
		local foundAny = false

		for locId, Theater in pairs(Theaters) do

			if Theater:IsPlaying() then

				foundAny = true
				local elapsed = Theater:VideoCurrentTime(true)

				Msg("Theater: " .. Theater:Name() .. "\n")
				Msg("\tTitle:\t\t" .. tostring(Theater:VideoTitle()) .. "\n")
				Msg("\tType:\t\t" .. tostring(Theater:VideoType()) .. "\n")
				Msg("\tData:\t\t" .. tostring(Theater:VideoData()) .. "\n")
				Msg("\tElapsed:\t" .. string.FormatSeconds(elapsed) .. "\n")
				Msg("\tDuration:\t" .. string.FormatSeconds(Theater:VideoDuration()) .. "\n")
				Msg(string.format("\tRequested by:\t%s (%s)\n", Theater:VideoOwnerName(), Theater:VideoOwnerSteamID()))
				Msg("\n")

			end

		end

		if not foundAny then
			Msg("No videos are currently playing.\n")
		end

	end)

	concommand.Add("cinema_print_queue", function(ply, cmd, args)

		if IsValid(ply) and not ply:IsAdmin() then return end

		local Theaters = theater.GetTheaters()
		local foundAny = false

		for locId, Theater in pairs(Theaters) do

			local queue = Theater:GetQueue()

			if #queue > 0 then

				foundAny = true
				Msg("Theater: " .. Theater:Name() .. "\n")
				Msg("Queue Mode: " .. (theater.GetQueueMode() == QUEUE_VOTEUPDOWN and "Voting" or "Chronological") .. "\n")

				-- Sort queue based on how videos will actually be played
				local sortedQueue = {}
				for _, vid in ipairs(queue) do
					table.insert(sortedQueue, vid)
				end

				if theater.GetQueueMode() == QUEUE_VOTEUPDOWN then
					-- Sort by priority first, then votes, then request time
					table.sort(sortedQueue, function(a, b)
						if a:IsPriority() and not b:IsPriority() then
							return true
						elseif b:IsPriority() and not a:IsPriority() then
							return false
						elseif a:GetNumVotes() == b:GetNumVotes() then
							return a:RequestTime() < b:RequestTime()
						else
							return a:GetNumVotes() > b:GetNumVotes()
						end
					end)
				else
					-- Chronological: priority first, then by request time
					table.sort(sortedQueue, function(a, b)
						if a:IsPriority() and not b:IsPriority() then
							return true
						elseif b:IsPriority() and not a:IsPriority() then
							return false
						else
							return a.id < b.id
						end
					end)
				end

				for idx, vid in ipairs(sortedQueue) do
					Msg("\tTitle:\t\t" .. tostring(vid:Title()) .. "\n")
					Msg("\tType:\t\t" .. tostring(vid:Type()) .. "\n")
					Msg("\tData:\t\t" .. tostring(vid:Data()) .. "\n")
					Msg("\tDuration:\t" .. string.FormatSeconds(vid:Duration()) .. "\n")
					Msg("\tVotes:\t\t" .. vid:GetNumVotes() .. "\n")
					Msg("\tPriority:\t" .. (vid:IsPriority() and "Yes" or "No") .. "\n")
					Msg(string.format("\tRequested by:\t%s (%s)\n", vid:GetOwnerName(), vid:GetOwnerSteamID()))
					Msg("\n")
				end

			end

		end

		if not foundAny then
			Msg("No queued videos in any theater.\n")
		end

	end)

	concommand.Add("cinema_get_info", function(ply, cmd, args)

		if IsValid(ply) and not ply:IsAdmin() then return end

		local videoId = tonumber(args[1])
		if not videoId then
			Msg("Usage: cinema_get_info <video_id>\n")
			return
		end

		local Theaters = theater.GetTheaters()
		local found = false

		for locId, Theater in pairs(Theaters) do

			local queue = Theater:GetQueue()

			for _, vid in ipairs(queue) do
				if vid.id == videoId then
					found = true

					Msg("Video ID:\t" .. videoId .. "\n")
					Msg("Theater:\t" .. Theater:Name() .. " (Location: " .. locId .. ")\n")
					Msg("Title:\t\t" .. tostring(vid:Title()) .. "\n")
					Msg("Type:\t\t" .. tostring(vid:Type()) .. "\n")
					Msg("Data:\t\t" .. tostring(vid:Data()) .. "\n")
					Msg("Duration:\t" .. string.FormatSeconds(vid:Duration()) .. "\n")
					Msg("Votes:\t\t" .. vid:GetNumVotes() .. "\n")
					Msg("Priority:\t" .. (vid:IsPriority() and "Yes" or "No") .. "\n")
					Msg(string.format("Requested by:\t%s (%s)\n", vid:GetOwnerName(), vid:GetOwnerSteamID()))

					break
				end
			end

			if found then break end

		end

		if not found then
			Msg("Video with ID " .. videoId .. " not found in any theater queue.\n")
		end

	end)

	/*
		Parse URLs in the chat for video requests
	*/
	hook.Add("PlayerSay", "TheaterAutoAdd", function(ply, chat)
		local Theater = ply:GetTheater()

		if Theater then
			if string.find(chat, "/", 1, true) and string.find(chat, ".", 1, true) then
				if theater.ExtractURLData(chat) then
					Theater:RequestVideo(ply, chat)

					return ""
				end
			end
		end
	end)

end
