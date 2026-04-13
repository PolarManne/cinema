Location.Add( "gm_smiling_friends",
{
	["Kitchen"] =
	{
		Volumes = {
			{ Min = Vector(11200, 256, 0), Max = Vector(11520, 544, 152) },
		},

		Theater = {
			Name = "Kitchen",
			Flags = THEATER_REPLICATED,
			Pos = Vector(11488, 463, 134),
			Ang = Angle(-7,-75.7,14),
			Width = 17,
			Height = 14.6,
		}
	},
	["The Boss's Office"] =
	{
		Volumes = {
			{ Min = Vector(10880, -1568, 0), Max = Vector(12032, 246, 320) },
		},

		Theater = {
			Name = "The Boss's Office",
			Flags = THEATER_REPLICATED,
			Pos = Vector(11777, -1567.5, 320 ),
			Ang = Angle(0,180,0),
			Width = 642,
			Height = 214,
		}
	},
	["Inside the Walls"] =
	{
		Volumes = {
			{ Min = Vector(10752, 256, -8), Max = Vector(11184, 544, 136) },
			{ Min = Vector(10208, -672, -8), Max = Vector(10848, 256, 136) },
		},

		Theater = {
			Name = "Inside the Walls",
			Flags = THEATER_NONE,
			Pos = Vector(10810, 431.75, 55),
			Ang = Angle(0,69,-7),
			Width = 18.8,
			Height = 13.8,
		}
	},
	["Hallway"] =
	{
		Volumes = {
			{ Min = Vector(11001, 544, 0), Max = Vector(11712, 662, 144) },
		},
	},
	["Reception"] =
	{
		Volumes = {
			{ Min = Vector(10656, 576, 0), Max = Vector(11008, 928, 144) },
			{ Min = Vector(11008, 664, 0), Max = Vector(11168, 928, 144) },
		},
	},
	["Back Alley"] =
	{
		Volumes = {
			{ Min = Vector(-256, 512, 0), Max = Vector(384, 1088, 2048) },
		},
	},
	["Outside"] =
	{
		Volumes = {
			{ Min = Vector(-1152, -2048, 0), Max = Vector(1280, 512, 2048) },
		},
	},
} )