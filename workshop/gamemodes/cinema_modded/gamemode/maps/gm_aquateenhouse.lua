--[[ north is left facing street from the front door

north=0,0,0
south=0,180,0
west=0,90,0
east=0,-90,0 ]]--

Location.Add( "gm_aquateenhouse",
{
	["Living Room"] =
	{
		Min = Vector( 368, 1342, 144),
		Max = Vector( 744, 1981, 284),
		Theater = {
			Name = "Living Room",
			Flags = THEATER_REPLICATED,
			Pos = Vector( 567, 1367, 192 ),
			Ang = Angle(0,180,0),
			Width = 18,
			Height = 18,
			ThumbInfo = {
				Pos = Vector( 1330, -1426, -44 ),
				Ang = Angle(0, -124, 0),
			}
		}
	},
	["Kitchen"] =
	{
		Min = Vector( 752, 1330, 144),
		Max = Vector( 1032, 1798, 284),
		Theater = {
			Name = "Kitchen",
			Flags = THEATER_PRIVATE,
			Pos = Vector( 1032, 1330.25, 284 ),
			Ang = Angle(0,180,0),
			Width = 280,
			Height = 140,
			ThumbInfo = {
				Pos = Vector( 1330, -1426, -44 ),
				Ang = Angle(0, -124, 0),
			}
		}
	},
	["Meatwad's Room"] =
	{
		Min = Vector( 752, 1798, 144),
		Max = Vector( 1024, 2126, 284),
		Theater = {
			Name = "Meatwad's Room",
			Flags = THEATER_PRIVATE,
			Pos = Vector( 752, 2125.75, 284 ),
			Ang = Angle(0,0,0),
			Width = 272,
			Height = 140,
			ThumbInfo = {
				Pos = Vector( 1330, -1426, -44 ),
				Ang = Angle(0, -124, 0),
			}
		}
	},
	["Frylock's Room"] =
	{
		Min = Vector( 752, 2134, 144),
		Max = Vector( 1024, 2566.25, 284),
		Theater = {
			Name = "Frylock's Room",
			Flags = THEATER_PRIVATE,
			Pos = Vector( 1024, 2134, 284 ),
			Ang = Angle(0,180,0),
			Width = 272,
			Height = 140,
			ThumbInfo = {
				Pos = Vector( 1330, -1426, -44 ),
				Ang = Angle(0, -124, 0),
			}
		}
	},
	["Garage"] =
	{
		Min = Vector( 368, 1998, 144),
		Max = Vector( 624, 2558, 284),
		Theater = {
			Name = "Garage",
			Flags = THEATER_PRIVATE,
			Pos = Vector( 624, 1998.25, 284 ),
			Ang = Angle(0,180,0),
			Width = 256,
			Height = 140,
			ThumbInfo = {
				Pos = Vector( 1330, -1426, -44 ),
				Ang = Angle(0, -124, 0),
			}
		}
	},
	["Attic"] =
	{
		Min = Vector( 356, 1332, 288),
		Max = Vector( 1035, 2568, 448),
		Theater = {
			Name = "Attic",
			Flags = THEATER_PRIVATE,
			Pos = Vector( 817, 1332.25, 394 ),
			Ang = Angle(0,180,0),
			Width = 241,
			Height = 106,
			ThumbInfo = {
				Pos = Vector( 1330, -1426, -44 ),
				Ang = Angle(0, -124, 0),
			}
		}
	},
	["Carl's Living Room"] =
	{
		Min = Vector( 394, 3104, 134),
		Max = Vector( 1066, 3616, 270),
		Theater = {
			Name = "Carl's Living Room",
			Flags = THEATER_PRIVATE,
			Pos = Vector( 500, 3399, 204 ),
			Ang = Angle(0,0,0),
			Width = 56,
			Height = 33,
			ThumbInfo = {
				Pos = Vector( 1330, -1426, -44 ),
				Ang = Angle(0, -124, 0),
			}
		}
	},
	["Carl's Garage"] =
	{
		Min = Vector( 394, 3632, 134),
		Max = Vector( 840, 4040, 270),
		Theater = {
			Name = "Carl's Garage",
			Flags = THEATER_PRIVATE,
			Pos = Vector( 738, 3632, 270 ),
			Ang = Angle(0,180,0),
			Width = 242,
			Height = 136,
			ThumbInfo = {
				Pos = Vector( 1330, -1426, -44 ),
				Ang = Angle(0, -124, 0),
			}
		}
	},
	["Carl's Bedroom"] =
	{
		Min = Vector( 394, 3632, 274),
		Max = Vector( 834, 4040, 388),
		Theater = {
			Name = "Carl's Bedroom",
			Flags = THEATER_PRIVATE,
			Pos = Vector( 833, 4040, 387 ),
			Ang = Angle(0,-90,0),
			Width = 250,
			Height = 113,
			ThumbInfo = {
				Pos = Vector( 1330, -1426, -44 ),
				Ang = Angle(0, -124, 0),
			}
		}
	},
	["Carl's Bathroom"] =
	{
		Min = Vector( 848, 3632, 274),
		Max = Vector( 1066, 4040, 388),
		Theater = {
			Name = "Carl's Bathroom",
			Flags = THEATER_PRIVATE,
			Pos = Vector( 854, 3790, 388 ),
			Ang = Angle(0,90,0),
			Width = 250,
			Height = 113,
			ThumbInfo = {
				Pos = Vector( 1330, -1426, -44 ),
				Ang = Angle(0, -124, 0),
			}
		}
	},
	--[[["Carl's Attic"] =
	{
		Min = Vector( 372, 3096, 274),
		Max = Vector( 1097, 3462, 394),
		Theater = {
			Name = "Carl's Attic",
			Flags = THEATER_PRIVATE,
			Pos = Vector( 2430, -47, 180 ),
			Ang = Angle(0,-90,0),
			Width = 527,
			Height = 296,
			ThumbInfo = {
				Pos = Vector( 1330, -1426, -44 ),
				Ang = Angle(0, -124, 0),
			}
		}
	},]]--
	["Carl's Backyard"] =
	{
		Min = Vector( 1100, 3070, 130),
		Max = Vector( 1794, 4479, 882),
		Theater = {
			Name = "Carl's Backyard",
			Flags = THEATER_PRIVATE,
			Pos = Vector( 1104, 3508, 300 ),
			Ang = Angle(0,90,0),
			Width = 320,
			Height = 166,
			ThumbInfo = {
				Pos = Vector( 1330, -1426, -44 ),
				Ang = Angle(0, -124, 0),
			}
		}
	},
	["Secret Room"] =
	{
		Min = Vector( -2226, -5286, -12),
		Max = Vector( 1218, -1896, 910),
		Theater = {
			Name = "Secret Room",
			Flags = THEATER_NONE,
			Pos = Vector( -1263, -1897, 910 ),
			Ang = Angle(0,0,0),
			Width = 1639,
			Height = 922,
		}
	},
	
} )