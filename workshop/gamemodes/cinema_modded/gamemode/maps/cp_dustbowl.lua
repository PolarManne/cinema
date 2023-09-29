hook.Add( "InitPostEntity", "cp_dustbowl", function()
if !Location then return end

Location.Add( "cp_dustbowl",
{
	["Main"] =
	{
		
		Min = Vector( 1397.7440185547, -1420.4937744141, -714.54736328125 ),
		Max = Vector( 3204.6291503906, 546.94689941406, 1222.8153076172 ),

		Theater = {
			Name = "Main",
			Flags = THEATER_REPLICATED,
			Pos = Vector( 2430, -47, 180 ),
			-- 0, -344 ,35
			Ang = Angle(0,-90,0),
			Width = 527,
			Height = 296,
			ThumbInfo = {
				Pos = Vector( 1330, -1426, -44 ),
				Ang = Angle(0, -124, 0),
			}
		}
	},
	["Hole"] =
	{

		Min = Vector( -900.0, -2121.0, -612.0 ),
		Max = Vector( -570.0, -1575.0, 205.0 ),

		Theater = {
			Name = "Cuck Hole",
			Flags = THEATER_REPLICATED,
			Pos = Vector( -558, -2117, -531 ),
			Ang = Angle(0,180,-90),
			Width = 386,
			Height = 217,
			ThumbInfo = {
				Pos = Vector( -1000, -1980, -70 ),
				Ang = Angle(0, 90, 0),
			}
		}
	},
	["Schizos"] =
	{

	Min = Vector( 2136.0, -1716.0, -5.0 ),
	Max = Vector( 2444.0, -1421.0, 218.0 ),

		Theater = {
			Name = "Schizo Zone",
			Flags = THEATER_HIDDEN,
			Pos = Vector( -2500, 4000, 2200),
			Ang = Angle(0, 180, 45),
			Width = 5000,
			Height = 2812,
		}
	},
	["Timeclockers"] =
	{

	Min = Vector( 1161.0, -2162.0, -168.0 ),
	Max = Vector( 1416.0, -1859.0, 144.0),


		Theater = {
			Name = "Timeclock",
			Flags = THEATER_HIDDEN,
			Pos = Vector( 1397, -1962, -49),
			Ang = Angle(0, -90, 0),
			Width = 21,
			Height = 16,
		}
	},
} )

end )
