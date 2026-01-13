Location.Add( "cs_office",
{
	["Meeting Room"] =
	{
		Volumes = {
			{ Min = Vector(1910, -384, -160), Max = Vector(2344, 111, -32) },
		},
		Theater = {
			Name = "Meeting Room",
			Flags = THEATER_REPLICATED,
			Pos = Vector(1910, 255, -45),
			Ang = Angle(0,90,0),
			Width = 89,
			Height = 89,
		}
	},
	["Storage Room"] =
	{
		Volumes = {
			{ Min = Vector(1120, -240, -159), Max = Vector(1504, -64, -32) },
			{ Min = Vector(1344, -352, -159), Max = Vector(1472, -240, -32) },
			{ Min = Vector(1312, -352, -159), Max = Vector(1696, -672, -32) },
		},
		Theater = {
			Name = "Meeting Room",
			Flags = THEATER_REPLICATED,
			Pos = Vector(1499, -352, -46),
			Ang = Angle(0,0,0),
			Width = 71,
			Height = 37,
		}
	},
} )