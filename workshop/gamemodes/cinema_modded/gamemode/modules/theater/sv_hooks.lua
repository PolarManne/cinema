/*---------------------------------------------------------------------------
	Name: PreVideoQueued
	Desc: Called prior to a video being queued. Return false in a hook
		to prevent the requested video from being queued. If you'd like
		to filter videos, do so with this hook.
---------------------------------------------------------------------------*/
function GM:PreVideoQueued( Video, Theater )

	local ply = Video:GetOwner()

	-- This shouldn't happen, but we'll check just in case
	if not IsValid(ply) then return false end

	-- Disregard filtering admin requests
	if ply:IsAdmin() then return true end

	-- Public theaters should be slightly more managed
	if Theater:IsReplicated() then

		-- Limit videos to a specified maximum duration
		local MaxDuration = GetConVar("cinema_video_duration_max"):GetInt()
		if Video:Duration() > MaxDuration then

			Theater:AnnounceToPlayer( ply, {
				"Theater_PublicVideoLength",
				MaxDuration
			} )

			return false

		end

	end

	return true

end


/*---------------------------------------------------------------------------
	Name: PostVideoQueued
	Desc: Called after a video has been queued.
---------------------------------------------------------------------------*/
function GM:PostVideoQueued( Video, Theater )

end


/*---------------------------------------------------------------------------
	Name: OnFinishedPlaying
	Desc: Called after a video has finished playing,
		Will not be called if the video was skipped.
---------------------------------------------------------------------------*/
function GM:OnFinishedPlaying( Video, Theater )

end


/*---------------------------------------------------------------------------
	Name: PrePlayVideo
	Desc: Called prior to a video being played. Return false in a hook
		to prevent the video from playing. However, it will still remain
		in the video queue. If a video is suspended, the theater will not
		continue to play any videos unless otherwise set to.
---------------------------------------------------------------------------*/
function GM:PrePlayVideo( Video, Theater )
	return true
end


/*---------------------------------------------------------------------------
	Name: PostPlayVideo
	Desc: Called after a video has been set to play.
---------------------------------------------------------------------------*/
function GM:PostPlayVideo( Video, Theater )
	-- Output debug information
	Msg("Loaded Video\n")
	Msg("\tLocation:\t\t" .. tostring(Theater:Name()) .. "\n")
	Msg("\tTitle:\t\t" .. tostring(Video:Title()) .. "\n")
	Msg("\tType:\t\t" .. tostring(Video:Type()) .. "\n")
	Msg("\tData:\t\t" .. tostring(Video:Data()) .. "\n")
	Msg("\tTime:\t\t" .. tostring(startTime) .. "\n")
	Msg("\tDuration:\t" .. tostring(Video:Duration()) .. "\n")
	Msg( string.format("\tRequested by %s (%s)", Video:GetOwnerName(),
		Video:GetOwnerSteamID() ) .. "\n" )
end


/*---------------------------------------------------------------------------
	Name: PrePlayerEnterTheater
	Desc: Called right before the player has joined the theater. Returning
		false here will prevent the player from being added to the theater.
		If you're going to be implementing VIP, use this hook and move the
		player elsewhere.
---------------------------------------------------------------------------*/
function GM:PrePlayerEnterTheater( ply, Theater )

/*
	Example VIP Implementation:

	if Theater:IsPrivileged() and not ply:IsVIP() then

		-- Respawn the player
		ply:Spawn()

		-- Prevent the player from being added to the theater
		-- and being sent videos, etc.
		return false

	end
*/

	return true

end


/*---------------------------------------------------------------------------
	Name: PostPlayerEnterTheater
	Desc: Called after the playing has entered a theater.
---------------------------------------------------------------------------*/
function GM:PostPlayerEnterTheater( ply, Theater )

end


/*---------------------------------------------------------------------------
	Name: PrePlayerExitTheater
	Desc: Called before the player leaves a theater.
---------------------------------------------------------------------------*/
function GM:PrePlayerExitTheater( ply, Theater )

end


/*---------------------------------------------------------------------------
	Name: PostPlayerExitTheater
	Desc: Called after the player leaves a theater.
---------------------------------------------------------------------------*/
function GM:PostPlayerExitTheater( ply, Theater )

end


/*---------------------------------------------------------------------------
	Name: PlayerChangeTheater
	Desc: Called when the player changes location. Determines if the
		player has entered or exited a theater.
---------------------------------------------------------------------------*/
local function PlayerChangeTheater( ply, loc, old )

	local Theater = theater.GetByLocation( loc )
	local OldTheater = theater.GetByLocation( old )
	local AllowedInTheater

	-- Do this first to preserve leaving/entering order
	if Theater then
		AllowedInTheater = hook.Run( "PrePlayerEnterTheater", ply, Theater )
	end

	-- Player left theater
	if OldTheater then

		hook.Run( "PrePlayerExitTheater", ply, OldTheater )

		theater.PlayerLeave( ply, old )

		if not Theater or not AllowedInTheater then
			ply:SetInTheater(false)
		end

		hook.Run( "PostPlayerExitTheater", ply, OldTheater )

	end

	-- Player entered theater
	if Theater and AllowedInTheater then

		theater.PlayerJoin( ply, loc )
		ply:SetInTheater(true)

		hook.Run( "PostPlayerEnterTheater", ply, Theater )

	end

end
hook.Add( "PlayerChangeLocation", "TheaterInit", PlayerChangeTheater )

/*---------------------------------------------------------------------------
	Name: PreVoteSkipAccept
	Desc: Called before a voteskip is added.
		Return false to stop the skip from being added.
---------------------------------------------------------------------------*/
function GM:PreVoteSkipAccept (ply, Theater)

end

/*---------------------------------------------------------------------------
	Name: PostVoteSkipAccept
	Desc: Called after a voteskip is added.
---------------------------------------------------------------------------*/
function GM:PostVoteSkipAccept (ply, Theater)

end
