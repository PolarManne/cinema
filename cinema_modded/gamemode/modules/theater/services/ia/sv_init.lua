local SERVICE = include "cl_init.lua"
if not SERVICE then return end

local METADATA_URL = "https://archive.org/metadata/%s"

local VALID_FORMATS = {
	["MPEG4"] = true,
	["h.264"] = true,
	["h.264 IA"] = true,
	["Ogg Video"] = true,
	["WebM"] = true,
	["MP4"] = true,
	["AVI"] = true,
	["MOV"] = true,
	["MKV"] = true,
	["Flac"] = true,
	["VBR MP3"] = true,
}

local FORMAT_PRIORITY = {
	["h.264 IA"] = 1,
	["h.264"] = 2,
	["MPEG4"] = 3,
	["MP4"] = 4,
	["WebM"] = 5,
	["Ogg Video"] = 6,
	["MOV"] = 7,
	["MKV"] = 8,
	["AVI"] = 9,
	["VBR MP3"] = 10,
	["Flac"] = 11,
}

local function EncodeArchivePath(value)
	return tostring(value or ""):gsub("([^%w%-._~/])", function(character)
		return string.format("%%%02X", string.byte(character))
	end)
end

local function SplitVideoData(value)
	local raw = tostring(value or "")
	local separator = raw:find(",", 1, true)
	if not separator then
		return raw, nil
	end

	return raw:sub(1, separator - 1), raw:sub(separator + 1)
end

local function ParseLength(value)
	if value == nil then return nil end

	local seconds = tonumber(value)
	if isnumber(seconds) then
		return seconds
	end

	if isstring(value) then
		local parts = string.Explode(":", value)
		local total = 0

		for _, part in ipairs(parts) do
			local number = tonumber(part)
			if not isnumber(number) then
				return nil
			end
			total = total * 60 + number
		end

		if #parts > 0 then
			return total
		end
	end

	return nil
end

local function FindBestVideoFile(files, requestedFile)
	local bestCandidate
	local bestPriority = math.huge

	for _, file in ipairs(files) do
		if VALID_FORMATS[file.format] and file.name then
			if requestedFile then
				local normalizedRequested = requestedFile:gsub("%+", " ")
				local normalizedFile = file.name:gsub("%+", " ")

				if file.original == normalizedRequested
					or file.name == requestedFile
					or normalizedFile == normalizedRequested then
					return file
				end
			end

			local priority = FORMAT_PRIORITY[file.format] or math.huge
			if priority < bestPriority then
				bestCandidate = file
				bestPriority = priority
			end
		end
	end

	return bestCandidate
end

local function GenerateTitle(response, file, identifier)
	if response.metadata and response.metadata.title then
		local title = response.metadata.title
		if istable(title) then
			title = title[1] or identifier
		end

		if file.name and file.name ~= title then
			local fileName = file.name:gsub("%.%w+$", ""):gsub("%+", " ")
			return title .. " - " .. fileName
		end

		return title
	end

	if file.name then
		return file.name:gsub("%.%w+$", ""):gsub("%+", " ")
	end

	return "Internet Archive: " .. identifier
end

local function GetThumbnail(files, videoFileName)
	local baseName = videoFileName:gsub("%.%w+$", "")

	for _, file in pairs(files) do
		if file.format == "Thumbnail"
			and file.original
			and file.original:find(baseName, 1, true) then
			return file.name
		end
	end
end

function SERVICE:GetVideoInfo(data, onSuccess, onFailure)
	local identifier, requestedFile = SplitVideoData(data:Data())
	if requestedFile then
		requestedFile = url.unescape(requestedFile)
	end

	local function processMetadata(body, length, headers, code)
		if code ~= 200 or not body then
			return onFailure("Failed to fetch metadata from Internet Archive")
		end

		local response = util.JSONToTable(body)
		if not response or not response.files then
			return onFailure("Invalid metadata response")
		end

		local bestMatch = FindBestVideoFile(response.files, requestedFile)
		if not bestMatch then
			return onFailure("No compatible video files found")
		end

		local duration = ParseLength(bestMatch.length)
		if not isnumber(duration) then
			return onFailure("Invalid video length in metadata")
		end

		local info = {
			title = GenerateTitle(response, bestMatch, identifier),
			duration = math.Round(duration),
			thumbnail = GetThumbnail(response.files, bestMatch.name),
			data = identifier .. "," .. EncodeArchivePath(bestMatch.name),
		}

		if onSuccess then
			pcall(onSuccess, info)
		end
	end

	self:Fetch(METADATA_URL:format(identifier), processMetadata, onFailure)
end

theater.RegisterService("ia", SERVICE)
