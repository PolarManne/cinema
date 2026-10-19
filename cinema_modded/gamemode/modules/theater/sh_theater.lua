module( "theater", package.seeall )

THEATER = {}

local PRIORITY_CURRENCY_PER_SECOND = 2500

function GetPriorityProvider(ply)
	if not rent or not isfunction(rent.GetProvider) then return nil end
	local provider = rent.GetProvider(ply)
	if not provider or not provider.CanAfford or not provider.Take then return nil end
	return provider
end

function IsPriorityPurchaseAvailable(ply)
	if CLIENT and not IsValid(ply) then ply = LocalPlayer() end
	if not IsValid(ply) then return false end
	return GetPriorityProvider(ply) ~= nil
end

function IsPriorityPurchaseAvailableForSteamID64(steamID64)
	if not rent or not isfunction(rent.GetProviderForSteamID64) then return false end
	local provider = rent.GetProviderForSteamID64(steamID64)
	return provider ~= nil and provider.CanAffordSteamID64 ~= nil and provider.TakeSteamID64 ~= nil
end

function GetPriorityBalanceSteamID64(steamID64)
	if not rent or not isfunction(rent.GetProviderForSteamID64) then return nil end
	local provider = rent.GetProviderForSteamID64(steamID64)
	if not provider or not provider.GetBalanceSteamID64 then return nil end
	return provider.GetBalanceSteamID64(steamID64)
end

function GetPriorityPrice(duration)
	local seconds = math.ceil(tonumber(duration) or 0)
	if seconds <= 0 then
		return 0
	end

	return seconds * PRIORITY_CURRENCY_PER_SECOND
end

function THEATER:Init( locId, info )

	local o = {}

	setmetatable( o, self )
	self.__index = self

	o.Id = locId -- Location ID
	o._Name = info.Name or "Theater"
	o._Flags = info.Flags or THEATER_NONE
	o._Pos = info.Pos or Vector(0,0,0)
	o._Ang = info.Ang or Angle(0,0,0)

	o._Width = info.Width or 128
	o._Height = info.Height or math.Round(o._Width * (9 / 16))

	if SERVER then

		-- Keep for resetting the theater
		o._OriginalName = o._Name

		-- Convert from hammer units (x10 for render scale)
		o._Width = o._Width * 10
		o._Height = o._Height * 10

		o.Players = {}
		o.Playlist = {}

		o._Video = nil

		if info.ThumbEnt then
			o:SetupThumbnailEntity( info.ThumbEnt )
		elseif info.ThumbInfo then
			o._ThumbInfo = info.ThumbInfo
			o:SetupThumbnailEntity()
		end

		o._Queue = {}
		o._QueueCount = 0

		o._SkipVotes = {}
		o._ExternalSkipVotes = {}

		o._Finished = true

		if o:IsPrivate() then
			o._QueueLocked = false
			o._Owner = nil
		end

		o:PlayDefault()

	else

		info.Title = info.Title or "NoVideoPlaying"
		o._Video = VIDEO:Init( info )

	end

	return o

end

function THEATER:Name()
	return self._Name
end

function THEATER:GetLocation()
	return self.Id
end

function THEATER:GetFlags()
	return tonumber(self._Flags) or -1
end

function THEATER:GetPos()
	return self._Pos
end

function THEATER:GetAngles()
	return self._Ang
end

function THEATER:GetSize()
	return self._Width, self._Height
end

/*
	Attributes
*/
function THEATER:IsPrivate()
	return bit.band(self._Flags, THEATER_PRIVATE) == THEATER_PRIVATE
end

function THEATER:IsPrivileged()
	return bit.band(self._Flags, THEATER_PRIVILEGED) == THEATER_PRIVILEGED
end

function THEATER:IsReplicated()
	return bit.band(self._Flags, THEATER_REPLICATED) == THEATER_REPLICATED
end

/*
	Video
*/
function THEATER:SetVideo( Video, PreventDefault )

	if not Video then return end

	self._Video = Video

	if SERVER then

		self._Video._VideoStart = (CurTime() - Video:StartTime()) + 1

		if IsValid( self._ThumbEnt ) then
			self._ThumbEnt:SetTitle( Video:Title() )
			self._ThumbEnt:SetThumbnail( Video:Thumbnail() )
		end

		if not PreventDefault then
			self._Finished = false
		end

		-- A new video always starts unpaused; never carry pause state across videos
		self._Paused = false
		self._PausedOffset = nil

		self:SendVideo()

	end

end

function THEATER:IsPlaying()
	if self:VideoType() == "" then
		return false
	elseif IsVideoTimed( self:VideoType() ) then
		return self:VideoDuration() > 0 and
			self:VideoCurrentTime() <= self:VideoDuration() + 1
	else
		return true -- Video not timed
	end
end

function THEATER:VideoType()
	return self._Video and self._Video:Type() or ""
end

function THEATER:VideoData()
	return self._Video and self._Video:Data() or ""
end

function THEATER:IsPaused()
	return self._Paused == true
end

function THEATER:VideoCurrentTime( clean )
	if self:IsPaused() and self._PausedOffset then
		if clean then
			return math.Clamp(math.Round(self._PausedOffset), 0, self:VideoDuration())
		else
			return self._PausedOffset
		end
	end
	if clean then
		return math.Clamp(math.Round(CurTime() - self:VideoStartTime()), 0, self:VideoDuration())
	else
		return CurTime() - self:VideoStartTime()
	end
end

function THEATER:VideoDuration()
	return self._Video and self._Video:Duration() or 0
end

function THEATER:VideoTime()

	if not self:IsPlaying() or not IsVideoTimed(self:VideoType()) then
		return ""
	end

	return string.FormatSeconds(self:VideoCurrentTime(true)) .. " / " .. string.FormatSeconds(self:VideoDuration())

end

function THEATER:VideoTitle()
	return self._Video and self._Video:Title() or "NoVideoPlaying"
end

function THEATER:VideoStartTime()
	return self._Video and self._Video:StartTime() or 0
end

function THEATER:VideoOwnerName()
	return self._Video and self._Video:GetOwnerName() or "Invalid"
end

function THEATER:VideoOwnerSteamID()
	return self._Video and self._Video:GetOwnerSteamID() or "STEAM_0:0:0"
end

/*
	Private Theater
*/
function THEATER:GetOwner()
	return self._Owner
end

function THEATER:Think()

	if self.NextThink and self.NextThink > CurTime() then
		return
	end

	if SERVER then

		-- Don't auto-advance while paused
		if not self:IsPaused() and not self:IsPlaying() and not self._Finished then
			self:OnFinishedPlaying()
		end

	else

		if LocalPlayer():GetLocation() ~= self:GetLocation() then return end

		-- Synchronize clientside video playback (skip while paused)
		if not self:IsPaused() and self:IsPlaying() and IsVideoTimed( self:VideoType() ) and
			( not self.NextSync or self.NextSync < RealTime() ) then

			local time = self:VideoCurrentTime()
			local panel = ActivePanel()
			if time > 5 and IsValid(panel) then

				local str = string.format(
					"if(window.theater) theater.sync(%s);", time )
				panel:QueueJavascript( str )

				self.NextSync = RealTime() + 5

			end

		end

	end

	self.NextThink = CurTime() + 1

end

if SERVER then

	function THEATER:Reset()

		self._Name = self._OriginalName

		self:ClearQueue()
		self:ClearSkipVotes()
		self:SetupThumbnailEntity()

		if self:IsPrivate() then
			self._QueueLocked = false
			self._Owner = nil
		end

		self:PlayDefault()

	end

	/*
		Thumbnail Entity
	*/
	function THEATER:SetupThumbnailEntity( ent )

		if not IsValid( self._ThumbEnt ) then

			if IsValid( ent ) then
				self._ThumbEnt = ent
			elseif self._ThumbInfo then
				self._ThumbEnt = ents.Create( "theater_thumbnail" )
				self._ThumbEnt:SetPos( self._ThumbInfo.Pos )
				self._ThumbEnt:SetAngles( self._ThumbInfo.Ang )
				self._ThumbEnt:Spawn()
			else
				return
			end

		end

		self:SyncThumbnail()

	end

	function THEATER:SyncThumbnail()

		if not IsValid( self._ThumbEnt ) then return end

		self._ThumbEnt:SetTheaterName( self:Name() )
		self._ThumbEnt:SetTitle( self:VideoTitle() )

	end

	/*
		Video Playback
	*/
	function THEATER:OnFinishedPlaying()
		hook.Run("OnFinishedPlaying", self._Video, self)

		self._Finished = true
		self:NextVideo()
	end

	function THEATER:PlayDefault()

		local info = {
			Type 		= "",
			Data 		= "",
			StartTime 	= 0,
			Duration 	= 0,
			Title 		= "NoVideoPlaying"
		}

		self:SetVideo( VIDEO:Init(info), true )

	end

	function THEATER:NextVideo()

		self:ClearSkipVotes()

		if not self:IsQueueEmpty() then

			local key
			local Video

			-- Get the next queued video, prioritizing videos marked as priority
			if GetQueueMode() == QUEUE_CHRONOLOGICAL then
				-- Find first priority video, or first non-priority video
				for k, vid in pairs(self._Queue) do
					if vid:IsPriority() then
						Video = vid
						key = k
						break
					end
				end
				
				if not Video then
					Video = self._Queue[1]
					key = 1
				end
			else
				local curVotes, topVotes = 0, 0
				local priorityVideo = nil
				local priorityKey = nil

				-- First pass: find highest voted priority video
				for k, vid in pairs(self._Queue) do
					if vid:IsPriority() then
						curVotes = vid:GetNumVotes()

						if ( (not priorityVideo) or -- first index
							( curVotes > topVotes ) or -- more votes
							( (curVotes == topVotes) and (vid:RequestTime() < priorityVideo:RequestTime()) ) ) then -- earlier request
							priorityVideo = vid
							priorityKey = k
							topVotes = curVotes
						end
					end
				end

				-- Use priority video if found, otherwise find highest voted non-priority video
				if priorityVideo then
					Video = priorityVideo
					key = priorityKey
				else
					topVotes = 0
					for k, vid in pairs(self._Queue) do
						curVotes = vid:GetNumVotes()

						if ( (not Video) or -- first index
							( curVotes > topVotes ) or -- more votes
							( (curVotes == topVotes) and (vid:RequestTime() < Video:RequestTime()) ) ) then -- earlier request
							Video = vid
							key = k
							topVotes = curVotes
						end
					end
				end
			end

			if hook.Run( "PrePlayVideo", Video, self ) ~= false then

				table.remove(self._Queue, key)

				self:SetVideo( Video )

				if Video:GetOwnerName() ~= "" then
					self:AnnounceToPlayers( {
						"Theater_VideoRequestedBy",
						Video:GetOwnerName()
					} )
				end

				hook.Run( "PostPlayVideo", Video, self )

			end

		else

			self:PlayDefault()

		end

	end

	function THEATER:RequestVideo( ply, url, force )

		-- Prevent request spam
		if IsValid(ply) and ply.LastVideoRequest and ply.LastVideoRequest + 0.3 > CurTime() then
			return
		end

		if self:IsPrivate() then

			-- Set new theater owner
			if not IsValid( self:GetOwner() ) then
				self:RequestOwner( ply )
			end

			-- Prevent requests from non-theater-owner if queue is locked
			if self:IsQueueLocked() and ply ~= self:GetOwner() then
				return self:AnnounceToPlayer( ply, "Theater_OwnerLockedQueue" )
			end

		end

		local info = ExtractURLData( url, self )

		-- Invalid request data
		if not info then
			return self:AnnounceToPlayer( ply, "Theater_InvalidRequest" )
		end

		-- Check for duplicate requests
		for _, vid in pairs(self:GetQueue()) do

			if vid:Type() == info.Type and
				vid:Data() == info.Data then

				-- Place vote for player
				vid:AddVote(ply, true)

				self:AnnounceToPlayer( ply, "Theater_AlreadyQueued" )

				return
			end

		end

		local service = GetServiceByClass( info.Type )
		if service then
			self:AnnounceToPlayer( ply, {
				"Theater_ProcessingRequest",
				service:GetName()
			} )
		end


		-- Create video object and check if the page is valid
		local vid = VIDEO:Init(info, ply)
		local VideoType = vid:Type()

		vid:RequestInfo( function( success )

			-- Revalidate video in the case its type changes
			if success and VideoType ~= vid:Type() then
				service = GetServiceByClass( vid:Type() )
				if service and service.TheaterType and not IsFlagSupported(self, service.TheaterType) then
					self:AnnounceToPlayer( ply, "Theater_InvalidRequest" )
					return
				end
			end

			-- Check for duplicate requests again in the case it was requested again while processing
			for _, video in pairs(self:GetQueue()) do

				if video:Type() == vid:Type() and
					video:Data() == vid:Data() then

					-- Place vote for player
					video:AddVote(ply, true)

					self:AnnounceToPlayer( ply, "Theater_AlreadyQueued" )

					return
				end

			end

			-- Failed to grab video info, etc.
			if not success then
				self:AnnounceToPlayer( ply, "Theater_RequestFailed" )
				return
			elseif isstring(success) then -- failure message
				self:AnnounceToPlayer( ply, success )
				return
			end

			-- Developers can decide whether or not the video should be queued
			if hook.Run( "PreVideoQueued", vid, self ) == false then return end

			-- Successful request, queue video
			self:QueueVideo( vid )

			-- Send video info to player who requested the video
			-- Used to store request history
			net.Start("PlayerVideoQueued")
				net.WriteString( url )
				net.WriteString( vid:Title() )
				net.WriteInt( vid:Duration(), 32 )
				net.WriteString( vid:Type() )
				net.WriteString( vid:Data() )
			net.Send(ply)

			self:CheckVoteSkip()

			-- Start video in the case no other video is playing
			self._Finished = false

			-- Used for logging video requests
			hook.Run( "PostVideoQueued", vid, self )

		end )

		if IsValid(ply) then
			ply.LastVideoRequest = CurTime()
		end

	end

	function THEATER:RequestVideoByIdentity(name, steamId, url, metadata, callback)
		if isfunction(metadata) and callback == nil then
			callback = metadata
			metadata = nil
		end

		local finished = false
		local function Finish(code)
			if finished then return end
			finished = true
			if callback then callback(code) end
		end

		if not isstring(name) or name == "" or #name > 64 or not isstring(steamId) or
			#steamId ~= 17 or not steamId:match("^%d+$") or not isstring(url) or
			#url < 1 or #url > 4096 then
			return Finish("invalid_request")
		end
		if self:IsPrivate() and self:IsQueueLocked() then return Finish("queue_locked") end

		local identity = "web:" .. steamId
		local info = ExtractURLData(url, self)
		if not info then return Finish("invalid_url") end

		for _, queued in pairs(self:GetQueue()) do
			if queued:Type() == info.Type and queued:Data() == info.Data then
				queued:AddExternalVote(identity, true)
				return Finish("duplicate_voted")
			end
		end

		local video = VIDEO:Init(info, nil, {
			name = name,
			steamId = steamId,
			identity = identity
		})
		video:SetExternalMetadata(metadata)
		for _, ply in ipairs(self.Players) do
			if IsValid(ply) and not ply:IsBot() then
				video:SetMetadataPlayer(ply)
				break
			end
		end
		if not IsValid(video:GetMetadataPlayer()) then
			for _, ply in ipairs(player.GetHumans()) do
				if IsValid(ply) then
					video:SetMetadataPlayer(ply)
					break
				end
			end
		end

		local originalType = video:Type()
		timer.Simple(90, function()
			Finish("request_failed")
		end)
		video:RequestInfo(function(success)
			if finished then return end

			if success and originalType ~= video:Type() then
				local service = GetServiceByClass(video:Type())
				if service and service.TheaterType and not IsFlagSupported(self, service.TheaterType) then
					return Finish("invalid_url")
				end
			end

			for _, queued in pairs(self:GetQueue()) do
				if queued:Type() == video:Type() and queued:Data() == video:Data() then
					queued:AddExternalVote(identity, true)
					return Finish("duplicate_voted")
				end
			end

			if not success or isstring(success) then return Finish("request_failed") end
			if hook.Run("TheaterValidateExternalVideoRequest", identity, self) ~= true then
				return Finish("not_joined")
			end
			if self:IsReplicated() and video:Duration() >
				GetConVar("cinema_video_duration_max"):GetInt() then
				return Finish("duration_exceeded")
			end
			if hook.Run("PreVideoQueued", video, self) == false then return Finish("rejected") end

			self:QueueVideo(video)
			if self:NumPlayers() > 0 then
				self:CheckVoteSkip()
			end
			self._Finished = false
			hook.Run("PostVideoQueued", video, self)
			Finish("ok")
		end)
	end

	function THEATER:Seek( seconds )

		if not IsVideoTimed(self:VideoType()) then return end

		-- Get the plus or minus sign for later.
		local frontsign = seconds[1] or ""

		-- Seconds isn't a number, check HH:MM:SS
		if not tonumber(seconds) then
			seconds = util.ConvertTimeToSeconds(seconds)
		end

		-- If it's not one of those two things then it will fall trough wihtout any changes.
		if frontsign == "+" then
			seconds = self:VideoCurrentTime(true) + math.abs(seconds)
		elseif frontsign == "-" then
			seconds = self:VideoCurrentTime(true) - math.abs(seconds)
		end

		-- Clamp video seek time between 0 and video duration
		seconds = math.Clamp(tonumber(seconds), 0, self:VideoDuration())

		-- Convert seek seconds to time after video start
		if self._Video then
			self._Video._VideoStart = CurTime() - seconds
		end

		net.Start("TheaterSeek")
			net.WriteFloat( self:VideoStartTime() )
		net.Send(self.Players)

	end

	function THEATER:SetPaused( paused )

		-- Only timed videos can be paused (live/untimed excluded)
		if not IsVideoTimed(self:VideoType()) then return end
		if not self._Video then return end

		if paused then
			if self:IsPaused() then return end
			-- Capture the frozen position
			self._PausedOffset = self:VideoCurrentTime()
			self._Paused = true
		else
			if not self:IsPaused() then return end
			-- Same math as Seek: realign the start clock to the frozen offset
			self._Video._VideoStart = CurTime() - (self._PausedOffset or 0)
			self._Paused = false
			self._PausedOffset = nil
		end

		net.Start("TheaterPause")
			net.WriteBool( self:IsPaused() )
			if not self:IsPaused() then
				-- Send the exact realigned start time so clients match precisely
				net.WriteFloat( self:VideoStartTime() )
			end
		net.Send(self.Players)

	end

	function THEATER:SendVideo( ply )

		-- Remove player if they aren't valid
		if ply and not IsValid(ply) then
			self:RemovePlayer(ply)
			return
		end

		-- Delay for networking latency
		timer.Simple( 0.1, function()

			if not self then return end

			net.Start("TheaterVideo")

				net.WriteString( self:VideoType() )
				net.WriteString( self:VideoData() )
				net.WriteString( self:VideoTitle() )
				net.WriteString( self:VideoOwnerName() )
				net.WriteString( self:VideoOwnerSteamID() )

				-- Timed video information
				if IsVideoTimed(self:VideoType()) then
					net.WriteFloat( self:VideoStartTime() )
					net.WriteInt( self:VideoDuration(), 32 )
					net.WriteBool( self:IsPaused() )
					if self:IsPaused() then
						net.WriteFloat( self:VideoCurrentTime() )
					end
				end

				-- Private theater owner
				if self:IsPrivate() then
					net.WriteEntity( self:GetOwner() )
				end

			net.Send(ply or self.Players) -- sent to specific player if specified

		end )

	end

	/*
		Queue
	*/
	function THEATER:GetQueue()
		return self._Queue
	end

	function THEATER:ClearQueue()
		if not self._Queue then return end
		table.Empty(self._Queue)
		self._QueueCount = 0
	end

	function THEATER:IsQueueEmpty()
		return table.Count(self._Queue) == 0
	end

	function THEATER:QueueVideo( video )
		video.id = self._QueueCount
		video.theaterId = self.Id
		table.insert(self._Queue, video)
		self._QueueCount = self._QueueCount + 1
	end

	function THEATER:VoteQueuedVideo( ply, id, positive )

		if not IsValid(ply) or not id then return end
		if not IsVoteQueueMode() then return end
		-- Mode 1 is upvote-only; ignore downvotes
		if not positive and not AllowsDownvote() then return end

		for _, vid in pairs(self._Queue) do
			if vid.id == id then
				vid:AddVote(ply, positive)
				break
			end
		end

	end

	function THEATER:VoteQueuedVideoByIdentity(identity, id, positive)
		id = tonumber(id)
		if not isstring(identity) or not id then return false, "invalid_vote" end
		if GetQueueMode() ~= QUEUE_VOTEUPDOWN then return false, "voting_disabled" end

		for _, vid in pairs(self._Queue) do
			if vid.id == id then
				return vid:AddExternalVote(identity, positive), "ok"
			end
		end

		return false, "queue_item_missing"
	end

	function THEATER:RemoveQueuedVideo( ply, id )

		id = tonumber(id)
		if not IsValid(ply) or not id then return end

		for k, vid in pairs(self._Queue) do
			if vid.id == id then

				-- Remove video if player is video owner, theater owner, or an admin
				if vid:IsOwner(ply) or
					(self:GetOwner() == ply) or -- private theater
					ply:IsAdmin() then

					table.remove(self._Queue, k)

				end

				break

			end
		end

	end

	function THEATER:RemoveQueuedVideoBySteamID64(steamId, id)
		if not isstring(steamId) or not steamId:match("^%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d$") or
			not isnumber(id) then return false, "invalid_request" end

		for index, video in ipairs(self._Queue) do
			if video.id == id then
				if not video:IsOwnerSteamID64(steamId) then return false, "not_owner" end
				table.remove(self._Queue, index)
				return true, "ok"
			end
		end

		return false, "queue_item_missing"
	end

	function THEATER:ToggleVideoPriority( ply, id, action )

		id = tonumber(id)
		if not IsValid(ply) or not id then return end

		for _, vid in pairs(self._Queue) do
			if vid.id == id then

				local isPrivileged = (self:GetOwner() == ply) or ply:IsAdmin()

				if isPrivileged then
					vid:SetPriority(not vid:IsPriority())
					break
				end

				-- Non-privileged users can only purchase priority for their own videos.
				if not vid:IsOwner(ply) then
					break
				end

				-- Purchased priority cannot be used to remove priority status.
				if vid:IsPriority() then
					break
				end

				if action ~= "purchase" then
					break
				end

				if not IsPriorityPurchaseAvailable(ply) then
					if SERVER then
						ply:ChatPrint("Priority purchasing is currently disabled.")
					end
					break
				end

				local price = GetPriorityPrice(vid:Duration())
				if price <= 0 then
					if SERVER then
						ply:ChatPrint("Priority cannot be purchased for live streams.")
					end
					break
				end

				local provider = GetPriorityProvider(ply)
				if not provider then
					ply:ChatPrint("Priority purchasing is currently unavailable.")
					break
				end

				if not provider.CanAfford(ply, price) then
					ply:ChatPrint("You do not have enough currency to purchase priority.")
					break
				end

				local purchased, reason = provider.Take(ply, price)
				if purchased == false or reason then
					if SERVER then
						ply:ChatPrint("Unable to process the priority purchase.")
					end
					break
				end

				vid:SetPriority(true)

				break

			end
		end

	end

	function THEATER:PurchaseQueuedVideoPriorityBySteamID64( steamId, id )

		if not isstring(steamId) or not steamId:match("^%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d$") or
			not isnumber(id) then return false, "invalid_request" end

		for _, vid in pairs(self._Queue) do
			if vid.id == id then
				if not vid:IsOwnerSteamID64(steamId) then return false, "not_owner" end
				if vid:IsPriority() then return false, "already_priority" end
				if not IsPriorityPurchaseAvailableForSteamID64(steamId) then
					return false, "purchase_unavailable"
				end

				local price = GetPriorityPrice(vid:Duration())
				if price <= 0 then return false, "live_video" end

				local provider = rent and rent.GetProviderForSteamID64 and
					rent.GetProviderForSteamID64(steamId)
				if not provider or not provider.CanAffordSteamID64 or not provider.TakeSteamID64 then
					return false, "purchase_unavailable"
				end
				if not provider.CanAffordSteamID64(steamId, price) then
					return false, "insufficient_currency"
				end

				local purchased, reason = provider.TakeSteamID64(steamId, price)
				if purchased == false or reason then
					local resultCodes = {
						insufficient_currency = true,
						purchase_failed = true,
						purchase_unavailable = true
					}
					return false, resultCodes[reason] and reason or "purchase_failed"
				end

				vid:SetPriority(true)
				return true, "ok"
			end
		end

		return false, "queue_item_missing"
	end

	/*
		Vote Skip
	*/
	function THEATER:SkipVideo()
		self:NextVideo()
	end

	function THEATER:NumVoteSkips()
		self:ValidateSkipVotes()
		self:ValidateExternalSkipVotes()

		local count = table.Count(self._SkipVotes)
		for identity in pairs(self._ExternalSkipVotes) do
			local ply = hook.Run("TheaterResolveExternalSkipVoter", identity, self)
			if not IsValid(ply) or not table.HasValue(self._SkipVotes, ply) then
				count = count + 1
			end
		end
		return count
	end

	function THEATER:NumRequiredVoteSkips()

		local ratio = math.Clamp( GetConVar("cinema_skip_ratio"):GetFloat() or 2 / 3, -1, 1 )

		if ratio < 0 then
			return -1
		end
		local externalPlayers = tonumber(hook.Run("TheaterGetExternalPlayerCount", self)) or 0
		local numply = self:NumPlayers() + math.max(0, math.floor(externalPlayers))
		if numply == 1 then
			return 1
		elseif numply > 0 and numply < 3 then
			return 2 -- prevent players from walking in private theaters and skipping
		else
			return math.Round( numply * ratio )
		end

	end

	function THEATER:ClearSkipVotes()
		self._SkipVotes = self._SkipVotes or {}
		table.Empty(self._SkipVotes)
		self._ExternalSkipVotes = self._ExternalSkipVotes or {}
		table.Empty(self._ExternalSkipVotes)
	end

	function THEATER:ValidateSkipVotes()
		for k, ply in pairs(self._SkipVotes) do
			if not IsValid(ply) then
				table.remove(self._SkipVotes, k)
			end
		end
	end

	function THEATER:ValidateExternalSkipVotes()
		self._ExternalSkipVotes = self._ExternalSkipVotes or {}
		for identity in pairs(self._ExternalSkipVotes) do
			if hook.Run("TheaterValidateExternalSkipVote", identity, self) ~= true then
				self._ExternalSkipVotes[identity] = nil
			end
		end

	end

	function THEATER:HasPlayerVotedToSkip( ply )
		if table.HasValue(self._SkipVotes, ply) then return true end
		self:ValidateExternalSkipVotes()
		local identity = hook.Run("TheaterGetExternalSkipVoteIdentity", ply, self)
		return isstring(identity) and self._ExternalSkipVotes[identity] == true
	end

	function THEATER:HasExternalVotedToSkip( identity )
		self:ValidateExternalSkipVotes()
		if self._ExternalSkipVotes[identity] == true then return true end
		local ply = hook.Run("TheaterResolveExternalSkipVoter", identity, self)
		return IsValid(ply) and table.HasValue(self._SkipVotes, ply)
	end

	function THEATER:GetExternalSkipVotes()
		self:ValidateExternalSkipVotes()
		return self._ExternalSkipVotes
	end

	function THEATER:GetSkipVotes()
		self:ValidateSkipVotes()
		return self._SkipVotes
	end

	function THEATER:VoteSkipByIdentity( identity, voterName )
		if not isstring(identity) or #identity < 1 or #identity > 64 then return false, "invalid_vote" end
		voterName = isstring(voterName) and string.Trim(voterName) or "Web player"
		if #voterName < 1 or #voterName > 64 or voterName:find("[%z\1-\31\127]") then
			return false, "invalid_vote"
		end
		if self:IsQueueLocked() then return false, "queue_locked" end
		if not self:IsPlaying() then return false, "nothing_playing" end
		if self:NumRequiredVoteSkips() == -1 then return false, "voting_disabled" end
		if hook.Run("TheaterValidateExternalSkipVote", identity, self) ~= true then
			return false, "not_joined"
		end
		if self:HasExternalVotedToSkip(identity) then return false, "already_voted" end
		if hook.Run("PreExternalVoteSkipAccept", identity, self) == false then return false, "rejected" end

		self._ExternalSkipVotes[identity] = true
		hook.Run("PostExternalVoteSkipAccept", identity, self)

		net.Start( "TheaterVoteSkips" )
			net.WriteString( voterName )
			net.WriteUInt( self:NumVoteSkips(), 16 )
			net.WriteUInt( self:NumRequiredVoteSkips(), 16 )
		net.Send( self.Players )

		self:CheckVoteSkip()
		return true, "ok"
	end

	function THEATER:VoteSkip( ply )

		-- Can't vote skip if the queue is locked
		if self:IsQueueLocked() then return end

		-- Can't vote skip if a video isn't playing
		if not self:IsPlaying() then return end

		-- Check to see if voteskip is disabled
		if self:NumRequiredVoteSkips() == -1 then
			return self:AnnounceToPlayer( ply, "Theater_VoteSkipDisabled" )
		end

		-- Validate vote skips before checking them
		self:ValidateSkipVotes()

		-- Ensure the player hasn't already voted
		if self:HasPlayerVotedToSkip(ply) then return end

		-- Give hooks a chance to deny the voteskip
		if hook.Run("PreVoteSkipAccept", ply, self) == false then return end
		
		-- Insert player into list of vote skips
		table.insert(self._SkipVotes, ply)

		-- Run post accept hook
		hook.Run("PostVoteSkipAccept", ply, self)

		-- Notify theater players of vote skip
		net.Start( "TheaterVoteSkips" )
			net.WriteString( ply:Nick() )
			net.WriteUInt( self:NumVoteSkips(), 16 )
			net.WriteUInt( self:NumRequiredVoteSkips(), 16 )
		net.Send( self.Players )

		-- Check if the current video can be skipped
		self:CheckVoteSkip()

	end

	function THEATER:CheckVoteSkip()

		-- Can't skip if the queue is locked
		if self:IsQueueLocked() then return end

		-- Can't skip if voteskip is disabled or nobody can vote
		local required = self:NumRequiredVoteSkips()
		if required <= 0 then return end

		-- Skip the current video if the voteskip requirement is met
		if self:NumVoteSkips() >= required then

			self:AnnounceToPlayers( "Theater_Voteskipped" )

			self:SkipVideo()

		end

	end


	/*
		Players
	*/
	function THEATER:NumPlayers()
		return table.Count(self.Players)
	end

	function THEATER:HasPlayer( ply )
		return table.HasValue(self.Players, ply)
	end

	function THEATER:AddPlayer( ply )

		-- Don't bother if the player is already in the list
		if self:HasPlayer( ply ) then return end

		-- Add the player to the list
		table.insert(self.Players, ply)

		-- Send theater info
		RequestTheaterInfo(ply, true)

		-- Send current video
		self:SendVideo(ply)

		-- Disable the player's flashlight
		if ply:FlashlightIsOn() then
			ply:Flashlight(false)
		end

	end

	function THEATER:RemovePlayer( ply )

		-- Don't bother if the player isn't in the list
		if not self:HasPlayer( ply ) then return end

		-- Remove player from list
		table.RemoveByValue(self.Players, ply)

		-- Remove player from vote skip table if they have voted
		if self:HasPlayerVotedToSkip( ply ) then
			table.RemoveByValue(self._SkipVotes, ply)
		end

		-- Notify player of leaving the theater
		net.Start("PlayerLeaveTheater")
		net.Send(ply)

		-- Owner leaving private theater
		if self:IsPrivate() and ply == self:GetOwner() then
			self:ResetOwner()
			self:AnnounceToPlayer( ply, "Theater_LostOwnership" )
		end

		-- Players remain in the theater
		if self:NumPlayers() > 0 then

			self:CheckVoteSkip()

		-- No player remain in the theater
		else
			-- Reset private theaters (and public if allowed)
			if self:IsPrivate() or GetConVar("cinema_allow_reset"):GetBool() then
				self:Reset()
			end
		end

	end

	function THEATER:AnnounceToPlayers( tbl )
		self:AnnounceToPlayer( self.Players, tbl )
	end

	function THEATER:AnnounceToPlayer( ply, tbl )

		-- Single message without coloring
		if isstring(tbl) then
			tbl = { tbl }
		end

		-- Send announcement to all players or a single player
		if istable(ply) or IsValid(ply) then
			net.Start( "TheaterAnnouncement" )
				net.WriteTable( tbl )
			net.Send(ply)
		end

	end

	/*
		Private Theater
	*/
	function THEATER:ResetOwner()
		self._Owner = nil
		self._QueueLocked = false
	end

	function THEATER:RequestOwner( ply )

		if not IsValid( ply ) then return end
		if IsValid( self:GetOwner() ) then return end

		self._Owner = ply
		self:AnnounceToPlayer( ply, "Theater_NotifyOwnership" )

		RequestTheaterInfo(ply)

	end

	function THEATER:IsQueueLocked()
		return self._QueueLocked
	end

	function THEATER:ToggleQueueLock( ply )

		if not IsValid(ply) then return end

		-- Toggle theater queue lock
		self._QueueLocked = not self._QueueLocked

		-- Notify theater players of change
		self:AnnounceToPlayers( {
			self:IsQueueLocked() and "Theater_LockedQueue" or "Theater_UnlockedQueue",
			ply:Nick()
		} )

	end

	function THEATER:SetName( name, ply )

		if not IsValid(ply) then return end

		-- Theater must be private and player must be the owner
		if not self:IsPrivate() or ply ~= self:GetOwner() then return end

		-- Clamp new name to 32 chars
		self._Name = string.sub(name,0,32)
		self:SyncThumbnail()

	end

end
