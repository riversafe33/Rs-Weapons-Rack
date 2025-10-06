Config = {}

Config.WeaponRackItem = "weapons_rack"
Config.SpawnDistance = 20.0

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
    Place = "Rack placed successfully",
    Cancel = "Placement canceled",
    Already = "You already have a rack placed",
    NotOwner = "You are not the owner of this rack",
    Picked = "Rack picked up successfully",
    TooFar = "You are too far from the rack",
    Weaponsin = "You cannot pick up the rack, it still has weapons stored",
    Error = "Error delivering the weapon",
    Collect = "You have withdrawn your weapon",
    NotWeapon = "Weapon not available in the rack",
    Notequippet = "You don’t have that weapon equipped or it could not be removed",
    SaveWeapon = "Weapon stored in the rack",
    WeaponinRack = "The weapon is already in the rack",
    RackFull = "The rack is already full",
    Notequippe = "You don’t have that weapon equipped",
    InvalidRack = "Invalid rack",
    NotPermis = "You do not have permission to withdraw this weapon",
    OnlyOwn = "Only the owner can grant permissions",
    NoPermSave = "You do not have permission to store weapons",
    IvalidRack = "Invalid rack",
    NoRackPermis = "You do not have permission to access the rack",
    PlayerNoPermis = "The player does not have permission",
    DelectPermis = "Permission revoked",
    OnlyOwnDel = "Only the owner can revoke permissions",
    PermisGiveTo = "Permission granted to",
    AlreadyHas = "The player already has permission",
    PlayerNot = "Player not found online",
    Menu = {
        Weapons = "Weapons",
        GivePerm = "Grant permission",
        DelpPerm = "Revoke permissions",
        Rack = "Rack Menu",
        Select = "Select an option",
        Remove = "Remove from rack: Slot ",
        Empty = "Empty rack",
        RackwWea = "Weapons in Rack",
        SelectWea = "Select a weapon",
        DelPerms = "Revoke permissions",
        SelectPlayer = "Select player",
        NoPerms = "No permissions",
    },
    Input = {
        Pattern = "(yes|no)",
        Yes = "yes",
        ConfirmD = "Confirm deletion",
        Ej = "Ex: 1",
        PlayerId = "Player ID",
        ValID = "Enter a valid Char ID",
        YesConfirm = "yes to confirm",
        ConfirmDel = "Confirm deletion",
        YesNo = "Type 'yes' to confirm or 'no' to cancel",
        Confirm = "Confirm",
        MinMax = "0.01 to 5",
        Change = "Only numbers between 0.01 and 5 are allowed",
        Speed = "Change Speed",
    },
    Promp = {
        Open = "Open rack",
        PutAway = "Store weapon",
        Pickup = "Pick up rack",
    },
}

Config.ControlTranslations = {
    title = "Controls",
    items = {
        { label = "Move", text = "[← ↑ ↓ →] - Move object" },
        { label = "Rotate", text = "[1/2]     - Rotate object" },
        { label = "Height", text = "[7/8]     - Raise/Lower" },
        { label = "Confirm", text = "[ENTER]   - Confirm position" },
        { label = "Cancel", text = "[G]       - Cancel placement" },
        { label = "Speed", text = "[3]       - Adjust speed" }
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
            offset = {x = -0.234, y = -0.241, z = 0.44},
            rotation = {x = 0.0, y = -66.0, z = 90.0}
        },
        ["WEAPON_RIFLE_BOLTACTION"] = {
            offset = {x = -0.234, y = -0.25, z = 0.44},
            rotation = {x = 0.0, y = -67.0, z = 90.0}
        },
        ["WEAPON_SNIPERRIFLE_CARCANO"] = {
            offset = {x = -0.234, y = -0.265, z = 0.40},
            rotation = {x = 0.0, y = -65.5, z = 90.0}
        },
        ["WEAPON_SNIPERRIFLE_ROLLINGBLOCK"] = {
            offset = {x = -0.234, y = -0.21, z = 0.52},
            rotation = {x = 0.0, y = -63.0, z = 90.0}
        },
        ["WEAPON_RIFLE_ELEPHANT"] = {
            offset = {x = -0.234, y = -0.235, z = 0.562},
            rotation = {x = 0.0, y = -58.0, z = 90.0}
        },
        ["WEAPON_REPEATER_WINCHESTER"] = {
            offset = {x = -0.234, y = -0.241, z = 0.44},
            rotation = {x = 0.0, y = -61.0, z = 90.0}
        },
        ["WEAPON_REPEATER_HENRY"] = {
            offset = {x = -0.234, y = -0.241, z = 0.44},
            rotation = {x = 0.0, y = -63.5, z = 90.0}
        },
        ["WEAPON_REPEATER_EVANS"] = {
            offset = {x = -0.234, y = -0.241, z = 0.44},
            rotation = {x = 0.0, y = -63.5, z = 90.0}
        },
        ["WEAPON_REPEATER_CARBINE"] = {
            offset = {x = -0.234, y = -0.241, z = 0.44},
            rotation = {x = 0.0, y = -63.5, z = 90.0}
        },
        ["WEAPON_SHOTGUN_SEMIAUTO"] = {
            offset = {x = -0.234, y = -0.241, z = 0.41},
            rotation = {x = 0.0, y = -65.2, z = 90.0}
        },
        ["WEAPON_SHOTGUN_REPEATING"] = {
            offset = {x = -0.234, y = -0.228, z = 0.44},
            rotation = {x = 0.0, y = -65.2, z = 90.0}
        },
        ["WEAPON_SHOTGUN_PUMP"] = {
            offset = {x = -0.234, y = -0.255, z = 0.44},
            rotation = {x = 0.0, y = -66.0, z = 90.0}
        },
        ["WEAPON_SHOTGUN_DOUBLEBARREL"] = {
            offset = {x = -0.234, y = -0.25, z = 0.56},
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
