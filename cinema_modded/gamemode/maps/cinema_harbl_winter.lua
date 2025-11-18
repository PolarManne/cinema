
Location.Add( "cinema_harbl_winter", {
	[ "Rooftop" ] =
	{
		Min = Vector( 5216, 2696, 1984 ),
		Max = Vector( 6528, 3776, 3040 ),
	},
	[ "Central Theater" ] =
	{
		Min = Vector( 5761, 2688, 768 ),
		Max = Vector( 6464, 3328, 1024 ),
	},
	[ "Lounge" ] =
	{
		Min = Vector( 5824, 2752, 264 ),
		Max = Vector( 6464, 3328, 384 ),
	},
	[ "Bar" ] =
	{
		Min = Vector( 5824, 2752, 390 ),
		Max = Vector( 6464, 3328, 512 ),
	},
	[ "Cafe" ] =
	{
		Min = Vector( 5824, 2688, 1032 ),
		Max = Vector( 6464, 3328, 1151 ),
	},
	[ "Disco" ] =
	{
		Min = Vector( 5824, 2688, 1160 ),
		Max = Vector( 6464, 3392, 1407 ),
	},
	[ "Poolside" ] =
	{
		Min = Vector( 4928, 2688, 574 ),
		Max = Vector( 5760, 3456, 1408 ),
	},
	[ "Cracky-chan room" ] =
	{
		Min = Vector( 4968, 2217, 2792 ),
		Max = Vector( 5536, 2456, 2968 ),
	},
	[ "DRR DRR DRR" ] =
	{
		Min = Vector( 5832, 2760, 520 ),
		Max = Vector( 6095, 3200, 760 ),
	},
} )

function SpawnPokerTables()
        if SERVER then
                for k, v in pairs(ents.FindByClass("ent_poker_game")) do
                        v:Remove()
                end

                local tables = {
                        {pos = Vector(6016, 2944, 264), ang = Angle(0, 90, 0)},
                        {pos = Vector(5928, 2983, 520), ang = Angle(0, 90, 0)},
                        {pos = Vector(5952, 3200, 768), ang = Angle(0, 90, 0)},
                        {pos = Vector(5175, 3080, 768), ang = Angle(0, 90, 0)},
                        {pos = Vector(6208, 3136, 1032), ang = Angle(0, 90, 0)},
                        {pos = Vector(6143, 3008, 2048), ang = Angle(0, 90, 0)},
                        {pos = Vector(5152, 2336, 2792), ang = Angle(0, 90, 0)},
                        {pos = Vector(6096, 3040, 392), ang = Angle(0, 90, 0)}
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