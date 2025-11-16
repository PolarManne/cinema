--remember: angle is the direction pointing from the vector to the upper-right edge of the screen
Location.Add( "sleepykiba_v3",
{
	["Grand Cinema"] =
	{
		
		Min = Vector( -7353, -2399, 1313 ),
		Max = Vector( -5452, -754, 2078 ),

		Theater = {
			Name = "Grand Cinema",
			Flags = THEATER_REPLICATED,
			Pos = Vector( -6916, -771.5, 2015 ),
			Ang = Angle(0,0,0),
			Width = 1024,
			Height = 576,
		}
	},
	["Cabaret"] =
	{
		
		Min = Vector( 1885, -1424, -8 ),
		Max = Vector( 3120, -28, 479 ),

		Theater = {
			Name = "Cabaret",
			Flags = THEATER_REPLICATED,
			Pos = Vector( 3112.5, -881, 232.5 ),
			Ang = Angle(0,-90,0),
			Width = 304,
			Height = 208,
		}
	},
	["Pool Theater"] =
	{
		
		Min = Vector( 7717, 4585, 1410 ),
		Max = Vector( 9124, 6248, 1805 ),

		Theater = {
			Name = "Pool Theater",
			Flags = THEATER_PRIVATE,
			Pos = Vector( 8180, 6244.5, 1773 ),
			Ang = Angle(0,0,0),
			Width = 482,
			Height = 272,
		}
	},
	["Public Theater 1"] =
	{
		
		Min = Vector( 1579, -2306, 95 ),
		Max = Vector( 2145, -1615, 435 ),

		Theater = {
			Name = "Public Theater 1",
			Flags = THEATER_REPLICATED,
			Pos = Vector( 2102, -2303, 401 ),
			Ang = Angle(0,180,0),
			Width = 480,
			Height = 270,
		}
	},
	["Public Theater 2"] =
	{
		
		Min = Vector( 984, -2306, 101 ),
		Max = Vector( 1549, -1614, 440 ),

		Theater = {
			Name = "Public Theater 2",
			Flags = THEATER_REPLICATED,
			Pos = Vector( 1506, -2302.75, 406 ),
			Ang = Angle(0,180,0),
			Width = 480,
			Height = 270,
		}
	},
	["Public Theater 3"] =
	{
		
		Min = Vector( 395, -2250, 100 ),
		Max = Vector( 961, -1558, 439 ),

		Theater = {
			Name = "Public Theater 3",
			Flags = THEATER_REPLICATED,
			Pos = Vector( 918, -2246.75, 406 ),
			Ang = Angle(0,180,0),
			Width = 480,
			Height = 270,
		}
	},
	["Public Theater 4"] =
	{
		
		Min = Vector( -591, -2031, 102 ),
		Max = Vector( 100, -1465, 441 ),

		Theater = {
			Name = "Public Theater 4",
			Flags = THEATER_REPLICATED,
			Pos = Vector( -588.75, -1988, 408 ),
			Ang = Angle(0,90,0),
			Width = 480,
			Height = 270,
		}
	},
	["Private Theater 1"] =
	{
		
		Min = Vector( -1514, 300, 3308 ),
		Max = Vector( -604, 1486, 3894 ),

		Theater = {
			Name = "Private Theater 1",
			Flags = THEATER_PRIVATE,
			Pos = Vector( -663, 321, 3825 ),
			Ang = Angle(0,180,0),
			Width = 800,
			Height = 450,
		}
	},
	["Private Theater 2"] =
	{
		
		Min = Vector( -909, 4350, 3300 ),
		Max = Vector( 1, 5536, 3887 ),

		Theater = {
			Name = "Private Theater 2",
			Flags = THEATER_PRIVATE,
			Pos = Vector( -57, 4371.5, 3819 ),
			Ang = Angle(0,180,0),
			Width = 800,
			Height = 450,
		}
	},
	["Private Theater 3"] =
	{
		
		Min = Vector( -1190, 2143, 3287 ),
		Max = Vector( -279, 3329, 3874 ),

		Theater = {
			Name = "Private Theater 3",
			Flags = THEATER_PRIVATE,
			Pos = Vector( -338, 2164.5, 3806 ),
			Ang = Angle(0,180,0),
			Width = 800,
			Height = 450,
		}
	},
	["Private Theater 4"] =
	{
		
		Min = Vector( -562, 8202, 3264 ),
		Max = Vector( 250, 9389, 3851 ),

		Theater = {
			Name = "Private Theater 4",
			Flags = THEATER_PRIVATE,
			Pos = Vector( 290, 8223.5, 3783 ),
			Ang = Angle(0,180,0),
			Width = 800,
			Height = 450,
		}
	},
	[ "Kotatsu 1" ] =
	{
		Min = Vector( 9481, 12191, 2496 ),
		Max = Vector( 10025, 12735, 2640 ),
		Theater = {
			Name = "Kotatsu 1",
			Flags = THEATER_REPLICATED,
			Pos = Vector( 9847, 12255.5, 2625 ),
			Ang = Angle( 0, 180, 0 ),
			Width = 187,
			Height = 101,
			/*[ThumbInfo = {
				Pos = Vector( -288, 2268, 134 ),
				Ang = Angle( 0, 180, 0)
			}*/
		}
	},
	[ "Kotatsu 2" ] =
	{
		Min = Vector( 9257, 11967, 2656 ),
		Max = Vector( 10025, 12735, 2816 ),
		Theater = {
			Name = "Kotatsu 2",
			Flags = THEATER_REPLICATED,
			Pos = Vector( 9735, 12031, 2785 ),
			Ang = Angle( 0, 180, 0 ),
			Width = 187,
			Height = 101,
			/*[ThumbInfo = {
				Pos = Vector( -288, 2268, 134 ),
				Ang = Angle( 0, 180, 0)
			}*/
		}
	},
	[ "Private Kotatsu" ] =
	{
		Min = Vector( 9481, 12191, 2832 ),
		Max = Vector( 10025, 12735, 2992 ),
		Theater = {
			Name = "Private Kotatsu",
			Flags = THEATER_PRIVATE,
			Pos = Vector( 9960, 12557, 2961 ),
			Ang = Angle( 0, -90, 0 ),
			Width = 187,
			Height = 101,
			/*[ThumbInfo = {
				Pos = Vector( -288, 2268, 134 ),
				Ang = Angle( 0, 180, 0)
			}*/
		}
	},
	["Apartment 1"] =
	{
		
		Min = Vector( -1071, 231, 200 ),
		Max = Vector( -551, 757, 328 ),

		Theater = {
			Name = "Apartment 1",
			Flags = THEATER_PRIVATE,
			Pos = Vector( -945, 352.75, 311.5 ),
			Ang = Angle(0,90,0),
			Width = 119,
			Height = 69,
		}
	},
	["Apartment 2"] =
	{
		
		Min = Vector( -1071, 231, 408 ),
		Max = Vector( -551, 757, 536 ),

		Theater = {
			Name = "Apartment 2",
			Flags = THEATER_PRIVATE,
			Pos = Vector( -945, 352.75, 519.5 ),
			Ang = Angle(0,90,0),
			Width = 119,
			Height = 69,
		}
	},
	["Apartment 3"] =
	{
		
		Min = Vector( -1071, 231, 616 ),
		Max = Vector( -551, 757, 744 ),

		Theater = {
			Name = "Apartment 3",
			Flags = THEATER_PRIVATE,
			Pos = Vector( -945, 352.75, 727.5 ),
			Ang = Angle(0,90,0),
			Width = 119,
			Height = 69,
		}
	},
	["Apartment 4"] =
	{
		
		Min = Vector( -1071, 231, 824 ),
		Max = Vector( -551, 757, 952 ),

		Theater = {
			Name = "Apartment 4",
			Flags = THEATER_PRIVATE,
			Pos = Vector( -945, 352.75, 935.5 ),
			Ang = Angle(0,90,0),
			Width = 119,
			Height = 69,
		}
	},
	["Office"] =
	{
		
		Min = Vector( 5600, -415, 1588 ),
		Max = Vector( 6047, 31, 1732 ),

		Theater = {
			Name = "Office",
			Flags = THEATER_PRIVATE,
			Pos = Vector( 6020, -219.5, 1704.5 ),
			Ang = Angle(0,-90,0),
			Width = 187,
			Height = 101,
		}
	},
	["Ramen Shop"] =
	{
		
		Min = Vector( 1386, 7398, 790 ),
		Max = Vector( 2185, 8045, 943 ),

		Theater = {
			Name = "Ramen Shop",
			Flags = THEATER_REPLICATED,
			Pos = Vector( 1386.5, 7740, 925 ),
			Ang = Angle(0,90,0),
			Width = 160,
			Height = 90,
		}
	},
    [ "Staff Lounge" ]=
	{
		Min = Vector( 3376, 10623, 3445 ),
		Max = Vector( 5871, 12542, 3829 ),
		Theater = {
			Name = "Staff Lounge",
			Flags = THEATER_PRIVILEGED,
			Pos = Vector( 4912, 10687.5, 3765 ),
			Ang = Angle(0, 180, 0),
			Width = 576,
			Height = 256,
		}
	},
	[ "Classroom" ] =
	{
		Min = Vector( -659, 7626, 779 ),
		Max = Vector( 29, 8002, 916 ),
		Theater = {
			Name = "Classroom",
			Flags = THEATER_NONE,
			Pos = Vector( 3, 7894, 916 ),
			Ang = Angle(0, -90, 0),
			Width = 160,
			Height = 104,
		}
	},
	[ "Star Wars Theater" ] =
	{
		Min = Vector( -7258, 803, 1622 ),
		Max = Vector( -5402, 2896, 2599 ),
		Theater = {
			Name = "Star Wars Theater",
			Flags = THEATER_NONE,
			Pos = Vector( -6284, 1165, 1905 ),
			Ang = Angle(0, 180, 0),
			Width = 372,
			Height = 201,
		}
	},
	[ "Cave Theater" ] =
	{
		Min = Vector( -14681, 869, 1215 ),
		Max = Vector( -12991, 3331, 2437 ),
		Theater = {
			Name = "Cave Theater",
			Flags = THEATER_NONE,
			Pos = Vector( -13542, 1697, 1612 ),
			Ang = Angle(0, 180, 0),
			Width = 372,
			Height = 201,
		}
	},
} )

function SpawnPokerTables()
        if SERVER then
                for k, v in pairs(ents.FindByClass("ent_poker_game")) do
                        v:Remove()
                end

                local tables = {
                        {pos = Vector(2608, -1031, -6), ang = Angle(0, 90, 0)},
                        {pos = Vector(1862, -2149, 95), ang = Angle(0, 90, 0)},
                        {pos = Vector(1266, -2149, 100), ang = Angle(0, 90, 0)},
                        {pos = Vector(678, -2093, 100), ang = Angle(0, 90, 0)},
                        {pos = Vector(-435, -1748, 102), ang = Angle(0, 90, 0)},
                        {pos = Vector(-763, 504, 3307), ang = Angle(0, 90, 0)},
                        {pos = Vector(-1362, 504, 3307), ang = Angle(0, 90, 0)},
                        {pos = Vector(-1038, 2347.5, 3287), ang = Angle(0, 90, 0)},
                        {pos = Vector(-439, 2347.5, 3287), ang = Angle(0, 90, 0)},
                        {pos = Vector(-7253.5, -1624.5, 1700), ang = Angle(0, 90, 0)},
                        {pos = Vector(-5555, -1624.5, 1701), ang = Angle(0, 90, 0)},
                        {pos = Vector(-5645, -1619, 1405), ang = Angle(0, 90, 0)},
                        {pos = Vector(-7200, -1618, 1405), ang = Angle(0, 90, 0)},
                        {pos = Vector(9662.5, 1546, 1737), ang = Angle(0, 90, 0)},
                        {pos = Vector(9823.5, 1546, 1737), ang = Angle(0, 90, 0)},
                        {pos = Vector(9823.5, 1324, 1737), ang = Angle(0, 90, 0)},
                        {pos = Vector(9662.5, 1324, 1737), ang = Angle(0, 90, 0)},
--                        {pos = Vector(-3074, -4428, -116), ang = Angle(0, 90, 0)},
                        {pos = Vector(1454, 7826, 807), ang = Angle(0, 90, 0)},
                        {pos = Vector(5922.5, -314.5, 1588), ang = Angle(0, 90, 0)},
                        {pos = Vector(9752.5, 12601.5, 2496), ang = Angle(0, 90, 0)},
                        {pos = Vector(8232.5, 5452, 1476), ang = Angle(0, 90, 0)}
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
