hook.Add( "InitPostEntity", "fnaf1remakeday", function()
if !Location then return end

Location.Add( "fnaf1remakeday",
{
	["Security"] =
	{
		
		Min = Vector( -796, -1170, -182 ),
		Max = Vector( 958, 668, 272 ),

		Theater = {
			Name = "Security room",
			Flags = THEATER_REPLICATED,
			Pos = Vector( -35, -781.25, 83.5 ),
			Ang = Angle(0,1.25,0),
			Width = 12,
			Height = 11,
		}
	},
} )

end )