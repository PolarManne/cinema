for k, v in pairs(ents.FindByModel("models/sunabouzu/thumbnail_case.mdl")) do
	v:Remove()
end

Location.Add( "cinema_harbl_winter", {
	[ "Rooftop" ] =
	{
		Min = Vector( 5216, 2796, 1984 ),
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

-- spawn a poker table in the bar room

function SpawnPokerTables()
	if SERVER then
			for k, v in pairs(ents.FindByClass("ent_poker_game")) do
					v:Remove()
			end

			local poker_table = ents.Create( "ent_poker_game" )

			poker_table:Spawn()
			poker_table:Activate()

			poker_table:SetPos( Vector(6096, 3040, 388) )
			poker_table:SetAngles( Angle(0, 90, 0) )

			poker_table:SetGameState(-1)
			poker_table:SetGameType(1)
			poker_table:SetBetType(0)
			poker_table:SetMaxPlayers(8)
			poker_table:SetEntryBet(100)
			poker_table:SetStartValue(1000)

			local phys = poker_table:GetPhysicsObject()
			phys:EnableMotion( false )

	end
end

hook.Add( "InitPostEntity", "cinema_SpawnPokerTables", SpawnPokerTables )