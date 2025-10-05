Config = {}

Config.WeaponRackItem = "weapons_rack"

Config.Keys = {
    moveForward    = 0x6319DB71, -- Arrow Up
    moveBackward   = 0x05CA7C52, -- Arrow Down
    moveLeft       = 0xA65EBAB4, -- Arrow Left
    moveRight      = 0xDEB34313, -- Arrow Right
    rotateLeftZ    = 0xE6F612E4, -- 1
    rotateRightZ   = 0x1CE6D9EB, -- 2    
    speedPlace     = 0x4F49CC4C, -- 3
    moveUp         = 0xB03A913B, -- 7
    moveDown       = 0x42385422, -- 8
    cancelPlace    = 0x760A9C6F, -- G
    confirmPlace   = 0xC7B5340A, -- ENTER
}

Config.Notify = {
    Rack = "Rack",
    Place = "Rack colocado correctamente",
    Cancel = "Colocación cancelada",
    Already = "Ya tienes un estante colocado",
    NotOwner = "No eres dueño de este rack",
    Picked = "Rack recogido correctamente",
    TooFar = "Estás demasiado lejos del rack",
    Weaponsin = "No puedes recoger el rack, todavía tiene armas guardadas",
    Error = "Error al entregar el arma",
    Collect = "Has retirado tu arma",
    NotWeapon = "Arma no disponible en el estante",
    Notequippet = "No tienes esa arma equipada o no se pudo quitar", 
    SaveWeapon = "Arma guardada en el estante",
    WeaponinRack = "El arma ya está en el estante",
    RackFull = "El estante ya está lleno",
    Notequippe = "No tienes esa arma equipada",
    InvalidRack = "Estante no válido",
    Menu = {
        Tittle = "Weapons rack",
        Select = "Select a weapon to remove it",
        Empty = "Vacío",
        Remove = "Remove from rack: Slot ",
        NotWeapons = "There are no weapons in storage",
    },
    Input = {
        Confirm = "Confirm",
        MinMax = "0.01 to 5",
        Change = "Only numbers between 0.01 and 5 are allowed",
        Speed = "Change Speed",
    },
    
}

Config.ControlTranslations = {
    title = "Controles",
    items = {
        { label = "Mover", text = "[← ↑ ↓ →] - Mover objeto" },
        { label = "Rotar", text = "[1/2]     - Rotar objeto" },
        { label = "Altura", text = "[7/8]     - Subir/Bajar" },
        { label = "Confirmar", text = "[ENTER]   - Confirmar posición" },
        { label = "Cancelar", text = "[G]       - Cancelar colocación" },
        { label = "Velocidad", text = "[3]       - Ajustar velocidad" }
    }
}

Config.WeaponLabels = {
    ["WEAPON_RIFLE_SPRINGFIELD"] = "Rifle Springfield",
    ["WEAPON_RIFLE_BOLTACTION"] = "Rifle Bolt Action",
    ["WEAPON_SNIPERRIFLE_CARCANO"] = "Rifle Carcano",
    ["WEAPON_SNIPERRIFLE_ROLLINGBLOCK"] = "Rifle Rollingblock",
    ["WEAPON_RIFLE_ELEPHANT"] = "Elephant Rifle",
    ["WEAPON_REPEATER_WINCHESTER"] = "Winchester Repeater",
    ["WEAPON_REPEATER_HENRY"] = "Henry Repeater",
    ["WEAPON_REPEATER_EVANS"] = "Evans Repeater",
    ["WEAPON_REPEATER_CARBINE"] = "Carbine Repeater",
    ["WEAPON_SHOTGUN_SEMIAUTO"] = "Semiauto Shotgun",
    ["WEAPON_SHOTGUN_REPEATING"] = "Repeating Shotgun",
    ["WEAPON_SHOTGUN_PUMP"] = "Pump Shotgun",
    ["WEAPON_SHOTGUN_DOUBLEBARREL"] = "Doublebarrel Shotgun",
}

Config.WeaponsAllowedInRack = { -- don't touch it if you don't know what you're doing
    ["rifles"] = {
        ["WEAPON_RIFLE_SPRINGFIELD"] = {
            offset = {x = -0.235, y = -0.241, z = 0.44},
            rotation = {x = 0.0, y = -66.0, z = 90.0}
        },
        ["WEAPON_RIFLE_BOLTACTION"] = {
            offset = {x = -0.234, y = -0.25, z = 0.44},
            rotation = {x = 0.0, y = -67.0, z = 90.0}
        },
        ["WEAPON_SNIPERRIFLE_CARCANO"] = {
            offset = {x = -0.235, y = -0.265, z = 0.40},
            rotation = {x = 0.0, y = -65.5, z = 90.0}
        },
        ["WEAPON_SNIPERRIFLE_ROLLINGBLOCK"] = {
            offset = {x = -0.250, y = -0.21, z = 0.52},
            rotation = {x = 0.0, y = -63.0, z = 90.0}
        },
        ["WEAPON_RIFLE_ELEPHANT"] = {
            offset = {x = -0.25, y = -0.235, z = 0.562},
            rotation = {x = 0.0, y = -58.0, z = 90.0}
        },
        ["WEAPON_REPEATER_WINCHESTER"] = {
            offset = {x = -0.245, y = -0.241, z = 0.44},
            rotation = {x = 0.0, y = -61.0, z = 90.0}
        },
        ["WEAPON_REPEATER_HENRY"] = {
            offset = {x = -0.254, y = -0.241, z = 0.44},
            rotation = {x = 0.0, y = -63.5, z = 90.0}
        },
        ["WEAPON_REPEATER_EVANS"] = {
            offset = {x = -0.254, y = -0.241, z = 0.44},
            rotation = {x = 0.0, y = -63.5, z = 90.0}
        },
        ["WEAPON_REPEATER_CARBINE"] = {
            offset = {x = -0.254, y = -0.241, z = 0.44},
            rotation = {x = 0.0, y = -63.5, z = 90.0}
        },
        ["WEAPON_SHOTGUN_SEMIAUTO"] = {
            offset = {x = -0.254, y = -0.241, z = 0.41},
            rotation = {x = 0.0, y = -65.2, z = 90.0}
        },
        ["WEAPON_SHOTGUN_REPEATING"] = {
            offset = {x = -0.254, y = -0.228, z = 0.44},
            rotation = {x = 0.0, y = -65.2, z = 90.0}
        },
        ["WEAPON_SHOTGUN_PUMP"] = {
            offset = {x = -0.254, y = -0.255, z = 0.44},
            rotation = {x = 0.0, y = -66.0, z = 90.0}
        },
        ["WEAPON_SHOTGUN_DOUBLEBARREL"] = {
            offset = {x = -0.254, y = -0.25, z = 0.56},
            rotation = {x = 0.0, y = -60.0, z = 90.0}
        },
    },
}

Config.WeaponsSecondRack = { -- don't touch it if you don't know what you're doing
    ["rifles"] = {
        ["WEAPON_RIFLE_SPRINGFIELD"] = {
            offset = {x = -0.254, y = 0.241, z = 0.44},
            rotation = {x = 0.0, y = -66.0, z = 268.0}
        },
        ["WEAPON_RIFLE_BOLTACTION"] = {
            offset = {x = -0.254, y = 0.238, z = 0.44},
            rotation = {x = 0.0, y = -68.0, z = 268.0}
        },
        ["WEAPON_SNIPERRIFLE_CARCANO"] = {
            offset = {x = -0.254, y = 0.265, z = 0.40},
            rotation = {x = 0.0, y = -65.5, z = 268.0}
        },
        ["WEAPON_SNIPERRIFLE_ROLLINGBLOCK"] = {
            offset = {x = -0.250, y = 0.21, z = 0.52},
            rotation = {x = 0.0, y = -63.0, z = 268.0}
        },
        ["WEAPON_RIFLE_ELEPHANT"] = {
            offset = {x = -0.25, y = 0.235, z = 0.562},
            rotation = {x = 0.0, y = -58.0, z = 268.0}
        },
        ["WEAPON_REPEATER_WINCHESTER"] = {
            offset = {x = -0.254, y = 0.241, z = 0.44},
            rotation = {x = 0.0, y = -61.0, z = 268.0}
        },
        ["WEAPON_REPEATER_HENRY"] = {
            offset = {x = -0.254, y = 0.241, z = 0.44},
            rotation = {x = 0.0, y = -63.5, z = 268.0}
        },
        ["WEAPON_REPEATER_EVANS"] = {
            offset = {x = -0.254, y = 0.241, z = 0.44},
            rotation = {x = 0.0, y = -63.5, z = 268.0}
        },
        ["WEAPON_REPEATER_CARBINE"] = {
            offset = {x = -0.254, y = 0.241, z = 0.44},
            rotation = {x = 0.0, y = -63.5, z = 268.0}
        },
        ["WEAPON_SHOTGUN_SEMIAUTO"] = {
            offset = {x = -0.254, y = 0.241, z = 0.41},
            rotation = {x = 0.0, y = -65.2, z = 268.0}
        },
        ["WEAPON_SHOTGUN_REPEATING"] = {
            offset = {x = -0.254, y = 0.228, z = 0.44},
            rotation = {x = 0.0, y = -65.2, z = 268.0}
        },
        ["WEAPON_SHOTGUN_PUMP"] = {
            offset = {x = -0.254, y = 0.25, z = 0.44},
            rotation = {x = 0.0, y = -66.0, z = 268.0}
        },
        ["WEAPON_SHOTGUN_DOUBLEBARREL"] = {
            offset = {x = -0.254, y = 0.25, z = 0.56},
            rotation = {x = 0.0, y = -60.0, z = 268.0}
        },
    },
}