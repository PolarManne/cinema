module( "theater", package.seeall )

VIDEO = {}

function VIDEO:Init( info, ply, externalOwner )

	local o = {}

	setmetatable( o, self )
	self.__index = self

	if SERVER then
		o.id = -1 			-- set by theater
		o.theaterId = -1 	-- set by theater

		o._RequestTime = CurTime()
		o._Owner = ply
		o._OwnerName = IsValid(ply) and ply:Nick() or
			(istable(externalOwner) and externalOwner.name or "") -- in case they disconnect
		o._OwnerSteamID = IsValid(ply) and ply:SteamID() or
			(istable(externalOwner) and externalOwner.steamId or "")
		o._OwnerSteamID64 = IsValid(ply) and not ply:IsBot() and ply:SteamID64() or
			(istable(externalOwner) and externalOwner.steamId or "")
		o._ExternalOwnerIdentity = istable(externalOwner) and externalOwner.identity or nil
		o._MetadataPlayer = nil

		o._Votes = {}
		o._ExternalVotes = {}

		if o._ExternalOwnerIdentity then
			o:AddExternalVote(o._ExternalOwnerIdentity, true)
		else
			o:AddVote(ply, true)
		end
	else
		o._OwnerName = info.OwnerName
		o._OwnerSteamID = info.OwnerSteamID
	end


	o._VideoType = info.Type or ""
	o._VideoData = info.Data or ""
	o._VideoStart = info.StartTime or 0

	o._VideoTitle = string.gsub(info.Title or "(Unknown)", "%%", "%%%%")
	o._VideoDuration = info.Duration or 0
	o._VideoThumbnail = info.Thumbnail and isstring(info.Thumbnail) and info.Thumbnail or ""

	if SERVER then
		o._Priority = false -- prioritized videos go to top of queue
	end

	return o

end

function VIDEO:Type()
	return self._VideoType
end

function VIDEO:Data()
	return self._VideoData
end

function VIDEO:Title()
	return self._VideoTitle
end

function VIDEO:Duration()
	return self._VideoDuration
end

function VIDEO:StartTime()
	return self._VideoStart
end

function VIDEO:Thumbnail()
	return self._VideoThumbnail
end

if SERVER then

	function VIDEO:IsPriority()
		return self._Priority or false
	end

	function VIDEO:SetPriority( priority )
		self._Priority = tobool(priority)
	end

end

/*
	Owner
*/
function VIDEO:GetOwner()
	return self._Owner
end

function VIDEO:IsOwner( ply )
	if not IsValid(ply) then return false end
	if self._Owner == ply then return true end
	if not SERVER or ply:IsBot() then return false end

	local steamId = self._OwnerSteamID
	if isstring(steamId) and steamId ~= "" and steamId == ply:SteamID() then
		return true
	end

	return self:IsOwnerSteamID64(ply:SteamID64())
end

function VIDEO:GetMetadataPlayer()
	return self._MetadataPlayer
end

function VIDEO:SetMetadataPlayer( ply )
	if SERVER then
		self._MetadataPlayer = IsValid(ply) and ply or nil
	end
end

function VIDEO:SetExternalMetadata( metadata )
	if not SERVER or not istable(metadata) then return end
	for key in pairs(metadata) do
		if key ~= "title" and key ~= "duration" and key ~= "isLive" then return end
	end
	if not isnumber(metadata.duration) or metadata.duration ~= metadata.duration or
		metadata.duration < 0 or metadata.duration > 31536000 then return end
	if metadata.title ~= nil and (not isstring(metadata.title) or #metadata.title < 1 or
		#metadata.title > 1024 or metadata.title:find("[%z\1-\31\127]")) then return end
	if metadata.isLive ~= nil and not isbool(metadata.isLive) then return end

	self._ExternalMetadata = {
		duration = math.Round(metadata.duration),
		title = metadata.title,
		isLive = metadata.isLive
	}
end

function VIDEO:ConsumeExternalMetadata()
	local metadata = self._ExternalMetadata
	self._ExternalMetadata = nil
	return metadata
end

function VIDEO:GetOwnerName()
	if IsValid(self:GetOwner()) then
		return self:GetOwner():Nick()
	else
		return self._OwnerName
	end
end

function VIDEO:GetOwnerSteamID()
	if IsValid(self:GetOwner()) then
		return self:GetOwner():SteamID()
	else
		return self._OwnerSteamID
	end
end

function VIDEO:GetExternalOwnerIdentity()
	return self._ExternalOwnerIdentity
end

function VIDEO:IsExternalRequest()
	return isstring(self._ExternalOwnerIdentity)
end

if SERVER then
	function VIDEO:GetOwnerSteamID64()
		if isstring(self._OwnerSteamID64) and self._OwnerSteamID64:match("^%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d$") then
			return self._OwnerSteamID64
		end

		local owner = self:GetOwner()
		if IsValid(owner) and not owner:IsBot() then
			return owner:SteamID64()
		end

		local steamId = self._OwnerSteamID
		if isstring(steamId) and steamId:match("^%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d$") then
			return steamId
		end
		if isstring(steamId) and steamId:match("^STEAM_%d:%d:%d+$") then
			local converted = util.SteamIDTo64(steamId)
			if isstring(converted) and converted:match("^%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d$") then
				return converted
			end
		end

		return ""
	end

	function VIDEO:IsOwnerSteamID64(steamId)
		return isstring(steamId) and steamId:match("^%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d$") ~= nil and
			self:GetOwnerSteamID64() == steamId
	end

	function VIDEO:RequestTime()
		return self._RequestTime
	end

	/*
		Votes
	*/
	function VIDEO:GetVotes()
		return self._Votes
	end

	function VIDEO:GetNumVotes()
		self:ValidateVotes()
		self:ValidateExternalVotes()
		local count = 0
		for _, vote in pairs(self._Votes) do
			count = count + vote.value
		end
		for identity, value in pairs(self._ExternalVotes) do
			local ply = hook.Run("TheaterResolveExternalVideoVoter", identity, self)
			if not IsValid(ply) or not self:GetVoteByPlayer(ply) then
				count = count + value
			end
		end
		return count
	end

	function VIDEO:GetExternalVotes()
		self._ExternalVotes = self._ExternalVotes or {}
		self:ValidateExternalVotes()
		return self._ExternalVotes
	end

	function VIDEO:ValidateExternalVotes()
		self._ExternalVotes = self._ExternalVotes or {}
		for identity in pairs(self._ExternalVotes) do
			if hook.Run("TheaterValidateExternalVideoVote", identity, self) ~= true then
				self._ExternalVotes[identity] = nil
			end
		end
	end

	function VIDEO:AddExternalVote(identity, positive)
		if not isstring(identity) or #identity < 1 or #identity > 64 then return false end
		self._ExternalVotes = self._ExternalVotes or {}
		local ply = hook.Run("TheaterResolveExternalVideoVoter", identity, self)
		if IsValid(ply) then
			return self:AddVote(ply, positive)
		end
		local value = positive and 1 or -1
		if self._ExternalVotes[identity] == value then
			self._ExternalVotes[identity] = nil
		else
			self._ExternalVotes[identity] = value
		end
		return true
	end

	function VIDEO:ValidateVotes()
		for k, v in pairs(self._Votes) do
			if not IsValid(v.owner) then
				table.remove(self._Votes, k)
			else
				-- Make sure the player is still in the theater
				if not v.owner:InTheater() or v.owner:GetLocation() ~= self.theaterId then
					table.remove(self._Votes, k)
				end
			end
		end
	end

	function VIDEO:RemoveVoteByPlayer(ply)
		for k, v in pairs(self._Votes) do
			if v.owner == ply then
				table.remove(self._Votes, k)
				break
			end
		end
	end

	function VIDEO:GetVoteByPlayer(ply)
		for _, vote in pairs(self._Votes) do
			if vote.owner == ply then
				return vote
			end
		end
	end

	function VIDEO:HasPlayerVoted(ply)
		return self:GetVoteValueByPlayer(ply) ~= nil
	end

	function VIDEO:GetVoteValueByPlayer(ply)
		local vote = self:GetVoteByPlayer(ply)
		if vote then return vote.value end

		self:ValidateExternalVotes()
		local identity = hook.Run("TheaterGetExternalVideoVoteIdentity", ply, self)
		return isstring(identity) and self._ExternalVotes[identity] or nil
	end

	function VIDEO:AddVote( ply, positive )

		if not IsValid(ply) then return false end
		self:ValidateExternalVotes()

		local vote = self:GetVoteByPlayer(ply)
		local externalIdentity = hook.Run("TheaterGetExternalVideoVoteIdentity", ply, self)
		local externalValue = isstring(externalIdentity) and self._ExternalVotes[externalIdentity] or nil
		if vote and externalValue then
			self._ExternalVotes[externalIdentity] = nil
			externalValue = nil
		end

		if vote then

			if (vote.value > 0 and positive) or (vote.value < 0 and not positive) then
				self:RemoveVoteByPlayer(ply)
			else
				vote.value = positive and 1 or -1
			end

		elseif externalValue then

			if (externalValue > 0 and positive) or (externalValue < 0 and not positive) then
				self._ExternalVotes[externalIdentity] = nil
			else
				self._ExternalVotes[externalIdentity] = positive and 1 or -1
			end

		else

			table.insert(self._Votes, {
				owner = ply,
				value = positive and 1 or -1
			})

		end
		return true

	end

	/*

	*/
	function VIDEO:RequestInfo( callback )

		if not callback then return end

		if self:Type() ~= "" then

			-- Query info from local database
			local results = IsVideoCacheable(self:Type()) and
				GetVideoLog(self:Data(), self:Type()) or nil
			if results ~= nil and istable(results) then

				results = results[1]

				self._VideoTitle = results.title or "(Unknown)"
				self._VideoDuration = tonumber(results.duration) or -1
				self._VideoThumbnail = results.thumbnail or ""

				callback(true)

			else

				local function loadFailure(code)
					if isstring(code) then
						callback(code)
					else
						callback(false)
					end
				end

				-- Query info from API
				local status, err = pcall( GetVideoInfo, self, function(info)
					self._VideoTitle = url.htmlentities_decode(info.title) or "(Unknown)"
					self._VideoDuration = tonumber(info.duration) or -1
					self._VideoThumbnail = info.thumbnail or ""

					if info.data then
						self._VideoData = info.data
					end

					if info.type then
						self._VideoType = info.type
					end

					-- Problem grabbing duration data
					if IsVideoTimed(self:Type()) and self._VideoDuration <= 0 then
						return callback(false)
					end

					callback(true)
				end, loadFailure)

				-- Something went wrong while grabbing the video info
				if not status then
					callback(false)
				end

			end

		else
			callback(false)
		end

	end

end
