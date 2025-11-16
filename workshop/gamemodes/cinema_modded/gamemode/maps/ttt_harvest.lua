if !Location then return end

RELOADED = RELOADED or false

for k, v in pairs(ents.FindByModel("models/sunabouzu/thumbnail_case.mdl")) do
	v:Remove()
end

ChairOffsets = {

	["models/nova/chair_plastic01.mdl"] = {
		{ Pos = Vector(0, 0, 12), Ang = Angle(0, 0, 0) },		
	},

	["models/props_2fort/tire003.mdl"] = {
		{ Pos = Vector(2, 8, 48), Ang = Angle(0, -40, 0) },		
	},
	
	["models/props_spytech/bench001b.mdl"] = {
		{ Pos = Vector(60, -2, 18.5313), Ang = Angle(0, 0, 0) },
		{ Pos = Vector(20, -2, 18.5313), Ang = Angle(0, 0, 0) },
		{ Pos = Vector(-20, -2, 18.5313), Ang = Angle(0, 0, 0) },
		{ Pos = Vector(-60, -2, 18.5313), Ang = Angle(0, 0, 0) },
	},
	
	["models/props_spytech/bench001a.mdl"] = {
		{ Pos = Vector(15, -2, 18.5313), Ang = Angle(0, 0, 0) },
		{ Pos = Vector(-15, -2, 18.5313), Ang = Angle(0, 0, 0) },
	},
	
	["models/props_2fort/miningcrate002.mdl"] = {
		{ Pos = Vector(10, 0, 37), Ang = Angle(0, -90, 0) },		
	},
	
	["models/props_farm/wooden_barrel.mdl"] = {
		{ Pos = Vector(16, -6, 0), Ang = Angle(0, 180, -90) },		
	},
	
	["models/props_farm/tractor_tire001.mdl"] = {

		--{ Pos = Vector(0, 50, 14), Ang = Angle(0, 0, 0) },
		--{ Pos = Vector(-35.5, 35.5, 14), Ang = Angle(0, 45, 0) },
		--{ Pos = Vector(-50, 0, 14), Ang = Angle(0, 90, 0) }, -- seam
		--{ Pos = Vector(-35.5, -35.5, 14), Ang = Angle(0, 135, 0) },
		--{ Pos = Vector(0, -50, 14), Ang = Angle(0, 180, 0) },
		{ Pos = Vector(35.5, -35.5, 14), Ang = Angle(0, 225, 0) },
		{ Pos = Vector(50, 0, 14), Ang = Angle(0, 270, 0) }, -- opposite of seam
		{ Pos = Vector(35.5, 35.5, 14), Ang = Angle(0, 315, 0) },
	},
	["models/props_2fort/metalbucket001.mdl"] = {
		{ Pos = Vector(2, 0, 4), Ang = Angle(0, -90, 180) },
	},

	["models/props_2fort/trainwheel002.mdl"] = {
		{ Pos = Vector(0, 0, 38), Ang = Angle(0, 90, 0) },
	},
	
	["models/props_gameplay/haybale.mdl"] = {
		{ Pos = Vector(-6, 15, 12), Ang = Angle(0, 90, 0) },
		{ Pos = Vector(-6, -15, 12), Ang = Angle(0, 90, 0) },
	},

	["models/props_2fort/miningcrate001.mdl"] = {
		{ Pos = Vector(6, 15, 34), Ang = Angle(0, -90, 0) },
		{ Pos = Vector(6, -15, 34), Ang = Angle(0, -90, 0) },
	},
	
	["models/props_medieval/bar_bench.mdl"] = {
		{ Pos = Vector(45, 2, 20), Ang = Angle(0, 180, 0) },
		{ Pos = Vector(15, 2, 20), Ang = Angle(0, 180, 0) },
		{ Pos = Vector(-15, 2, 20), Ang = Angle(0, 180, 0) },
		{ Pos = Vector(-45, 2, 20), Ang = Angle(0, 180, 0) },
	},
	
	["models/props_medieval/anvil.mdl"] = {
		{ Pos = Vector(18, 0, 34), Ang = Angle(0, 0, 0) },
		{ Pos = Vector(-18, 0, 34), Ang = Angle(0, 0, 0) },
	},
	
	["models/props_farm/wood_pile.mdl"] = {
		{ Pos = Vector(10, 45, 6), Ang = Angle(0, -90, 0) },
		{ Pos = Vector(10, 15, 6), Ang = Angle(0, -90, 0) },
		{ Pos = Vector(10, -15, 6), Ang = Angle(0, -90, 0) },
		{ Pos = Vector(10, -45, 6), Ang = Angle(0, -90, 0) },
	},
}

Location.Add( "ttt_harvest", {
	[ "THE HILL" ] =
	{
		Min = Vector( -336, -208.0, 32 ),
		Max = Vector( 336, 208, 432 ),
		Theater = { Name = "THE HILL",
			Flags = THEATER_REPLICATED,
			Pos = Vector( 120, -166, 216 ),
			Ang = Angle(0,180,0),
			Width = 240,
			Height = 180,
			ThumbInfo = { Pos = Vector( 332, 0, 222 ), Ang = Angle( 0, 0, 0 ) }
		}
	},

	[ "BLU Garage" ] =
	{
		Min = Vector( -1000, 730, 70 ),
		Max = Vector( -792, 1192, 220 ),
		Theater = { Name = "BLU Garage",
			Flags = THEATER_PRIVATE,
			Pos = Vector( -986, 1191, 218 ),
			Ang = Angle(0,0,0),
			Width = 180,
			Height = 135,
			ThumbInfo = { Pos = Vector( -896, 828, 226 ), Ang = Angle( 0, 270, 0 ) }
		}
	},

	[ "RED Bread Storage" ] =
	{
		Min = Vector( 792, -1192, 70 ),
		Max = Vector( 1000, -730, 220 ),
		Theater = { Name = "RED Bread Storage",
			Flags = THEATER_PRIVATE,
			Pos = Vector( 986, -1191, 218 ),
			Ang = Angle(0,180,0),
			Width = 180,
			Height = 135,
			ThumbInfo = { Pos = Vector( 896, -828, 226 ), Ang = Angle( 0, 90, 0 ) }
		}
	},

	[ "BLU Barn" ] =
	{
		Min = Vector( 50, 830, 30 ),
		Max = Vector( 1050, 1400, 200 ),
		Theater = { Name = "BLU Barn",
			Flags = THEATER_REPLICATED,
			Pos = Vector( 650, 860, 180 ),
			Ang = Angle(0,180,0),
			Width = 180,
			Height = 135,
			ThumbInfo = { Pos = Vector( 320, 830, 126 ), Ang = Angle( 0, -90, 0 ) }
		}
	},

	[ "RED Barn" ] =
	{
		Max = Vector( -50, -830, 200 ),
		Min = Vector( -1050, -1400, 30 ),
		Theater = { Name = "RED Barn",
			Flags = THEATER_REPLICATED,
			Pos = Vector( -650, -860, 180 ),
			Ang = Angle(0,0,0),
			Width = 180,
			Height = 135,
			ThumbInfo = { Pos = Vector( -320, -830, 126 ), Ang = Angle( 0, 90, 0 ) }
		}
	},

	[ "BLU Sniper Deck" ] =
	{
		Min = Vector( 765, 240, 200 ),
		Max = Vector( 1450, 650, 420 ),
		Theater = { Name = "BLU Sniper Deck",
			Flags = THEATER_PRIVATE,
			Pos = Vector( 1446, 482, 400 ),
			Ang = Angle(0,270,0),
			Width = 180,
			Height = 135,
			ThumbInfo = { Pos = Vector( 1000, 527, 320 ), Ang = Angle( 0, 180, 0 ) }
		}
	},

	[ "RED Sniper Deck" ] =
	{
		Max = Vector( -765, -240, 420 ),
		Min = Vector( -1450, -650, 200 ),
		Theater = { Name = "RED Sniper Deck",
			Flags = THEATER_PRIVATE,
			Pos = Vector( -1040, -500, 400 ),
			Ang = Angle(0,180,0),
			Width = 180,
			Height = 135,
			ThumbInfo = { Pos = Vector( -1000, -527, 320 ), Ang = Angle( 0, 0, 0 ) }
		}
	},

	[ "BLU Spawn" ] =
	{
		Min = Vector( 192, 1860, 0 ),
		Max = Vector( 640, 2380, 280 ),
		Theater = { Name = "BLU Spawn",
			Flags = THEATER_REPLICATED,
			Pos = Vector( 614, 2314, 160 ),
			Ang = Angle(0,-90,0),
			Width = 200,
			Height = 150,
			ThumbInfo = { Pos = Vector( 416, 1840, 48 ), Ang = Angle( 0, -90, 0 ) }
		}
	},

	[ "RED Spawn" ] =
	{
		Max = Vector( -192, -1860, 280 ),
		Min = Vector( -640, -2380, 0 ),
		Theater = { Name = "RED Spawn",
			Flags = THEATER_REPLICATED,
			Pos = Vector( -614, -2314, 160 ),
			Ang = Angle(0,90,0),
			Width = 200,
			Height = 150,
			ThumbInfo = { Pos = Vector( -416, -1840, 48 ), Ang = Angle( 0, 90, 0 ) }
		}
	},

	[ "Secret theater" ] =
	{
		Min = Vector( 8457, -9960, 460 ),
		Max = Vector( 10995, -7450.0, 1132 ),
		Theater = { Name = "Secret theater",
			Flags = THEATER_PRIVATE,
			Pos = Vector( 10496, -9504, 1800 ),
			Ang = Angle(0,180,0),
			Width = 1600,
			Height = 1200,
		}
	},

} )


if SERVER then

	function CheckPlayerLocationManually ( ply )
		-- Check once every 12 ticks (just over 5 times per second)
		if engine.TickCount() % 12 != 0 then return end
		if !IsValid(ply) or !ply:Alive() then return end

		if ply:GetPos():InBox(Vector( 1070, 1540, 276 ), Vector( 1084, 1554, 310 )) then
			-- Random point in skybox
			ply:SetPos( Vector( 10100, -8200, 626 ) )
			ply:SetEyeAngles( Angle( -20, -105, 0 ) )
		end
		
		if ply:GetPos():InBox(Vector( -1084, -1554, 276 ), Vector( -1070, -1540, 310 )) then
			-- Another random point
			ply:SetPos( Vector( 9200, -8200, 626 ) )
			ply:SetEyeAngles( Angle( -20, -75, 0 ) )
		end

		-- Bottom of skybox (under walkable terrain)
		if ply:GetPos():InBox(Vector( 8457, -9960, 400 ), Vector( 10995, -7450.0, 459 )) then
			ply:Kill()
		end
		
	end


	function SpawnSecretCinemaTeleports(name, ip)

		models_to_remove = { 	"models/props_medical/med_ladder001.mdl",
								"models/player/engineer.mdl",
								"models/hunter/blocks/cube025x1x025.mdl" }
		
		for i, model in ipairs(models_to_remove) do
			for k, v in pairs(ents.FindByModel(model)) do
				v:Remove()
			end
		end
	--[[		
		ladders = { {	Vector(611.1321, 301.8556, 225), Angle(70.2251, -77.6722, 71.6541)},
					{	Vector(-611.1321, -301.8556, 225), Angle(109.7749, -77.6722, 251.6541) }}
					
		for i, data in ipairs(ladders) do
			ladder = ents.Create("prop_dynamic")
			ladder:SetModel("models/props_medical/med_ladder001.mdl")
			ladder:SetPos(data[1])
			ladder:SetAngles(data[2])
			ladder:SetModelScale(0.8)
			ladder:DrawShadow(false)
			ladder:PhysicsInit( SOLID_VPHYSICS )
			local physobj = ladder:GetPhysicsObject()
			local physmesh = physobj:GetMeshConvexes()
			for convexkey, convex in pairs( physmesh ) do
				for poskey, postab in pairs( convex ) do
					convex[ poskey ] = postab.pos * 0.8
				end
			end
			ladder:PhysicsInitMultiConvex( physmesh )
			ladder:Spawn()
		end

		engies =  {	{	Vector(1084, 1540, 275), Angle(0.0, 135, 0.0), 1 },
					{	Vector(-1084, -1540, 275), Angle(0.0, -45, 0.0), 0 }}

		for i, data in ipairs(engies) do
			blu_engie = ents.Create("prop_dynamic")
			blu_engie:SetModel("models/player/engineer.mdl")
			blu_engie:SetPos(data[1])
			blu_engie:SetAngles(data[2])
			blu_engie:SetModelScale(0.1)
			blu_engie:SetSkin(data[3])
			blu_engie:PhysicsInit( SOLID_NONE )
			blu_engie:Fire("SetDefaultAnimation", "taunt_russian")
			blu_engie:Fire("SetAnimation", "taunt_russian")
			blu_engie:Spawn()
		end
		]]--
		
		invisible_blocks = {	{	Vector(760, 1296, 364), Angle(90, 90, 90) },
								{	Vector(765.5, 1286.5, 420), Angle(180, 45, 90) },
								{	Vector(-760, -1296, 364), Angle(90, -90, 90) },
								{	Vector(-765.5, -1286.5, 420), Angle(180, 135, -90) }}

		for i, data in ipairs(invisible_blocks) do
			block = ents.Create("prop_dynamic")
			block:SetModel("models/hunter/blocks/cube025x1x025.mdl")
			block:SetPos(data[1])
			block:SetAngles(data[2])
			block:PhysicsInit( SOLID_VPHYSICS )
			block:DrawShadow(false)
			block:SetColor( Color(0, 0, 0, 0) )
			block:SetRenderMode( RENDERMODE_TRANSCOLOR )
			block:Spawn()
		end
		
		hook.Remove( "OnPlayerConnect", "cinema_SpawnSecretCinemaTeleports" )

	end
	
	function FixSpawnPoints()
		for k, v in pairs(ents.FindByClass("info_player_teamspawn")) do
			v:Remove()
		end
		
		spawnpoints = { Vector(1240, -186, 66), Vector(1240, -136, 66), Vector(1240, -86, 66),
						Vector(1290, -186, 66), Vector(1290, -136, 66), Vector(1290, -86, 66) }
		for i, spawnpoint in ipairs(spawnpoints) do
			spawn = ents.Create("info_player_start")
			spawn:SetPos(spawnpoint)
			spawn:SetAngles(Angle(0, 180, 0))
			spawn:Spawn()
		end
	end

	if RELOADED then
		SpawnSecretCinemaTeleports(1, 2)
	else
		hook.Add( "InitPostEntity", "cinema_FixSpawnPoints", FixSpawnPoints )
		hook.Add( "PlayerConnect", "cinema_SpawnSecretCinemaTeleports", SpawnSecretCinemaTeleports )
		hook.Add( "PlayerPostThink", "HandleChangeLocation", CheckPlayerLocationManually)
	end
	RELOADED = true

end

function SpawnPokerTables()
        if SERVER then
                for k, v in pairs(ents.FindByClass("ent_poker_game")) do
                        v:Remove()
                end

                -- protip: subtract 64 from the z value for getpos to put it on the floor
                local tables = {
                        {pos = Vector(0, 0, 39), ang = Angle(0, 90, 0)},
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
