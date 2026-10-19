---@diagnostic disable: undefined-field

module("rent", package.seeall)

Currencies = Currencies or {}
CurrencyOrder = CurrencyOrder or {}

local function getOnlinePlayer(steamID64)
	local ply = player.GetBySteamID64 and player.GetBySteamID64(steamID64)
	return IsValid(ply) and ply or nil
end

-- Register a currency provider.
--   id       : unique string identifier
--   provider : table implementing:
--                IsAvailable(ply) -> bool   (optional; whether this provider can be used)
--                CanAfford(ply, cost) -> bool
--                Take(ply, cost)
--                Give(ply, value)
--                Format(amount, ply) -> string   (e.g. "10 Points")
--                SteamID64 methods are optional and support offline purchases.
function RegisterCurrency(id, provider)
	provider.id = id
	if not Currencies[id] then
		table.insert(CurrencyOrder, id)
	end
	Currencies[id] = provider
end

-- Resolve the active currency provider for a player.
-- Set cinema_rent_currency to force a provider by id,
-- otherwise the first available provider is auto-detected.
function GetProvider(ply)
	local forced = rent.Currency()
	if forced and Currencies[forced] then
		return Currencies[forced]
	end

	for _, id in ipairs(CurrencyOrder) do
		local provider = Currencies[id]
		if not provider.IsAvailable or provider.IsAvailable(ply) then
			return provider
		end
	end

	return nil
end

-- Resolve a provider that can operate on an account without a player entity.
function GetProviderForSteamID64(steamID64)
	local ply = player.GetBySteamID64 and player.GetBySteamID64(steamID64)
	local provider = IsValid(ply) and rent.GetProvider(ply) or nil
	if not provider then
		local forced = rent.Currency()
		if forced then
			provider = Currencies[forced]
		else
			for _, id in ipairs(CurrencyOrder) do
				local candidate = Currencies[id]
				if not candidate.IsAvailable or candidate.IsAvailable(nil) then
					provider = candidate
					break
				end
			end
		end
	end

	if provider and provider.CanAffordSteamID64 and provider.TakeSteamID64 then
		return provider
	end
	return nil
end

-- Format an amount using the active provider (falls back to plain "Points").
function FormatCost(amount, ply)
	local provider = GetProvider(ply)
	if provider and provider.Format then
		return provider.Format(amount, ply)
	end

	return translations:Format("Currency_Points", amount)
end

-- Built-in provider: PointShop 2
RegisterCurrency("pointshop2", {
	GetCurrencyName = function()
		return rent.PS2UsePremiumPoints() and "Donator Points" or "Points"
	end,
	IsAvailable = function(ply)
		if SERVER then
			return IsValid(ply) and ply.PS2_Wallet ~= nil
		else
			return Pointshop2 ~= nil
		end
	end,
	CanAfford = function(ply, cost)
		if rent.PS2UsePremiumPoints() then
			return ply.PS2_Wallet.premiumPoints >= cost
		else
			return ply.PS2_Wallet.points >= cost
		end
	end,
	Take = function(ply, cost)
		if rent.PS2UsePremiumPoints() then
			ply:PS2_AddPremiumPoints(-cost)
		else
			ply:PS2_AddStandardPoints(-cost, "Private theater rent")
		end
	end,
	Give = function(ply, value)
		if rent.PS2UsePremiumPoints() then
			ply:PS2_AddPremiumPoints(value)
		else
			ply:PS2_AddStandardPoints(value, "Private theater refund")
		end
	end,
	Format = function(amount, ply)
		if rent.PS2UsePremiumPoints() then
			return translations:Format("Currency_DonatorPoints", amount)
		else
			return translations:Format("Currency_Points", amount)
		end
	end,
	CanAffordSteamID64 = function(steamID64, cost)
		local ply = getOnlinePlayer(steamID64)
		if not IsValid(ply) or not ply.PS2_Wallet then return false end
		if rent.PS2UsePremiumPoints() then
			return ply.PS2_Wallet.premiumPoints >= cost
		end
		return ply.PS2_Wallet.points >= cost
	end,
	TakeSteamID64 = function(steamID64, cost)
		local ply = getOnlinePlayer(steamID64)
		if not IsValid(ply) or not ply.PS2_Wallet then return false, "purchase_unavailable" end
		if rent.PS2UsePremiumPoints() then
			ply:PS2_AddPremiumPoints(-cost)
		else
			ply:PS2_AddStandardPoints(-cost, "Cinema web priority purchase")
		end
		return true
	end,
	GetBalanceSteamID64 = function(steamID64)
		local ply = getOnlinePlayer(steamID64)
		if not IsValid(ply) or not ply.PS2_Wallet then return nil end
		return rent.PS2UsePremiumPoints() and ply.PS2_Wallet.premiumPoints or ply.PS2_Wallet.points
	end
})

-- Built-in provider: PointShop 1
RegisterCurrency("pointshop1", {
	IsAvailable = function(ply)
		if SERVER then
			return IsValid(ply) and ply.PS_HasPoints ~= nil
		else
			return PS ~= nil
		end
	end,
	CanAfford = function(ply, cost)
		return ply:PS_HasPoints(cost)
	end,
	Take = function(ply, cost)
		ply:PS_TakePoints(cost)
	end,
	Give = function(ply, value)
		ply:PS_GivePoints(value)
	end,
	Format = function(amount, ply)
		return translations:Format("Currency_Points", amount)
	end,
	CanAffordSteamID64 = function(steamID64, cost)
		local ply = getOnlinePlayer(steamID64)
		return IsValid(ply) and ply.PS_HasPoints ~= nil and ply:PS_HasPoints(cost) or false
	end,
	TakeSteamID64 = function(steamID64, cost)
		local ply = getOnlinePlayer(steamID64)
		if not IsValid(ply) or not ply.PS_TakePoints then return false, "purchase_unavailable" end
		ply:PS_TakePoints(cost)
		return true
	end,
	GetBalanceSteamID64 = function(steamID64)
		local ply = getOnlinePlayer(steamID64)
		if not IsValid(ply) or not ply.PS_GetPoints then return nil end
		return ply:PS_GetPoints()
	end
})

-- Optional provider: Vanpoints. Its SteamID64 methods also support web purchases
-- when the account owner is offline.
RegisterCurrency("vanpoints", {
	CurrencyName = "Points",
	IsAvailable = function()
		return istable(Vanpoints) and isfunction(Vanpoints.Get) and
			(SERVER and isfunction(Vanpoints.Take) or CLIENT)
	end,
	CanAfford = function(ply, cost)
		return Vanpoints.Get(ply, 0) >= cost
	end,
	Take = function(ply, cost)
		local value, err = Vanpoints.Take(ply, cost, "Cinema priority purchase", "cinema")
		return err == nil, err
	end,
	CanAffordSteamID64 = function(steamID64, cost)
		return Vanpoints.Get(steamID64, 0) >= cost
	end,
	TakeSteamID64 = function(steamID64, cost)
		local value, err = Vanpoints.Take(steamID64, cost, "Cinema web priority purchase", "cinema")
		return err == nil, err
	end,
	Give = function(ply, value)
		local balance, err = Vanpoints.Add(ply, value, "Private theater rent refund", "cinema")
		return err == nil, err
	end,
	GetBalanceSteamID64 = function(steamID64)
		return Vanpoints.Get(steamID64, 0)
	end,
	Format = function(amount)
		return translations:Format("Currency_Points", amount)
	end
})
