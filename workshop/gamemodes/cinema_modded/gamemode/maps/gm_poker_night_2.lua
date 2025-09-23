Location.Add( "gm_poker_night_2",
{
	["The Inventory"] =
	{
		Min = Vector( -851, -447, 64),
		Max = Vector( 479, 180, 848),
		Theater = {
			Name = "The Inventory",
			Flags = THEATER_REPLICATED,
			Pos = Vector( -668, -261, 282 ),
			Ang = Angle(0,90,0),
			Width = 280,
			Height = 177,
		}
	},
} )

function SpawnPokerTables()
	if SERVER then
		for k, v in pairs(ents.FindByClass("ent_poker_game")) do
			v:Remove()
		end

		local tables = {
			{pos = Vector(-443, -47, 65), ang = Angle(0, 90, 0)},
			{pos = Vector(-344, -238, 65), ang = Angle(0, 90, 0)},
			{pos = Vector(-62, 13, 65), ang = Angle(0, 90, 0)},
			{pos = Vector(82, -128, 65), ang = Angle(0, 90, 0)}
		}

		for _, config in ipairs(tables) do
			local table = ents.Create("ent_poker_game")
			table:Spawn()
			table:Activate()
			table:SetPos(config.pos)
			table:SetAngles(config.ang)
			table:SetGameState(-1)
			table:SetGameType(1)
			table:SetBetType(0)
			table:SetMaxPlayers(8)
			table:SetEntryBet(100)
			table:SetStartValue(1000)
			table:GetPhysicsObject():EnableMotion(false)
		end
	end
end

hook.Add( "InitPostEntity", "cinema_SpawnPokerTables", SpawnPokerTables )
