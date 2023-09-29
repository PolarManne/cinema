hook.Add( "InitPostEntity", "gm_desertbus_deluxe", function()
if !Location then return end

Location.Add( "gm_desertbus_deluxe",
{
        ["The Bus"] =
        {

                Min = Vector( -512, -150, 512 ),
                Max = Vector( 352, 160, 816 ),

                Theater = {
                        Name = "The Bus",
                        Flags = THEATER_REPLICATED,
                        Pos = Vector( 165.9524, 10, 667.628 ),
                        Ang = Angle(0,-90,21),
                        Width = 16,
                        Height = 11,
                        --ThumbInfo = {
                                --Pos = Vector( 1330, -1426, -44 ),
                                --Ang = Angle(0, -124, 0)
                        --}
                }
        },
        ["Winner's Room"] =
        {

                Min = Vector( -416, -127, -1792 ),
                Max = Vector( 288, 287, -1664 ),

                Theater = {
                        Name = "Winner's Room",
                        Flags = THEATER_HIDDEN,
                        Pos = Vector( 64.25, 128, -1664 ),
                        Ang = Angle(0,90,0),
                        Width = 160,
                        Height = 128,
                        --ThumbInfo = {
                                --Pos = Vector( -1000, -1980, -70 ),
                                --Ang = Angle(0, 90, 0)
                        --}
                }
        },
        ["ayy lmao"] =
        {

                Min = Vector( 1024, -7168, -544 ),
                Max = Vector( 3072, -5184, 480 ),

                Theater = {
                        Name = "ayy lmao",
                        Flags = THEATER_HIDDEN,
                        Pos = Vector( 3072, -5184, 480 ),
                        Ang = Angle(0,-90,0),
                        Width = 1984,
                        Height = 1024,
                        --ThumbInfo = {
                                --Pos = Vector( -1000, -1980, -70 ),
                                --Ang = Angle(0, 90, 0)
                        --}
                }
        },
} )

end )