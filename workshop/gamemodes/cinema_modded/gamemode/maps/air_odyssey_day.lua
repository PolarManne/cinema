Location.Add( "air_odyssey_day",
{
        ["Cockpit"] =
        {

                Min = Vector( 1342, -256, -64 ),
                Max = Vector( 2000, 256, 256 ),

                Theater = {
                        Name = "Cockpit",
                        Flags = THEATER_PRIVATE,
                        Pos = Vector( 2880, 800, 644 ),
                        Ang = Angle(0,-90,0),
                        Width = 1600,
                        Height = 900,
                        --ThumbInfo = {
                                --Pos = Vector( 1330, -1426, -44 ),
                                --Ang = Angle(0, -124, 0)
                        --}
                }
        },
        ["First Class"] =
        {

                Min = Vector( 1380, -158, -208 ),
                Max = Vector( 1691, 158, -66 ),

                Theater = {
                        Name = "First Class",
                        Flags = THEATER_PRIVATE,
                        Pos = Vector( 1680, 60, -80 ),
                        Ang = Angle(0,-90,0),
                        Width = 120,
                        Height = 68,
                        --ThumbInfo = {
                                --Pos = Vector( -1000, -1980, -70 ),
                                --Ang = Angle(0, 90, 0)
                        --}
                }
        },
        ["Upper Business"] =
        {

        Min = Vector( 948, -123, -25 ),
        Max = Vector( 1329, 122, 73 ),

                Theater = {
                        Name = "Upper Business",
                        Flags = THEATER_REPLICATED,
                        Pos = Vector( 1322, 76, 60),
                        Ang = Angle(0,-90,0),
                        Width = 148,
                        Height = 77,
                }
        },
        ["Lower Business"] =
        {

        Min = Vector( 746, -175, -208 ),
        Max = Vector( 1386, 175, -66 ),


                Theater = {
                        Name = "Lower Business",
                        Flags = THEATER_REPLICATED,
                        Pos = Vector( 1199, 56, -105),
                        Ang = Angle(0,-90,0),
                        Width = 112,
                        Height = 63,
                }
        },
        ["Front Economy"] =
        {

        Min = Vector( 107, -179, -208 ),
        Max = Vector( 692, 179, -66 ),


                Theater = {
                        Name = "Front Economy",
                        Flags = THEATER_REPLICATED,
                        Pos = Vector( 588, 116, -113),
                        Ang = Angle(0, -90, 0),
                        Width = 168,
                        Height = 53,
                }
        },
        ["Middle Economy"] =
        {

        Min = Vector( -492, -168, -208 ),
        Max = Vector( 108, 177, -66 ),


                Theater = {
                        Name = "Middle Economy",
                        Flags = THEATER_REPLICATED,
                        Pos = Vector( 108, 28, -119),
                        Ang = Angle(0, -90, 0),
                        Width = 56,
                        Height = 33,
                }
        },
        ["Back Economy"] =
        {

        Min = Vector( -1291, -168, -208 ),
        Max = Vector( -493, 168, -66 ),


                Theater = {
                        Name = "Back Economy",
                        Flags = THEATER_REPLICATED,
                        Pos = Vector( -494, 59, -109),
                        Ang = Angle(0, -90, 0),
                        Width = 112,
                        Height = 63,
                }
        },
        ["The Wing"] =
        {

        Min = Vector( -768, -1728, -312 ),
        Max = Vector( 760, -184, 192 ),


                Theater = {
                        Name = "The Wing",
                        Flags = THEATER_HIDDEN,
                        Pos = Vector( 731, -110, -125),
                        Ang = Angle(0, -90, 0),
                        Width = 56,
                        Height = 33,
                }
        },
} )
