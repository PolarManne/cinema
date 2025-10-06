hook.Add( "InitPostEntity", "dooka_cinema_v3b", function()
if !Location then return end

// remove a couple of bad thumbnail entities that are baked into the bsp
for k, v in pairs(ents.FindByClass("theater_thumbnail")) do
	v:Remove()
end

ChairOffsets = {
	["models/props_trainstation/traincar_seats001.mdl"] = {
		{ Pos = Vector(4.6150, 41.7277, 18.5313) },
		{ Pos = Vector(4.7320, 14.4948, 18.5313) },
		{ Pos = Vector(4.5561, -13.3913, 18.5313) },
		{ Pos = Vector(5.4507, -40.9903, 18.5313) },
	},
	
	["models/props_c17/bench01a.mdl"] = {
		{ Pos = Vector(4, 25, 0), Ang = Angle(0, 270, 0) },
		{ Pos = Vector(4, 0, 0), Ang = Angle(0, 270, 0) },
		{ Pos = Vector(4, -25, 0), Ang = Angle(0, 270, 0) },
	},
	
	["models/props_c17/furniturecouch002a.mdl"] = {
		{ Pos = Vector(0, -10, -5), Ang = Angle(0, 270, 0) },
		{ Pos = Vector(0, 10, -5), Ang = Angle(0, 270, 0) },
	},
	
	["models/props_c17/chair_stool01a.mdl"] = {
		{ Pos = Vector(5, 0, 35), Ang = Angle(0, 90, 0) },
	},
	
	["models/props_c17/furnituretoilet001a.mdl"] = {
		{ Pos = Vector(5, 0, -30), Ang = Angle(0, 270, 0) },
	},
	
	["models/props_interiors/furniture_couch02a.mdl"] = {
		{ Pos = Vector(5, 0, -10), Ang = Angle(0, 270, 0) },
	},
	
	["models/props_c17/furniturecouch001a.mdl"] = {
		{ Pos = Vector(5, -15, -5), Ang = Angle(0, 270, 0) },
		{ Pos = Vector(5, 15, -5), Ang = Angle(0, 270, 0) },
	},
	
	["models/props_trainstation/traincar_rack001.mdl"] = {
		{ Pos = Vector(4.6150, 41.7277, 3) },
		{ Pos = Vector(4.7320, 14.4948, 3) },
		{ Pos = Vector(4.5561, -13.3913, 3) },
		{ Pos = Vector(5.4507, -40.9903, 3) },
	},
	
	["models/props_c17/gravestone001a.mdl"] = {
		{ Pos = Vector(-5, 0, 43), Ang = Angle(0, 270, 0) },
	},
}

Location.Add( "dooka_cinema_v3b", {
	[ "Lobby" ] =
	{
		Min = Vector( 753.76177978516, 694.04486083984, -25.248229980469 ),
		Max = Vector( 3065, 3345.3732910156, 410.38977050781 ),
	},

	[ "Public Theater" ] = {
		Min = Vector( 1063.5466308594, -2347.2451171875, -1058.15625 ),
		Max = Vector( 2532.8198242188, -1442.6888427734, -321.35699462891 ),
		Theater = { Name = "Public Theater",
			Flags = THEATER_REPLICATED,
			Pos = Vector( 2289, -2314, -475 ),
			Ang = Angle(0,180,0),
			Width = 955,
			Height = 452,
			ThumbInfo = { Pos = Vector( 1811.01, -556, -19 ), Ang = Angle( 0, 90, 0 ) }
		}
	},

	[ "Bar" ] = {
		Min = Vector( 1265.6531982422, -414.85751342773, 196.82901000977 ),
		Max = Vector( 2318.9389648438, 640.5791015625, 536.72137451172 ),
		Theater = { Name = "Bar",
			Flags = THEATER_REPLICATED,
			Pos = Vector( 1938, -262, 553 ),
			Ang = Angle(0,180,46),
			Width = 300,
			Height = 200,
			ThumbInfo = { Pos = Vector( 2368.01, 706, 280 ), Ang = Angle( 0, 90, 0 ) }
		}
	},

	[ "Club" ] = {
		Min = Vector( 4145.8979492188, 911.357421875, 6.106315612793 ),
		Max = Vector( 6059.0966796875, 3079.2888183594, 559.75238037109 ),
		Theater = { Name = "Club",
			Flags = THEATER_REPLICATED,
			Pos = Vector( 4930, 1820, 486 ),
			Ang = Angle(0,90,56.5),
			Width = 300,
			Height = 150,
			ThumbInfo = { Pos = Vector( 2420, 2007, 295 ), Ang = Angle( 45.5, 180, 0 ) }
		}
	},

	[ "Cavern Theater" ] = {
		Min = Vector( -384.03698730469, 478.84985351563, -547.53607177734 ),
		Max = Vector( 243.56980895996, 1351.8413085938, 54.377265930176 ),
		Theater = { Name = "Cavern Theater",
			Flags = THEATER_PRIVATE,
			Pos = Vector( -324, 549, 24 ),
			Ang = Angle(0,90,0),
			Width = 541,
			Height = 257,
			ThumbInfo = { Pos = Vector( 775, 871, 23 ), Ang = Angle( 45.5, 0, 0 ) }
		}
	},

	[ "Moon Theater" ] = {
		Min = Vector( -5220.224609375, 692.33654785156, 0.51021003723145 ),
		Max = Vector( -2498.3449707031, 3449.6389160156, 2787.32421875 ),
		Theater = { Name = "Moon Theater",
			Flags = THEATER_PRIVATE,
			Pos = Vector( -3300, 953, 1205 ),
			Ang = Angle(0,180,0),
			Width = 1000,
			Height = 600,
			ThumbInfo = { Pos = Vector( 775, 1420, 23 ), Ang = Angle( 45.5, 0, 0 ) }
		}
	},

	[ "Pool Theater" ] = {
		Min = Vector( -1760.1169433594, 745.41516113281, -149.2354888916 ),
		Max = Vector( -752.15490722656, 1753.6638183594, 551.84497070313 ),
		Theater = { Name = "Pool Theater",
			Flags = THEATER_REPLICATED,
			Pos = Vector( -1396, 1447, 360 ),
			Ang = Angle(0,0,0),
			Width = 478,
			Height = 254,
			ThumbInfo = { Pos = Vector( 1423, 826, 23 ), Ang = Angle( 45.5, 180, 0 ) }
		}
	},

	[ "Manga Theater" ] = {
		Min = Vector( 82.691986083984, 336.67727661133, 57.546836853027 ),
		Max = Vector( 654.2021484375, 849.95098876953, 402.2883605957 ),
		Theater = { Name = "Manga Theater",
			Flags = THEATER_PRIVATE,
			Pos = Vector( 89, 384, 355 ),
			Ang = Angle(0,90,0),
			Width = 431,
			Height = 256,
			ThumbInfo = { Pos = Vector( 775, 560, 265 ), Ang = Angle( 45.5, 0, 0 ) }
		}
	},

	[ "Snow Theater" ] = {
		Min = Vector( -100.89225769043, 871.37548828125, 51.100200653076 ),
		Max = Vector( 641.92144775391, 1456.5682373047, 417.85614013672 ),
		Theater = { Name = "Snow Theater",
			Flags = THEATER_PRIVATE,
			Pos = Vector( -96, 924, 358 ),
			Ang = Angle(0,90,0),
			Width = 476,
			Height = 256,
			ThumbInfo = { Pos = Vector( 775, 1152, 265 ), Ang = Angle( 45.5, 0, 0 ) }
		}
	},

	[ "Design Theater" ] = {
		Min = Vector( -308.5673828125, 1479.9174804688, 60.680381774902 ),
		Max = Vector( 580.80621337891, 1876.6420898438, 395.2561340332 ),
		Theater = { Name = "Design Theater",
			Flags = THEATER_PRIVATE,
			Pos = Vector( -156, 1529, 396 ),
			Ang = Angle(0,90,46),
			Width = 300,
			Height = 209,
			ThumbInfo = { Pos = Vector( 775, 1689, 265 ), Ang = Angle( 45.5, 0, 0 ) }
		}
	},

	[ "Reversed Theater" ] = {
		Min = Vector( -378.58605957031, 1899.9593505859, -125.72278594971 ),
		Max = Vector( 258.96105957031, 2526.6687011719, 190.50875854492 ),
		Theater = { Name = "Reversed Theater",
			Flags = THEATER_PRIVATE,
			Pos = Vector( -377, 2455, -99 ),
			Ang = Angle(180,90,0),
			Width = 483,
			Height = 253,
			ThumbInfo = { Pos = Vector( 775, 2209, 265 ), Ang = Angle( 45.5, 0, 180 ) }
		}
	},

	[ "Cemetery Theater" ] = {
		Min = Vector( -1023.9418334961, -844.9814453125, -134.48107910156 ),
		Max = Vector( -433.10842895508, 298.74536132813, 375.4602355957 ),
		Theater = { Name = "Cemetery Theater",
			Flags = THEATER_PRIVATE,
			Pos = Vector( -889, -523, 223 ),
			Ang = Angle(0,90,0),
			Width = 400,
			Height = 270,
			ThumbInfo = { Pos = Vector( 1119, 374, 264 ), Ang = Angle( 45.5, 90, 0 ) }
		}
	},
	
	[ "Cartoon Theater" ] = {
		Min = Vector( -919.37652587891, 631.24005126953, 614.27435302734 ),
		Max = Vector( -519.12487792969, 1000.8109130859, 856.80999755859 ),
		Theater = { Name = "Cartoon Theater",
			Flags = THEATER_PRIVATE,
			Pos = Vector( -862, 999, 801 ),
			Ang = Angle(0,0,0),
			Width = 291,
			Height = 126,
		}
	},

	[ "Justin Theater" ] = {
		Min = Vector( 3192.2878417969, 1504.7890625, -174.96875 ),
		Max = Vector( 3458.5051269531, 1640.96875, -12.204097747803 ),
		Theater = { Name = "Justin Theater",
			Flags = THEATER_PRIVATE,
			Pos = Vector( 3449, 1632, -59 ),
			Ang = Angle(0,270,0),
			Width = 103,
			Height = 75,
		}
	},
	
	[ "Secret Theater" ] = {
		Min = Vector( 1266.2347412109, -734.47149658203, 207.25218200684 ),
		Max = Vector( 2151.3923339844, -590.50726318359, 359.66946411133 ),
		Theater = { Name = "Secret Theater",
			Flags = THEATER_PRIVATE,
			Pos = Vector( 1274, -689, 318 ),
			Ang = Angle(0,90,0),
			Width = 69,
			Height = 50,
		}
	},

	[ "Private Theater 1" ] = {
		Min = Vector( 2502.0146484375, -472.79534912109, -164.1900177002 ),
		Max = Vector( 2893.7077636719, -83.275833129883, 105.62928009033 ),
		Theater = { Name = "Private Theater 1",
			Flags = THEATER_PRIVATE,
			Pos = Vector( 2888, -125, 49 ),
			Ang = Angle(0,270,0),
			Width = 302,
			Height = 191,
			ThumbInfo = { Pos = Vector( 2318, -314, 23 ), Ang = Angle( 0, 180, 0 ) }
		}
	},

	[ "Private Theater 2" ] = {
		Min = Vector( 1885.1331787109, -1464.8601074219, -259.05133056641 ),
		Max = Vector( 2264.0837402344, -1065.7192382813, 0.17234516143799 ),
		Theater = { Name = "Private Theater 2",
			Flags = THEATER_PRIVATE,
			Pos = Vector( 2227, -1454, -31 ),
			Ang = Angle(0,180,0),
			Width = 302,
			Height = 191,
			ThumbInfo = { Pos = Vector( 2032, -556, 23 ), Ang = Angle( 0, 90, 0 ) }
		}
	},

	[ "Private Theater 3" ] = {
		Min = Vector( 1342.9587402344, -1468.5427246094, -285.39489746094 ),
		Max = Vector( 1739.8677978516, -1066.9858398438, 6.7889633178711 ),
		Theater = { Name = "Private Theater 3",
			Flags = THEATER_PRIVATE,
			Pos = Vector( 1699, -1454, -31 ),
			Ang = Angle(0,180,0),
			Width = 302,
			Height = 191,
			ThumbInfo = { Pos = Vector( 1592, -556, 23 ), Ang = Angle( 0, 90, 0 ) }
		}
	},

	[ "Private Theater 4" ] = {
		Min = Vector( 725.76403808594, -470.84619140625, -228.92002868652 ),
		Max = Vector( 1129.9031982422, -86.740097045898, 76.469902038574 ),
		Theater = { Name = "Private Theater 4",
			Flags = THEATER_PRIVATE,
			Pos = Vector( 739, -427, 48 ),
			Ang = Angle(0,90,0),
			Width = 302,
			Height = 191,
			ThumbInfo = { Pos = Vector( 1309, -314, 23 ), Ang = Angle( 0, 0, 0 ) }
		}
	},

	[ "Private Theater 5" ] = {
		Min = Vector( 1891.533203125, -1551.86328125, 67.763748168945 ),
		Max = Vector( 2295.0002441406, -1123.6550292969, 345.64544677734 ),
		Theater = { Name = "Private Theater 5",
			Flags = THEATER_PRIVATE,
			Pos = Vector( 2227, -1551, 299 ),
			Ang = Angle(0,180,0),
			Width = 302,
			Height = 191,
			ThumbInfo = { Pos = Vector( 1973, -635, 178 ), Ang = Angle( 45.5, 90, 0 ) }
		}
	},

	[ "Private Theater 6" ] = {
		Min = Vector( 1363.9562988281, -1563.5570068359, 72.033752441406 ),
		Max = Vector( 1741.8918457031, -1164.0373535156, 319.50048828125 ),
		Theater = { Name = "Private Theater 6",
			Flags = THEATER_PRIVATE,
			Pos = Vector( 1699, -1551, 299 ),
			Ang = Angle(0,180,0),
			Width = 302,
			Height = 191,
			ThumbInfo = { Pos = Vector( 1653, -635, 178 ), Ang = Angle( 45.5, 90, 0 ) }
		}
	},

	[ "Karaoke Room" ] = {
		Min = Vector( 3081, 811, 204 ),
		Max = Vector( 3792, 1716, 409 ),
		Theater = { Name = "Karaoke Room",
			Flags = THEATER_PRIVATE,
			Pos = Vector( 3791.5, 1516, 408 ),
			Ang = Angle(0,-90,0),
			Width = 301,
			Height = 175,
			-- do this later
			--ThumbInfo = { Pos = Vector( 1653, -635, 178 ), Ang = Angle( 45.5, 90, 0 ) }
		}
	},
} )
end )

function SpawnPokerTables()
	if SERVER then
		for k, v in pairs(ents.FindByClass("ent_poker_game")) do
			v:Remove()
		end

		local tables = {
			{pos = Vector(1476, -64, 225), ang = Angle(0, 90, 0)},
			{pos = Vector(2118, -64, 225), ang = Angle(0, 90, 0)},
			{pos = Vector(5500, 2787, 134), ang = Angle(0, 90, 0)},
			{pos = Vector(5500, 1142, 134), ang = Angle(0, 90, 0)},
			{pos = Vector(45, 1157, 64), ang = Angle(0, 90, 0)},
			{pos = Vector(14, 1600, 64), ang = Angle(0, 90, 0)},
			{pos = Vector(202, 564, 64), ang = Angle(0, 90, 0)},
			{pos = Vector(-527, 685, 96), ang = Angle(0, 90, 0)},
			{pos = Vector(-204, 818, -285), ang = Angle(0, 90, 0)},
			{pos = Vector(-4109.5, 2365.25, 245), ang = Angle(0, 90, 0)},
			{pos = Vector(2075, -2154, -1051), ang = Angle(0, 90, 0)},
			{pos = Vector(1550, -2160, -1051), ang = Angle(0, 90, 0)},
			{pos = Vector(-1484, 1081, 202), ang = Angle(0, 90, 0)},
			{pos = Vector(-721, 883, 656), ang = Angle(0, 90, 0)}
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