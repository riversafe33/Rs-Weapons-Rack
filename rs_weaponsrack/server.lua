local RacksInventory = {}
local loadedRacks = {}
local Core = exports.vorp_core:GetCore()
local Inv = exports.vorp_inventory
local VorpInv = exports.vorp_inventory:vorp_inventoryApi()

local function GetRackInventoryId(rackKey)
    return "rack_" .. rackKey
end

local function registerRackInventory(rackKey)
    local invId = GetRackInventoryId(rackKey)
    if not rackKey then return end

    local name = "Rack: " .. rackKey
    local limit = 12

    local isRegistered = Inv:isCustomInventoryRegistered(invId)
    if not isRegistered then
        Inv:registerInventory({
            id = invId,
            name = name,
            limit = limit,
            acceptWeapons = true,
            shared = true,
            ignoreItemStackLimit = true,
            whitelistItems = false,
            UsePermissions = false,
            UseBlackList = false,
            whitelistWeapons = false,
        })
    end
end

local function SaveRacksToFile()
    SaveResourceFile(GetCurrentResourceName(), "racks_data.json", json.encode(RacksInventory), -1)
end

local function LoadRacksFromFile()
    local data = LoadResourceFile(GetCurrentResourceName(), "racks_data.json")
    if data then
        RacksInventory = json.decode(data)
    end
end

AddEventHandler('onResourceStart', function(resource) 
    if resource ~= GetCurrentResourceName() then 
        return 
    end 
    LoadRacksFromFile() 
    
    exports.oxmysql:execute('SELECT * FROM weapon_racks', {}, function(results) 
        if results then 
            for _, row in pairs(results) do 
                local permisos = {} 
                if row.permisos and row.permisos ~= "" then 
                    local ok, decoded = pcall(json.decode, row.permisos) 
                    if ok and type(decoded) == "table" then 
                        permisos = decoded 
                    end 
                end 
                loadedRacks[row.id] = { 
                    id = row.id, 
                    x = row.x, 
                    y = row.y, 
                    z = row.z, 
                    heading = row.heading, 
                    owner_identifier = row.owner_identifier, 
                    owner_charid = row.owner_charid, 
                    permisos = permisos 
                } 
                registerRackInventory(row.id) 
                local invId = GetRackInventoryId(row.id) 
                RacksInventory[invId] = RacksInventory[invId] or {} 
            end 
        end 
    end)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(300000)
        SaveRacksToFile()
    end
end)

RegisterNetEvent('rs_weaponsrack:server:requestRacks')
AddEventHandler('rs_weaponsrack:server:requestRacks', function()
    local src = source
    TriggerClientEvent('rs_weaponsrack:client:receiveRacks', src, loadedRacks)
end)

RegisterNetEvent('rs_weaponsrack:server:saveOwner')
AddEventHandler('rs_weaponsrack:server:saveOwner', function(x, y, z, heading)
    local src = source
    local User = Core.getUser(src)
    if not User then return end
    local Character = User.getUsedCharacter
    if not Character then return end

    local params = {
        ['@identifier'] = Character.identifier,
        ['@charid'] = Character.charIdentifier,
        ['@x'] = x,
        ['@y'] = y,
        ['@z'] = z,
        ['@heading'] = heading,
        ['@permisos'] = json.encode({})
    }

    exports.oxmysql:execute([[
        INSERT INTO weapon_racks (owner_identifier, owner_charid, x, y, z, heading)
        VALUES (@identifier, @charid, @x, @y, @z, @heading)
    ]], params, function(result)
        if result and result.insertId then
            local rackId = result.insertId
            loadedRacks[rackId] = {
                id = rackId,
                x = x,
                y = y,
                z = z,
                heading = heading,
                owner_identifier = Character.identifier,
                owner_charid = Character.charIdentifier,
                permisos = {}
            }
            registerRackInventory(rackId)
            TriggerClientEvent('rs_weaponsrack:Client:ReceiveRackItems', -1, rackId, RacksInventory[GetRackInventoryId(rackId)] or {})
            TriggerClientEvent('rs_weaponsrack:client:receiveRacks', -1, loadedRacks)
        end
    end)
end)

RegisterNetEvent("rs_weaponsrack:Server:RequestRackItems")
AddEventHandler("rs_weaponsrack:Server:RequestRackItems", function(rackId, openMenu)
    local src = source
    local rack = loadedRacks[rackId]
    if not rack then
        Core.NotifyLeft(src, Config.Notify.Rack, Config.Notify.InvalidRack, "menu_textures", "cross", 3000, "COLOR_RED")
        return
    end

    local invId = GetRackInventoryId(rackId)
    RacksInventory[invId] = RacksInventory[invId] or {}

    local permisos = rack.permisos or {}

    TriggerClientEvent("rs_weaponsrack:Client:ReceiveRackItems", src, rackId, RacksInventory[invId], openMenu, permisos)
end)

RegisterNetEvent("rs_weaponsrack:Server:ReceiveCurrentWeapon")
AddEventHandler("rs_weaponsrack:Server:ReceiveCurrentWeapon", function(rackId, weaponData)
    local src = source
    if not weaponData or not weaponData.weaponId or not weaponData.name then
        Core.NotifyLeft(src, Config.Notify.Rack, Config.Notify.Notequippe, "menu_textures", "cross", 3000, "COLOR_RED")
        return
    end

    local User = Core.getUser(src)
    if not User then return end
    local Character = User.getUsedCharacter
    if not Character or not Character.charIdentifier then return end

    local invId = GetRackInventoryId(rackId)
    RacksInventory[invId] = RacksInventory[invId] or {}

    local limit = 12
    if #RacksInventory[invId] >= limit then
        Core.NotifyLeft(src, Config.Notify.Rack, Config.Notify.RackFull, "menu_textures", "cross", 3000, "COLOR_RED")
        return
    end

    for _, w in ipairs(RacksInventory[invId]) do
        if tostring(w.weaponId) == tostring(weaponData.weaponId) then
            Core.NotifyLeft(src, Config.Notify.Rack, Config.Notify.WeaponinRack, "menu_textures", "cross", 3000, "COLOR_RED")
            return
        end
    end

    exports.vorp_inventory:subWeapon(src, weaponData.weaponId, function(success)
        if success then
            table.insert(RacksInventory[invId], {
                weaponId = weaponData.weaponId,
                name = weaponData.name,
                serial = weaponData.serial,
                owner = Character.charIdentifier
            })
            TriggerClientEvent("rs_weaponsrack:Client:ReceiveRackItems", -1, rackId, RacksInventory[invId])
            Core.NotifyLeft(src, Config.Notify.Rack, Config.Notify.SaveWeapon, "generic_textures", "tick", 4000, "COLOR_GREEN")
            SaveRacksToFile()
        else
            Core.NotifyLeft(src, Config.Notify.Rack, Config.Notify.Notequippet, "menu_textures", "cross", 3000, "COLOR_RED")
        end
    end)
end)

local function HasPermission(identifier, charid, rack)
    if not rack then return false end
    if identifier == rack.owner_identifier and charid == rack.owner_charid then 
        return true 
    end
    local perms = type(rack.permisos) == "table" and rack.permisos or {}
    for _, p in ipairs(perms) do
        if p.charid == charid then
            return true
        end
    end
    return false
end

RegisterNetEvent("rs_weaponsrack:Server:TakeWeapon")
AddEventHandler("rs_weaponsrack:Server:TakeWeapon", function(rackId, weaponId)
    local src = source

    local User = Core.getUser(src)
    if not User then 
        return 
    end

    local Character = User.getUsedCharacter
    if not Character or not Character.charIdentifier then 
        return 
    end

    local invId = GetRackInventoryId(rackId)
    local armas = RacksInventory[invId] or {}
    local foundIndex = nil
    local weaponData = nil

    for i, w in ipairs(armas) do
        if tostring(w.weaponId) == tostring(weaponId) then
            foundIndex = i
            weaponData = w
            break
        end
    end

    if not foundIndex or not weaponData then
        Core.NotifyLeft(src, Config.Notify.Rack, Config.Notify.NotWeapon, "menu_textures", "cross", 3000, "COLOR_RED")
        return
    end

    local rack = loadedRacks[rackId]
    if not rack then
        Core.NotifyLeft(src, Config.Notify.Rack, Config.Notify.InvalidRack, "menu_textures", "cross", 3000, "COLOR_RED")
        return
    end

    local isOwner = weaponData.owner == Character.charIdentifier
    local hasAccess = HasPermission(Character.identifier, Character.charIdentifier, rack)

    if not isOwner and not hasAccess then
        Core.NotifyLeft(src, Config.Notify.Rack, Config.Notify.NotPermis, "menu_textures", "cross", 3000, "COLOR_RED")
        return
    end

    exports.vorp_inventory:giveWeapon(src, weaponData.weaponId, 1, function(success)
        if success then
            table.remove(armas, foundIndex)
            RacksInventory[invId] = armas
            TriggerClientEvent("rs_weaponsrack:Client:ReceiveRackItems", -1, rackId, armas)
            Core.NotifyLeft(src, Config.Notify.Rack, Config.Notify.Collect, "generic_textures", "tick", 4000, "COLOR_GREEN")
            SaveRacksToFile()
        else
            Core.NotifyLeft(src, Config.Notify.Rack, Config.Notify.Error, "menu_textures", "cross", 3000, "COLOR_RED")
        end
    end)
end)

RegisterNetEvent("rs_weaponsrack:Server:GrantPermission")
AddEventHandler("rs_weaponsrack:Server:GrantPermission", function(rackId, targetCharId)
    local src = source
    local User = Core.getUser(src)
    if not User then return end
    local Character = User.getUsedCharacter
    if not Character then return end

    local rack = loadedRacks[rackId]
    if not rack then return end

    if Character.identifier ~= rack.owner_identifier or Character.charIdentifier ~= rack.owner_charid then
        Core.NotifyLeft(src, Config.Notify.Rack, Config.Notify.OnlyOwn, "menu_textures", "cross", 3000, "COLOR_RED")
        return
    end

    local targetPlayer = nil
    for _, player in ipairs(GetPlayers()) do
        local user = Core.getUser(player)
        if user then
            local char = user.getUsedCharacter
            if char and char.charIdentifier == targetCharId then
                targetPlayer = {
                    charid = char.charIdentifier,
                    identifier = char.identifier,
                    name = char.firstname .. ' ' .. char.lastname
                }
                break
            end
        end
    end

    if not targetPlayer then
        Core.NotifyLeft(src, Config.Notify.Rack, Config.Notify.PlayerNot, "menu_textures", "cross", 3000, "COLOR_RED")
        return
    end

    local perms = rack.permisos or {}
    for _, p in ipairs(perms) do
        if p.charid == targetPlayer.charid then
            Core.NotifyLeft(src, Config.Notify.Rack, Config.Notify.AlreadyHas, "menu_textures", "cross", 3000, "COLOR_RED")
            return
        end
    end

    table.insert(perms, {charid = targetPlayer.charid, name = targetPlayer.name, identifier = targetPlayer.identifier})
    rack.permisos = perms
    exports.oxmysql:execute("UPDATE weapon_racks SET permisos = ? WHERE id = ?", {json.encode(perms), rackId})

    Core.NotifyLeft(src, Config.Notify.Rack, Config.Notify.PermisGiveTo .. " " .. targetPlayer.name, "generic_textures", "tick", 3000, "COLOR_GREEN")
end)

RegisterNetEvent("rs_weaponsrack:Server:RevokePermission")
AddEventHandler("rs_weaponsrack:Server:RevokePermission", function(rackId, targetIdentifier, targetCharId)
    local src = source
    local User = Core.getUser(src)
    if not User then return end
    local Character = User.getUsedCharacter
    if not Character then return end

    local rack = loadedRacks[rackId]
    if not rack then return end

    if Character.identifier ~= rack.owner_identifier or Character.charIdentifier ~= rack.owner_charid then
        Core.NotifyLeft(src, Config.Notify.Rack, Config.Notify.OnlyOwnDel, "menu_textures", "cross", 3000, "COLOR_RED")
        return
    end

    local perms = rack.permisos or {}
    for i, p in ipairs(perms) do
        if p.charid == targetCharId then
            table.remove(perms, i)
            rack.permisos = perms
            exports.oxmysql:execute("UPDATE weapon_racks SET permisos = ? WHERE id = ?", {json.encode(perms), rackId})
            Core.NotifyLeft(src, Config.Notify.Rack, Config.Notify.DelectPermis, "generic_textures", "tick", 3000, "COLOR_GREEN")
            return
        end
    end

    Core.NotifyLeft(src, Config.Notify.Rack, Config.Notify.PlayerNoPermis, "menu_textures", "cross", 3000, "COLOR_RED")
end)

RegisterNetEvent('rs_weaponsrack:server:pickUpByOwner')
AddEventHandler('rs_weaponsrack:server:pickUpByOwner', function(rackId)
    local src = source
    local User = Core.getUser(src)
    if not User then return end
    local Character = User.getUsedCharacter
    if not Character then return end

    local u_identifier = Character.identifier
    local u_charid = Character.charIdentifier

    exports.oxmysql:execute(
        'SELECT * FROM weapon_racks WHERE id = ? AND owner_identifier = ? AND owner_charid = ?',
        {rackId, u_identifier, u_charid},
        function(results)
            if results and #results > 0 then
                local row = results[1]
                local rackCoords = vector3(row.x, row.y, row.z)
                local playerPed = GetPlayerPed(src)
                local playerCoords = GetEntityCoords(playerPed)
                local distance = #(playerCoords - rackCoords)

                local invId = GetRackInventoryId(rackId)
                local armas = RacksInventory[invId] or {}
                if #armas > 0 then
                    Core.NotifyLeft(src, Config.Notify.Rack, Config.Notify.Weaponsin, "menu_textures", "cross", 3000, "COLOR_RED")
                    return
                end

                if distance <= 2.5 then
                    TriggerClientEvent('rs_weaponsrack:client:removeRack', -1, rackId)

                    loadedRacks[rackId] = nil
                    RacksInventory[invId] = nil
                    SaveRacksToFile()

                    exports.oxmysql:execute('DELETE FROM weapon_racks WHERE id = ?', {rackId}, function(result)
                        local affected = result and (result.affectedRows or result.affected_rows or result.changes)
                        if affected and affected > 0 then
                            VorpInv.addItem(src, Config.WeaponRackItem, 1)
                            Core.NotifyLeft(src, Config.Notify.Rack, Config.Notify.Picked, "generic_textures", "tick", 4000, "COLOR_GREEN")
                        end
                    end)
                else
                    Core.NotifyLeft(src, Config.Notify.Rack, Config.Notify.TooFar, "menu_textures", "cross", 3000, "COLOR_RED")
                end
            else
                Core.NotifyLeft(src, Config.Notify.Rack, Config.Notify.NotOwner, "menu_textures", "cross", 3000, "COLOR_RED")
            end
        end
    )
end)

RegisterNetEvent("rs_weaponsrack:Server:TryOpenRack")
AddEventHandler("rs_weaponsrack:Server:TryOpenRack", function(rackId)
    local src = source
    local User = Core.getUser(src)
    if not User then return end
    local Character = User.getUsedCharacter
    if not Character or not Character.charIdentifier then return end

    local rack = loadedRacks[rackId]
    if not rack then
        Core.NotifyLeft(src, Config.Notify.Rack, Config.Notify.IvalidRack, "menu_textures", "cross", 3000, "COLOR_RED")
        return
    end

    if not HasPermission(Character.identifier, Character.charIdentifier, rack) then
        Core.NotifyLeft(src, Config.Notify.Rack, Config.Notify.NoRackPermis, "menu_textures", "cross", 3000, "COLOR_RED")
        return
    end

    local invId = GetRackInventoryId(rackId)
    RacksInventory[invId] = RacksInventory[invId] or {}
    local permisos = rack.permisos or {}

    TriggerClientEvent("rs_weaponsrack:Client:ReceiveRackItems", src, rackId, RacksInventory[invId], true, permisos)
end)

RegisterNetEvent("rs_weaponsrack:Server:TryStoreWeapon")
AddEventHandler("rs_weaponsrack:Server:TryStoreWeapon", function(rackId)
    local src = source
    local User = Core.getUser(src)
    if not User then return end
    local Character = User.getUsedCharacter
    if not Character or not Character.charIdentifier then return end

    local rack = loadedRacks[rackId]
    if not rack then
        Core.NotifyLeft(src, Config.Notify.Rack, Config.Notify.IvalidRack, "menu_textures", "cross", 3000, "COLOR_RED")
        return
    end

    if not HasPermission(Character.identifier, Character.charIdentifier, rack) then
        Core.NotifyLeft(src, Config.Notify.Rack, Config.Notify.NoPermSave, "menu_textures", "cross", 3000, "COLOR_RED")
        return
    end

    TriggerClientEvent("rs_weaponsrack:Client:RequestCurrentWeapon", src, rackId)
end)

VorpInv.RegisterUsableItem(Config.WeaponRackItem, function(data)
    local src = data.source
    local User = Core.getUser(src)
    if not User then return end
    local Character = User.getUsedCharacter
    if not Character then return end

    local identifier = Character.identifier
    local charid = Character.charIdentifier
    VorpInv.CloseInv(src)

    exports.oxmysql:execute('SELECT id FROM weapon_racks WHERE owner_identifier = ? AND owner_charid = ?', {
        identifier, charid
    }, function(result)
        if result and #result > 0 then
            Core.NotifyLeft(src, Config.Notify.Rack, Config.Notify.Already, "menu_textures", "cross", 3000, "COLOR_RED")
        else
            TriggerClientEvent("rs_weaponsrack:client:placeWeaponRack", src)
        end
    end)
end)

RegisterNetEvent("rs_weaponsrack:giveWeaponRack", function()
    local src = source
    VorpInv.subItem(src, Config.WeaponRackItem, 1)
end)