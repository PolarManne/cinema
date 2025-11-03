Location.Add("cinema_reinhardt", {
    ["Light Room"] = {
        Min = Vector(4116.9663085938, 746.56701660156, -2508.1506347656),
        Max = Vector(4620.0454101563, 1390.9842529297, -2172.2810058594),
        Theater = {
            Name = "Light Room",
            Flags = THEATER_PRIVATE,
            Pos = Vector(4478, 830, -2280),
            Ang = Angle(0, 180, 0),
            Width = 256,
            Height = 140,
        }
    },
    ["Dark Room"] = {
        Min = Vector(3112.4858398438, 752.56768798828, -2534.5239257813),
        Max = Vector(3658.0368652344, 1412.4412841797, -2213.9252929688),
        Theater = {
            Name = "Dark Room",
            Flags = THEATER_PRIVATE,
            Pos = Vector(3262, 1306, -2280),
            Ang = Angle(0, 0, 0),
            Width = 256,
            Height = 140,
        }
    },
    ["Public Theater"] = { -- FIX
        Min = Vector(4013.4272460938, -1079.1522216797, -2171.9250488281),
        Max = Vector(5368.6640625, 223.30871582031, -1414.6689453125),
        Theater = {
            Name = "Public Theater",
            Flags = THEATER_PUBLIC,
            Pos = Vector(4322, 30, -1513),
            Ang = Angle(0, 0, 0),
            Width = 752,
            Height = 422,
        }
    },
	["Penthouse"] = { -- FIX
        Min = Vector(-254.88578796387, -378.34707641602, -92.901649475098),
        Max = Vector(448.94366455078, 113.69933319092, 73.036674499512),
        Theater = {
            Name = "Penthouse",
            Flags = THEATER_PUBLIC,
            Pos = Vector(53, -338, 41),
            Ang = Angle(0, 180, 0),
            Width = 119,
            Height = 69,
        }
    },
    ["Burger King"] = { -- FIX
        Min = Vector(2033.8387451172, 119.03632354736, -2010.1214599609),
        Max = Vector(2567.7749023438, 802.53045654297, -1777.779296875),
        Theater = {
            Name = "Burger King",
            Flags = THEATER_NONE,
            Pos = Vector(2457.5, 451, -1882),
            Ang = Angle(0, 270, 0),
            Width = 81,
            Height = 43,
        }
    },
    ["Lobby"] = {
        Min = Vector(1075.91015625, -967.51885986328, -2071.0854492188),
        Max = Vector(1955.3946533203, 683.76153564453, -1385.0249023438),
    },
    ["Left Hallway"] = {
        Min = Vector(1963.5844726563, -170.19888305664, -2012.5903320313),
        Max = Vector(2589.4216308594, 117.85003662109, -1819.4061279297),
    },
    ["Restrooms"] = {
        Min = Vector(3151.0163574219, -786.85229492188, -2176.8547363281),
        Max = Vector(3528.9777832031, -160.9947052002, -1947.6950683594),
    },
	["Right Hallway"] = {
		Min = Vector(475.31008911133, -235.68251037598, -1998.9124755859),
		Max = Vector(1075.4069824219, 209.42875671387, -1831.0457763672),
	},
	["Round Window Room"] = {
		Min = Vector(113.825340271, -179.97932434082, -2048.4262695313),
		Max = Vector(482.32540893555, 142.2780456543, -1834.1186523438),
	},
	["Elevator"] = {
		Min = Vector(212.923828125, 119.82884979248, -2040.7470703125),
		Max = Vector(448.92663574219, 358.93389892578, 89.037734985352),
	},
	["Theater Hallway"] = {
		Min = Vector(2113.1809082031, -640.51629638672, -2155.8237304688),
		Max = Vector(2920.9621582031, -165.18084716797, -1821.9388427734),
	},
	["Theater Hallway "] = { -- space at the end because Cinema doesn't allow location definitions to share names kek
		Min = Vector(2907.669921875, -1231.5076904297, -2142.3483886719),
		Max = Vector(3149.2824707031, 190.76564025879, -1934.0213623047),
	},
})