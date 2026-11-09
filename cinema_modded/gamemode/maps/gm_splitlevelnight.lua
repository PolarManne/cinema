Location.Add( "gm_splitlevelnight",
{
	["Garage"] =
	{
		Volumes = {
			{ Min = Vector( -1464, 8, -32 ), Max = Vector( -1160, 32, 116 ) },
		},

		Theater = {
			Name = "Garage",
			Flags = THEATER_REPLICATED,
			--Pos = Vector( -1519.5, 488, 171 ),
			--Ang = Angle(0, 90 ,0),
			--Width = 110,
			--Height = 62,
		}
	},
	["Shed"] =
	{
		Volumes = {
			{ Min = Vector( -184, 1000, -32 ), Max = Vector( -40, 1176, 96 ) },
		},

		Theater = {
			Name = "Shed",
			Flags = THEATER_REPLICATED,
			--Pos = Vector( -1519.5, 488, 171 ),
			--Ang = Angle(0, 90 ,0),
			--Width = 110,
			--Height = 62,
		}
	},
	["Hallway"] =
	{
		Volumes = {
			{ Min = Vector( -1016, 320, 0 ), Max = Vector( -904, 504, 120 ) },
		},

		Theater = {
			Name = "Hallway",
			Flags = THEATER_NONE,
		}
	},
	["Kitchen"] =
	{
		Volumes = {
			{ Min = Vector( -896, 264, 0 ), Max = Vector( -584, 504, 120 ) },
		},

		Theater = {
			Name = "Kitchen",
			Flags = THEATER_REPLICATED,
			--Pos = Vector( -1519.5, 488, 171 ),
			--Ang = Angle(0, 90 ,0),
			--Width = 110,
			--Height = 62,
		}
	},
	["Downstairs Hallway"] =
	{
		Volumes = {
			{ Min = Vector( -576, 192, -64 ), Max = Vector( -481, 375, 56 ) },
		},

		Theater = {
			Name = "Downstairs Hallway",
			Flags = THEATER_NONE,
		}
	},
	["Living Room"] =
	{
		Volumes = {
			{ Min = Vector( -1016, 8, 0 ), Max = Vector( -576, 256, 168 ) }, -- main area
			{ Min = Vector( -908, -11, 40 ), Max = Vector( -756, 8, 120 ) }, -- windowsill
			{ Min = Vector( -576, 128, 64 ), Max = Vector( -480, 256, 184 ) }, -- upstairs hallway
			{ Min = Vector( -576, 128, -64 ), Max = Vector( -480, 192, 56 ) }, -- downstairs hallway
		},

		Theater = {
			Name = "Living Room",
			Flags = THEATER_REPLICATED,
			--Pos = Vector( -1519.5, 488, 171 ),
			--Ang = Angle(0, 90 ,0),
			--Width = 110,
			--Height = 62,
		}
	},
	["Office"] =
	{
		Volumes = {
			{ Min = Vector( -576, 384, -64 ), Max = Vector( -328, 504, 56 ) },
		},

		Theater = {
			Name = "Office",
			Flags = THEATER_REPLICATED,
			--Pos = Vector( -1519.5, 488, 171 ),
			--Ang = Angle(0, 90 ,0),
			--Width = 110,
			--Height = 62,
		}
	},
	["Laundry Room"] =
	{
		Volumes = {
			{ Min = Vector( -472, 128, -64 ), Max = Vector( -328, 376, 56 ) },
		},

		Theater = {
			Name = "Laundry Room",
			Flags = THEATER_REPLICATED,
			--Pos = Vector( -1519.5, 488, 171 ),
			--Ang = Angle(0, 90 ,0),
			--Width = 110,
			--Height = 62,
		}
	},
	["Downstairs Bedroom"] =
	{
		Volumes = {
			{ Min = Vector( -568, -56, -64 ), Max = Vector( -328, 120, 56 ) },
		},

		Theater = {
			Name = "Downstairs Bedroom",
			Flags = THEATER_REPLICATED,
			--Pos = Vector( -1519.5, 488, 171 ),
			--Ang = Angle(0, 90 ,0),
			--Width = 110,
			--Height = 62,
		}
	},
	["Upstairs Bedroom"] =
	{
		Volumes = {
			{ Min = Vector( -568, -56, 64 ), Max = Vector( -328, 120, 184 ) },
		},

		Theater = {
			Name = "Upstairs Bedroom",
			Flags = THEATER_REPLICATED,
			--Pos = Vector( -1519.5, 488, 171 ),
			--Ang = Angle(0, 90 ,0),
			--Width = 110,
			--Height = 62,
		}
	},
	["Master Bedroom"] =
	{
		Volumes = {
			{ Min = Vector( -572, 264, 64 ), Max = Vector( -328, 504, 184 ) },
		},

		Theater = {
			Name = "Master Bedroom",
			Flags = THEATER_REPLICATED,
			--Pos = Vector( -1519.5, 488, 171 ),
			--Ang = Angle(0, 90 ,0),
			--Width = 110,
			--Height = 62,
		}
	},
	["Bathroom"] =
	{
		Volumes = {
			{ Min = Vector( -472, 128, 64 ), Max = Vector( -328, 256, 184) },
		},

		Theater = {
			Name = "Bathroom",
			Flags = THEATER_REPLICATED,
			--Pos = Vector( -1519.5, 488, 171 ),
			--Ang = Angle(0, 90 ,0),
			--Width = 110,
			--Height = 62,
		}
	},
} )
