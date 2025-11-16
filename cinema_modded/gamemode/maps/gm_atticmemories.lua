Location.Add( "gm_atticmemories",
{
	["Attic"] =
	{
		Min = Vector( 576, -384, 0 ),
		Max = Vector( 896, -192, 150 ),

		Theater = {
			Name = "Attic",
			Flags = THEATER_REPLICATED,
			Pos = Vector(802, -343.75, 57),
			Ang = Angle(0,180,0),
			Width = 24,
			Height = 19,
		}
	},
} )

--[[ this map is way too cramped for a table, but here's the code anyways
function SpawnPokerTables()
        if SERVER then
                for k, v in pairs(ents.FindByClass("ent_poker_game")) do
                        v:Remove()
                end

                -- protip: subtract 64 from the z value for getpos to put it on the floor
                local tables = {
                        {pos = Vector(779, -280, 0), ang = Angle(0, 90, 0)},
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
]]--
