hook.Add( "InitPostEntity", "gm_epicsubmarine", function()
if !Location then return end

Location.Add( "gm_epicsubmarine",
{
	["Sub"] =
	{
		
		Min = Vector( -122.0, 872.0, -100.0 ),
		Max = Vector( 250.0, 1272.0, 200.0 ),


		Theater = {
			Name = "Titan Sub",
			Flags = THEATER_REPLICATED,
			Pos = Vector( 24, 1145, 60 ),
			Ang = Angle(0,0,0),
			Width = 80,
			Height = 45,
		}
	},
} )

end )