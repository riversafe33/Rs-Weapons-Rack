local rackProps = {}
local lastPlacedRack = nil
local loadedRacks = {}
local Menu = exports.vorp_menu:GetMenuData()
local spawnDistance = Config.SpawnDistance

function GetWeaponNameFromHash(hash)
    local knownWeapons = {
        [`WEAPON_RIFLE_BOLTACTION`] = "WEAPON_RIFLE_BOLTACTION",
        [`WEAPON_RIFLE_SPRINGFIELD`] = "WEAPON_RIFLE_SPRINGFIELD",
        [`WEAPON_SNIPERRIFLE_CARCANO`] = "WEAPON_SNIPERRIFLE_CARCANO",
        [`WEAPON_SNIPERRIFLE_ROLLINGBLOCK`] = "WEAPON_SNIPERRIFLE_ROLLINGBLOCK",
        [`WEAPON_RIFLE_ELEPHANT`] = "WEAPON_RIFLE_ELEPHANT",
        [`WEAPON_RIFLE_VARMINT`] = "WEAPON_RIFLE_ELEPHANT",
        [`WEAPON_REPEATER_WINCHESTER`] = "WEAPON_REPEATER_WINCHESTER",
        [`WEAPON_REPEATER_HENRY`] = "WEAPON_REPEATER_HENRY",
        [`WEAPON_REPEATER_EVANS`] = "WEAPON_REPEATER_EVANS",
        [`WEAPON_REPEATER_CARBINE`] = "WEAPON_REPEATER_CARBINE",
        [`WEAPON_SHOTGUN_SEMIAUTO`] = "WEAPON_SHOTGUN_SEMIAUTO",
        [`WEAPON_SHOTGUN_REPEATING`] = "WEAPON_SHOTGUN_REPEATING",
        [`WEAPON_SHOTGUN_PUMP`] = "WEAPON_SHOTGUN_PUMP",
        [`WEAPON_SHOTGUN_DOUBLEBARREL`] = "WEAPON_SHOTGUN_DOUBLEBARREL",
    }
    return knownWeapons[hash] or "UNKNOWN_WEAPON"
end

function InitializeRackSlots(rackId)
    rackProps[rackId] = rackProps[rackId] or {}
    rackProps[rackId].slots = {}
    for i = 1, 12 do
        rackProps[rackId].slots[i] = true
    end
end

RegisterNetEvent('rs_weaponsrack:client:receiveRacks')
AddEventHandler('rs_weaponsrack:client:receiveRacks', function(racks)
    if racks then
        for _, data in pairs(racks) do
            loadedRacks[data.id] = data
        end
    end
end)

Citizen.CreateThread(function()
    TriggerServerEvent('rs_weaponsrack:server:requestRacks')
end)

local requestedRackItems = {}

CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for rackId, data in pairs(loadedRacks) do
            local pos = vector3(data.x, data.y, data.z)
            local dist = #(playerCoords - pos)

            if dist < spawnDistance and not rackProps[rackId] then
                local modelHash = GetHashKey('p_riflerack01x')
                RequestModel(modelHash)
                while not HasModelLoaded(modelHash) do Wait(10) end

                local object = CreateObject(modelHash, data.x, data.y, data.z, false, false, false)
                local heading = tonumber((data.rotation and data.rotation.z) or data.heading or 0.0) % 360.0
                SetEntityHeading(object, heading)
                PlaceObjectOnGroundProperly(object)
                FreezeEntityPosition(object, true)
                SetEntityAsMissionEntity(object, true)

                rackProps[rackId] = { object }
                InitializeRackSlots(rackId)

                if not requestedRackItems[rackId] then
                    requestedRackItems[rackId] = true
                    TriggerServerEvent("rs_weaponsrack:Server:RequestRackItems", rackId, false)
                end
            end

            if dist > spawnDistance and rackProps[rackId] then
                local prop = rackProps[rackId][1]
                if prop and DoesEntityExist(prop) then DeleteEntity(prop) end
                rackProps[rackId] = nil

                requestedRackItems[rackId] = nil
            end
        end

        Wait(1000)
    end
end)

RegisterNetEvent('rs_weaponsrack:client:removeRack')
AddEventHandler('rs_weaponsrack:client:removeRack', function(rackId)
    local rackData = rackProps[rackId]
    if rackData then

        for _, entity in ipairs(rackData) do
            if DoesEntityExist(entity) then
                DetachEntity(entity, true, true)
                DeleteEntity(entity)
            end
        end
        rackProps[rackId] = nil
        loadedRacks[rackId] = nil
    end
end)

function OpenRackMenu(rackId, weapons, permisos)
    Menu.CloseAll()

    local MenuElements = {
        { label = Config.Notify.Menu.Weapons, value = "weapons" },
        { label = Config.Notify.Menu.GivePerm, value = "give_permission" },
        { label = Config.Notify.Menu.DelpPerm, value = "remove_permission" }
    }

    Menu.Open("default", GetCurrentResourceName(), "rack_menu_" .. rackId, {
        title = Config.Notify.Menu.Rack,
        subtext = Config.Notify.Menu.Select,
        align = "top-right",
        elements = MenuElements
    },
    function(data, menu)
        if data.current.value == "weapons" then
            local weaponElements = {}
            for slot, weapon in ipairs(weapons) do
                if type(weapon) == "table" and weapon.name and weapon.weaponId then
                    table.insert(weaponElements, {
                        label = Config.WeaponLabels[weapon.name] or weapon.name,
                        value = weapon.weaponId,
                        desc = Config.Notify.Menu.Remove .. slot
                    })
                end
            end

            if #weaponElements == 0 then
                table.insert(weaponElements, { label = Config.Notify.Menu.Empty, value = "none" })
            end

            Menu.Open("default", GetCurrentResourceName(), "wapon_menu_" .. rackId, {
                title = Config.Notify.Menu.RackwWea,
                subtext = Config.Notify.Menu.SelectWea,
                align = "top-right",
                elements = weaponElements
            },
            function(data2, menu2)
                if data2.current.value ~= "none" then
                    TriggerServerEvent("rs_weaponsrack:Server:TakeWeapon", rackId, data2.current.value)
                end
                menu2.close()
            end,
            function(data2, menu2) menu2.close() end)

        elseif data.current.value == "give_permission" then
            local myInput = {
                type = "enableinput",
                inputType = "input",
                button = Config.Notify.Input.Confirm,
                placeholder = Config.Notify.Input.Ej,
                style = "block",
                attributes = {
                    inputHeader = Config.Notify.Input.PlayerId,
                    type = "text",
                    pattern = "[0-9]+",
                    title = Config.Notify.Input.ValID,
                    style = "border-radius: 10px; background-color: ; border:none;"
                }
            }

            local result = exports.vorp_inputs:advancedInput(myInput)
            if result and result ~= "" then
                local targetCharId = tonumber(result)
                if targetCharId then
                    TriggerServerEvent("rs_weaponsrack:Server:GrantPermission", rackId, targetCharId)
                end
            end

        elseif data.current.value == "remove_permission" then
            local permElements = {}
            permisos = permisos or {}
            for _, p in ipairs(permisos) do
                local name = p.name or ("Jugador "..p.charid)
                table.insert(permElements, { label = name, value = p.charid })
            end
            if #permElements == 0 then
                table.insert(permElements, { label = Config.Notify.Menu.NoPerms, value = "none" })
            end

            Menu.Open("default", GetCurrentResourceName(), "rack_permissions_menu", {
                title = Config.Notify.Menu.DelPerms,
                subtext = Config.Notify.Menu.SelectPlayer,
                align = "top-right",
                elements = permElements
            },
            function(data3, menu3)
                if data3.current.value ~= "none" then
                    local confirmInput = {
                        type = "enableinput",
                        inputType = "input",
                        button =  Config.Notify.Input.Confirm,
                        placeholder = Config.Notify.Input.YesConfirm,
                        style = "block",
                        attributes = {
                            inputHeader = Config.Notify.Input.ConfirmDel,
                            type = "text",
                            pattern = "^".. Config.Notify.Input.Pattern .."$",
                            title = Config.Notify.Input.YesNo,
                            style = "border-radius: 10px; background-color: ; border:none;"
                        }
                    }
                    local confirm = exports.vorp_inputs:advancedInput(confirmInput)
                    if confirm and (confirm:lower() == Config.Notify.Input.Yes) then
                        local targetPlayer = nil
                        for _, p in ipairs(permisos) do
                            if p.charid == data3.current.value then
                                targetPlayer = p
                                break
                            end
                        end
                        if targetPlayer then
                            TriggerServerEvent("rs_weaponsrack:Server:RevokePermission", rackId, targetPlayer.identifier, targetPlayer.charid)
                        end
                    end
                end
                menu3.close()
            end,
            function(data3, menu3) menu3.close() end)
        end
        menu.close()
    end,
    function(data, menu)
        menu.close()
    end)
end

RegisterNetEvent("rs_weaponsrack:Client:ReceiveRackItems")
AddEventHandler("rs_weaponsrack:Client:ReceiveRackItems", function(rackId, weapons, openMenu, permisos)
    if not rackProps[rackId] then return end

    local rackBase = rackProps[rackId][1]

    for i = 2, #rackProps[rackId] do
        if DoesEntityExist(rackProps[rackId][i]) then
            DetachEntity(rackProps[rackId][i], true, true)
            DeleteEntity(rackProps[rackId][i])
        end
    end
    rackProps[rackId] = {rackBase}

    local weaponModelsMap = {
        ["WEAPON_RIFLE_SPRINGFIELD"] = "w_dis_rif_springfield01",
        ["WEAPON_RIFLE_BOLTACTION"]  = "w_dis_rif_boltaction01",
        ["WEAPON_SNIPERRIFLE_CARCANO"]  = "w_dis_rif_carcano01",
        ["WEAPON_SNIPERRIFLE_ROLLINGBLOCK"]  = "w_dis_rif_rollingblock01",
        ["WEAPON_RIFLE_ELEPHANT"]  = "w_dis_rif_elephant01",
        ["WEAPON_REPEATER_WINCHESTER"]  = "w_dis_rep_winchester01",
        ["WEAPON_REPEATER_HENRY"]  = "w_dis_rep_henry01",
        ["WEAPON_REPEATER_EVANS"]  = "w_dis_rep_carbine01_1",
        ["WEAPON_REPEATER_CARBINE"]  = "w_dis_rep_carbine01_1",
        ["WEAPON_SHOTGUN_SEMIAUTO"]  = "w_dis_sho_semiauto01",
        ["WEAPON_SHOTGUN_REPEATING"]  = "w_dis_sho_repeating01",
        ["WEAPON_SHOTGUN_PUMP"]  = "w_dis_sho_pumpaction01",
        ["WEAPON_SHOTGUN_DOUBLEBARREL"]  = "w_dis_sho_doublebarrel01",
    }

    for slot, weapon in ipairs(weapons) do
        if type(weapon) == "table" and weapon.name then
            local weaponData
            local useSecondRack = slot > 6

            if useSecondRack then
                for _, group in pairs(Config.WeaponsSecondRack) do
                    if group[weapon.name] then
                        weaponData = group[weapon.name]
                        break
                    end
                end
            else
                for _, group in pairs(Config.WeaponsAllowedInRack) do
                    if group[weapon.name] then
                        weaponData = group[weapon.name]
                        break
                    end
                end
            end

            if weaponData then
                local modelName = weaponModelsMap[weapon.name]
                if modelName then
                    local modelHash = GetHashKey(modelName)
                    RequestModel(modelHash)
                    while not HasModelLoaded(modelHash) do Wait(10) end

                    local prop = CreateObject(modelHash, 0, 0, 0, false, false, false)
                    local spacingIndex = useSecondRack and (slot-7) or (slot-1)
                    local spacing = spacingIndex * 0.1

                    local finalX = weaponData.offset.x or 0
                    if useSecondRack then
                        finalX = -(finalX + spacing)
                    else
                        finalX = finalX + spacing
                    end

                    AttachEntityToEntity(
                        prop, rackBase, 0,
                        finalX,
                        weaponData.offset.y or 0,
                        weaponData.offset.z or 0,
                        weaponData.rotation.x or 0,
                        weaponData.rotation.y or 0,
                        weaponData.rotation.z or 0,
                        false, false, true, false, 0, true
                    )
                    FreezeEntityPosition(prop, true)
                    table.insert(rackProps[rackId], prop)
                end
            end
        end
    end

    if openMenu then
        OpenRackMenu(rackId, weapons, permisos)
    end
end)

RegisterNetEvent('rs_weaponsrack:client:placeWeaponRack')
AddEventHandler('rs_weaponsrack:client:placeWeaponRack', function()
    local rackModel = GetHashKey('p_riflerack01x')
    RequestModel(rackModel)
    while not HasModelLoaded(rackModel) do Wait(10) end

    local playerPed = PlayerPedId()
    local px, py, pz = table.unpack(GetEntityCoords(playerPed))
    local ox, oy, oz = table.unpack(GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 2.0, 0.0))

    local groundSuccess, groundZ = GetGroundZFor_3dCoord(ox, oy, pz, false)
    if groundSuccess then pz = groundZ end

    local tempObject = CreateObject(rackModel, ox, oy, pz, true, false, false)
    PlaceObjectOnGroundProperly(tempObject)
    FreezeEntityPosition(tempObject,true)
    SetEntityCollision(tempObject,false,false)
    SetEntityAlpha(tempObject,150,false)

    SendNUIMessage({ 
        action = "shownuirack",
        controls = Config.ControlTranslations
    })

    local posX,posY,posZ = table.unpack(GetEntityCoords(tempObject))
    local heading = GetEntityHeading(tempObject)

    lastPlacedRack = {entity=tempObject, coords=vector3(posX,posY,posZ), heading=heading}
    local isPlacing = true
    local moveStep = 0.05

    CreateThread(function()
        while isPlacing do
            Wait(0)

            for _, keyCode in pairs(Config.Keys) do
                DisableControlAction(0, keyCode, true)
            end

            if IsDisabledControlJustPressed(0, Config.Keys.moveForward) then posY = posY + moveStep end
            if IsDisabledControlJustPressed(0, Config.Keys.moveBackward) then posY = posY - moveStep end
            if IsDisabledControlJustPressed(0, Config.Keys.moveLeft) then posX = posX - moveStep end
            if IsDisabledControlJustPressed(0, Config.Keys.moveRight) then posX = posX + moveStep end
            if IsDisabledControlJustPressed(0, Config.Keys.moveUp) then posZ = posZ + moveStep end
            if IsDisabledControlJustPressed(0, Config.Keys.moveDown) then posZ = posZ - moveStep end
            if IsDisabledControlJustPressed(0, Config.Keys.rotateLeftZ) then heading = heading + 5 end
            if IsDisabledControlJustPressed(0, Config.Keys.rotateRightZ) then heading = heading - 5 end

            if IsDisabledControlJustPressed(0, Config.Keys.speedPlace) then
                local myInput = {
                    type = "enableinput",
                    inputType = "input",
                    button = Config.Notify.Input.Confirm,
                    placeholder = Config.Notify.Input.MinMax,
                    style = "block",
                    attributes = {
                        inputHeader = Config.Notify.Input.Speed,
                        type = "text",
                        pattern = "[0-9.]+",
                        title = Config.Notify.Input.Change,
                        style = "border-radius: 10px; background-color: ; border:none;"
                    }
                }
                local result = exports.vorp_inputs:advancedInput(myInput)
                if result and result ~= "" then
                    local speedVal = tonumber(result)
                    if speedVal and speedVal ~= 0 then
                        moveStep = math.max(0.01, math.min(speedVal, 5))
                    end
                end
            end

            SetEntityCoords(tempObject,posX,posY,posZ,true,true,true,false)
            SetEntityHeading(tempObject,heading)

            if IsDisabledControlJustPressed(0, Config.Keys.confirmPlace) then
                isPlacing = false
                SendNUIMessage({ action = "hidenuirack" })
                local finalPos = GetEntityCoords(tempObject)
                local finalHeading = GetEntityHeading(tempObject)
                DeleteObject(tempObject)
                lastPlacedRack = nil
                TriggerServerEvent('rs_weaponsrack:server:saveOwner', finalPos.x, finalPos.y, finalPos.z, finalHeading)
                TriggerServerEvent("rs_weaponsrack:giveWeaponRack")
                TriggerEvent("vorp:NotifyLeft", Config.Notify.Rack, Config.Notify.Place, "generic_textures", "tick", 2000, "COLOR_GREEN")
            end

            if IsDisabledControlJustPressed(0, Config.Keys.cancelPlace) then
                isPlacing = false
                SendNUIMessage({ action = "hidenuirack" })
                if DoesEntityExist(tempObject) then DeleteObject(tempObject) end
                lastPlacedRack = nil
                TriggerEvent("vorp:NotifyLeft", Config.Notify.Rack, Config.Notify.Cancel, "menu_textures", "cross", 2000, "COLOR_RED")
            end
        end
    end)
end)

RegisterNetEvent("rs_weaponsrack:Client:RequestCurrentWeapon")
AddEventHandler("rs_weaponsrack:Client:RequestCurrentWeapon", function(rackId)
    local playerPed = PlayerPedId()
    local _, weaponHash = GetCurrentPedWeapon(playerPed, true)
    if weaponHash == `WEAPON_UNARMED` then
        TriggerServerEvent("rs_weaponsrack:Server:ReceiveCurrentWeapon", rackId, nil)
        return
    end

    local key = string.format("GetEquippedWeaponData_%d", weaponHash)
    local weaponData = LocalPlayer.state[key]

    local weaponName = weaponData and (weaponData.name or weaponData.weaponName) or GetWeaponNameFromHash(weaponHash)
    local weaponId = weaponData and weaponData.weaponId or weaponHash
    local serial = weaponData and weaponData.serialNumber or "unknown"

    TriggerServerEvent("rs_weaponsrack:Server:ReceiveCurrentWeapon", rackId, {
        weaponId = weaponId,
        name = weaponName,
        serial = serial
    })
end)

local rackPromptGroup = UipromptGroup:new("Weapons Rack")

local openMenuPrompt = Uiprompt:new(`INPUT_DYNAMIC_SCENARIO`, Config.Notify.Promp.Open, rackPromptGroup)
openMenuPrompt:setHoldMode(true)

local storeWeaponPrompt = Uiprompt:new(`INPUT_RELOAD`, Config.Notify.Promp.PutAway, rackPromptGroup)
storeWeaponPrompt:setHoldMode(true)

local pickUpRackPrompt = Uiprompt:new(`INPUT_OPEN_SATCHEL_MENU`, Config.Notify.Promp.Pickup, rackPromptGroup)
pickUpRackPrompt:setHoldMode(true)

rackPromptGroup:setOnHoldModeJustCompleted(function(group, prompt)
    local playerPed = PlayerPedId()
    if not DoesEntityExist(playerPed) then return end

    local playerCoords = GetEntityCoords(playerPed)

    -- Recorremos racks dinámicos cargados
    for rackId, rack in pairs(loadedRacks) do
        local rackPos = vector3(rack.x, rack.y, rack.z)
        if #(playerCoords - rackPos) < 1.5 then
            if prompt == openMenuPrompt then
                TriggerServerEvent("rs_weaponsrack:Server:TryOpenRack", rackId)
            elseif prompt == storeWeaponPrompt then
                TriggerServerEvent("rs_weaponsrack:Server:TryStoreWeapon", rackId)
            elseif prompt == pickUpRackPrompt then
                TriggerServerEvent("rs_weaponsrack:server:pickUpByOwner", rackId)
            end
            break
        end
    end
end)

UipromptManager:startEventThread()

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)

        local playerPed = PlayerPedId()
        if not DoesEntityExist(playerPed) then goto continue end

        local playerCoords = GetEntityCoords(playerPed)
        local isNearRack = false

        for _, rack in pairs(loadedRacks) do
            local rackPos = vector3(rack.x, rack.y, rack.z)
            if #(playerCoords - rackPos) < 1.5 then
                isNearRack = true
                break
            end
        end

        rackPromptGroup:setActive(isNearRack)

        ::continue::
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end

    for rackId, rackData in pairs(rackProps) do
        if rackData then
            for _, entity in ipairs(rackData) do
                if DoesEntityExist(entity) then
                    DetachEntity(entity, true, true)
                    DeleteEntity(entity)
                end
            end
        end
        rackProps[rackId] = nil
    end

    if rackWeapons then
        for rackId, weapons in pairs(rackWeapons) do
            for _, weaponEntity in pairs(weapons) do
                if DoesEntityExist(weaponEntity) then
                    DeleteEntity(weaponEntity)
                end
            end
        end
        rackWeapons = {}
    end

    loadedRacks = {}
    requestedRackItems = {}
end)