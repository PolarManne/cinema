resource.AddWorkshop("382155331")
Location.Add( "fnaf2",
{
	["Security Room"] =
	{
		Volumes = {
			{ Min = Vector(-160,-352,-0), Max = Vector(160,-80,192) },
		},
		--[[Theater = {
			Name = "Security Room",
			Flags = THEATER_REPLICATED,
			Pos = Vector( -103, -144.5, 21.5 ),
			Ang = Angle(0,57.4,0),
			Width = 32,
			Height = 18,
		}--]]
		Theater = {
			Name = "Security Room",
			Flags = THEATER_REPLICATED,
			Pos = Vector( -159.75, -279, 151 ),
			Ang = Angle(0,90,0),
			Width = 126,
			Height = 76,
		}
	},
	["Hallway"] =
	{
		Volumes = {
			{ Min = Vector(-111,-80,0), Max = Vector(111,1168,192) },
			{ Min = Vector(-176,1169,0), Max = Vector(608,1344,192) },
		}
	},
	["Main Hall"] =
	{
		Volumes = {
			{ Min = Vector(608,592,0), Max = Vector(1663,1647,246) },
		}
	},
	["Party Hall 1"] =
	{
		Volumes = {
			{ Min = Vector(-128,176,0), Max = Vector(-544,512,192) },
		}
	},
	["Party Hall 2"] =
	{
		Volumes = {
			{ Min = Vector(544,176,0), Max = Vector(128,512,192) },
		}
	},
	["Party Hall 3"] =
	{
		Volumes = {
			{ Min = Vector(-128,768,0), Max = Vector(-544,1104,192) },
		}
	},
	["Party Hall 4"] =
	{
		Volumes = {
			{ Min = Vector(544,768,0), Max = Vector(128,1104,192) },
		}
	},
	["Party Hall 5"] =
	{
		Volumes = {
			{ Min = Vector(1408,160,0), Max = Vector(1072,575,192) },
		}
	},
	["Men's Restroom"] =
	{
		Volumes = {
			{ Min = Vector(176,1344,0), Max = Vector(432,1792,144) },
		}
	},
	["Women's Restroom"] =
	{
		Volumes = {
			{ Min = Vector(-111,1344,0), Max = Vector(144,1792,144) },
		}
	},
	["Employee Restroom"] =
	{
		Volumes = {
			{ Min = Vector(-128,-560,0), Max = Vector(48,-368,136) },
		}
	},
	["Parts & Service"] =
	{
		Volumes = {
			{ Min = Vector(-464,1168,0), Max = Vector(-176,1536,144) },
		}
	},
	["Left Vent"] =
	{
		Volumes = {
			{ Min = Vector(-448,-256,0), Max = Vector(-159,176,59) },
		}
	},
	["Right Vent"] =
	{
		Volumes = {
			{ Min = Vector(159,-256,0), Max = Vector(416,176,59) },
		}
	},
} )
