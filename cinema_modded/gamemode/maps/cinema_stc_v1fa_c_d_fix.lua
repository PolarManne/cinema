Location.Add( "cinema_stc_v1fa_c_d_fix",
{

	[ "Spawn Square" ] =
	{
		Min = Vector( -264, -264, 8 ),
		Max = Vector( 264, 264, 11 ),
	},

	[ "Kotatsu 1" ] =
	{
		Min = Vector( -271, 2160, 64 ),
		Max = Vector( 270, 2702, 202 ),
		Theater = {
			Name = "Kotatsu 1",
			Flags = THEATER_REPLICATED,
			Pos = Vector( 98, 2228, 196 ),
			Ang = Angle( 0, 180, 0 ),
			Width = 195,
			Height = 210 * 8.4 / 16,
			ThumbInfo = {
				Pos = Vector( -288, 2268, 134 ),
				Ang = Angle( 0, 180, 0)
			}
		}
	},

	[ "Kotatsu 2" ] =
	{
		Min = Vector( -495, 1937, 224 ),
		Max = Vector( 272, 2704, 382 ),
		Theater = {
			Name = "Kotatsu 2",
			Flags = THEATER_REPLICATED,
			Pos = Vector(-14, 2003, 356),
			Ang = Angle(0, 180, 0),
			Width = 195,
			Height = 210 * 8.4 / 16,
			ThumbInfo = {
				Pos = Vector( 288, 2667, 304 ),
				Ang = Angle( 0, 0, 0)
			}
		}
	},

	[ "Kotatsu Private" ] =
	{
		Min = Vector( -272, 2160, 400 ),
		Max = Vector( 272, 2704, 560 ),
		Theater = {
			Name = "Kotatsu Private",
			Flags = THEATER_PRIVATE,
			Pos = Vector(204, 2529, 532),
			Ang = Angle(0, -90, 0),
			Width = 195,
			Height = 210 * 8.4 / 16,
			ThumbInfo = {
				Pos = Vector( -196, 2720, 471 ),
				Ang = Angle( 0, 90, 0)
			}
		}
	},

	[ "Neko Theater" ] =
	{
		Min = Vector( -14112, -13275, -11184 ),
		Max = Vector( -13111, -12384, -10512 ),
		Theater = {
			Name = "Neko Theater",
			Flags = THEATER_NONE,
			Pos = Vector( -13795, -12448, -10878 ),
			Ang = Angle(0, 0, 0),
			Width = 390,
			Height = 426 * 8.4 / 16,
			ThumbInfo = {
				Pos = Vector( -13600, -13792, -10780 ),
				Ang = Angle(0, -90, 0)
			}
		}
	},

    
	[ "Underground Theater" ] =
	{
		Min = Vector( -6458, 1068, -1249 ),
		Max = Vector( -5056, 2366, -640 ),
		Theater = {
			Name = "Underground Theater",
			Flags = THEATER_NONE,
			Pos = Vector( -6180, 1693, -850 ),
			Ang = Angle(0, 90, 0),
			Width = 197,
			Height = 215 * 8.4 / 16,
		}
	},
   
	[ "Magma Theater" ] =
	{
		Min = Vector( -4005, -1760, -1787 ),
		Max = Vector( -2752, -502, -951 ),
		Theater = {
			Name = "Magma Theater",
			Flags = THEATER_NONE,
			Pos = Vector( -3226, -1559, -991 ),
			Ang = Angle(0, 180, 0),
			Width = 370,
			Height = 400 * 8.4 / 16,
		}
	},

    
    	[ "Janny Theater" ]=
	{
		Min = Vector( -937, -8515, 1771 ),
		Max = Vector( 2437, -4645, 2568 ),
		Theater = {
			Name = "Janny Theater",
			Flags = THEATER_PRIVILEGED,
			Pos = Vector( 1024, -7486, 2240 ),
			Ang = Angle(0, 180, 0),
			Width = 576,
			Height = 256,
		}
	},

    	[ "Atlantis Theater" ]=
	{
		Min = Vector( -5881, 7409, -1387 ),
		Max = Vector( -3976, 9443, -480 ),
		Theater = {
			Name = "Atlantis Theater",
			Flags = THEATER_NONE,
			Pos = Vector( -5846, 7745, -625 ),
			Ang = Angle(0, 90, 0),
			Width = 1022,
			Height = 510,
		}
	},    

    	[ "Skybox Theater" ]=
	{
		Min = Vector( 3136, 50, 4450 ),
		Max = Vector( 6144, 3066, 5977 ),
		Theater = {
			Name = "Skybox Theater",
			Flags = THEATER_NONE,
			Pos = Vector( 4348, 2604, 5141 ),
			Ang = Angle(0, 0, 0),
			Width = 900,
			Height = 900 * 8.4 / 16,
		}
	},

    	[ "Mirror Theater" ]=
	{
		Min = Vector( 4208, -8432, -544 ),
		Max = Vector( 5200, -7664, -192 ),
		Theater = {
			Name = "Mirror Theater",
			Flags = THEATER_REPLICATED,
			Pos = Vector( 5088, -8422, -224 ),
			Ang = Angle(0, 180, 0),
			Width = 768,
			Height = 318,
			ThumbInfo = {
          Pos = Vector( 4199, -7088, -459 ),
				Ang = Angle(0, 90, 0)
			}
		}
	},    

    	[ "Pool Theater" ]=
	{
		Min = Vector( 2368, -8896, -744 ),
		Max = Vector( 3328, -7968, -195 ),
		Theater = {
			Name = "Pool Theater",
			Flags = THEATER_REPLICATED,
			Pos = Vector( 2378, -8800, -224 ),
			Ang = Angle(0, 90, 0),
			Width = 768,
			Height = 318,
			ThumbInfo = {
          Pos = Vector( 3691, -7088, -459 ),
				Ang = Angle(0, 90, 0)
			}
		}
	},     

    	[ "Private Suite 1" ]=
	{
		Min = Vector( 2048, -7072, -640 ),
		Max = Vector( 2640, -6304, -320 ),
		Theater = {
			Name = "Private Suite 1",
			Flags = THEATER_PRIVATE,
        Pos = Vector( 2112, -6884, -388 ),
			Ang = Angle(0, 90, 0),
			Width = 390,
			Height = 220,
			ThumbInfo = {
          Pos = Vector( 2688, -6688, -416 ),
				Ang = Angle(0, 0, 0)
			}
		}
	},      
    
    	[ "Private Suite 2" ]=
	{
		Min = Vector( 3312, -6112, -928 ),
		Max = Vector( 4080, -5520, -608 ),
		Theater = {
			Name = "Private Suite 2",
			Flags = THEATER_PRIVATE,
			Pos = Vector( 3500, -5584, -675 ),
			Ang = Angle(0, 0, 0),
			Width = 390,
			Height = 220,
			ThumbInfo = {
          Pos = Vector( 3696, -6168, -708 ),
				Ang = Angle(0, -90, 0)
			}
		}
	},      
    
    	[ "Public Suite 1" ]=
	{
		Min = Vector( 4027, -7024, -960 ),
		Max = Vector( 4607, -6368, -616 ),
		Theater = {
			Name = "Public Suite 1",
			Flags = THEATER_REPLICATED,
			Pos = Vector( 4542, -6510, -704 ),
			Ang = Angle(0, -90, 0),
			Width = 390,
			Height = 220,
			ThumbInfo = {
          Pos = Vector( 3840, -6706, -734 ),
				Ang = Angle(0, 180, 0)
			}
		}
	},      
    
    	[ "Public Suite 2" ]=
	{
		Min = Vector( 2752, -7008, -960 ),
		Max = Vector( 3320, -6368, -604 ),
		Theater = {
			Name = "Public Suite 2",
			Flags = THEATER_REPLICATED,
			Pos = Vector( 2822, -6880, -704 ),
			Ang = Angle(0, 90, 0),
			Width = 390,
			Height = 220,
			ThumbInfo = {
          Pos = Vector( 3520, -6687, -734 ),
				Ang = Angle(0, 0, 0)
			}
		}
	},          
		[ "Silent Hill Theater" ]=
	{
		Min = Vector( 9216, -1984, -2032 ),
		Max = Vector( 9983, -1472, -1856 ),
		Theater = {
			Name = "Silent Hill Theater",
			Flags = THEATER_NONE,
			Pos = Vector( 9949.75, -1618, -1879.5 ),
			Ang = Angle(0, -90, 0),
			Width = 195,
			Height = 210 * 8.4 / 16,
		}
	},
		[ "VA-11 HALL-A" ]=
	{
		Min = Vector( -900, -5671, -10345 ),
		Max = Vector( -37, -4897, -10136 ),
		Theater = {
			Name = "VA-11 HALL-A",
			Flags = THEATER_REPLICATED,
			Pos = Vector( -57.25, -5152, -10152.5 ),
			Ang = Angle(0, -90, 0),
			Width = 325,
			Height = 170,
			ThumbInfo = {
          Pos = Vector( 3948, -5338, -480 ),
				Ang = Angle(0, -90, 0)
			}
		}
	},    
} )

function AllowWeaponsInCinema(GmObject)
	if not (GmObject) then return end
	
	GmObject.SpawnMenuEnabled = function() return true end
	GmObject.SpawnMenuOpen = function() return LocalPlayer():GetUserGroup() == "superadmin" end
	
	-- Sandbox always uses GAMEMODE
	GAMEMODE.PlayerSpawnProp = function (ply, model)
		if ( !ply:IsAdmin() ) then
			return false
		end
	end 
end

hook.Add("Initialize", "dooka_CinemaPatchesInit", function() AllowWeaponsInCinema(GAMEMODE) end)
hook.Add("OnReloaded", "dooka_CinemaPatchesReloaded", function() AllowWeaponsInCinema(GM) end)
