local QBCore = exports['qb-core']:GetCoreObject()
--Functions
local function addReward(src, reward, skill)
    local Player = QBCore.Functions.GetPlayer(src)
    local currentXP = Player.Functions.GetRep(skill)
    local newXP = currentXP + reward
    Player.Functions.AddRep(skill, newXP)
    QBCore.Functions.Notify(string.format(Lang:t('notifications.xpGain'),source, reward, skill), 'success')
end

local function createUseableTable(benchType, vector4, src)
    local workbench = CreateObjectNoOffset(joaat(benchType), vector4.x, vector4.y, vector4.z-1, true, true, false)
    SetEntityHeading(workbench, vector4.w)
    TriggerClientEvent('qb-crafting:client:useCraftingBench', src, benchType, NetworkGetNetworkIdFromEntity(workbench))
end

local function getDistanceInFront(location, distance)
    local radian = math.rad(location.w + 180)
    local newLocation = {
        x = location.x + math.sin(radian) * distance,
        y = location.y - math.cos(radian) * distance,
        z = location.z,
        w = location.w
    }
    return vector(newLocation.x, newLocation.y, newLocation.z, newLocation.w)
end

local function createUseableTables(option)
    QBCore.Functions.CreateUseableItem(option.item, function(source)
        local ped = GetPlayerPed(source)
        local playerCoords = GetEntityCoords(ped)
        local vector4 = vector4(playerCoords.x, playerCoords.y, playerCoords.z, GetEntityHeading(ped))
        local fowardVector = getDistanceInFront(vector4, 2)
        createUseableTable(option.model, fowardVector, source)
    end)
end

for _, option in pairs(Config.Benches) do
    if Config.Settings.UseItem then
        createUseableTables(option)
    end
end

local function hasEnoughComponents(src, item, amount, recipe)
    local Player = QBCore.Functions.GetPlayer(src)
    local inventory = {}
    for _, _item in ipairs(Player.PlayerData.items) do
        inventory[_item.name] = _item.amount
    end
    local components = Config.Recipes[recipe][item].components
    for component, requiredAmount in pairs(components) do
        if not inventory[component] or inventory[component] < requiredAmount * amount then
            return false
        end
    end
    return true
end

local function lostComponent(src, item, amount)
    exports['qb-inventory']:RemoveItem(src, item, amount, false, 'qb-crafting:server:removeMaterials')
    TriggerClientEvent('qb-inventory:client:ItemBox', src, QBCore.Shared.Items[item], 'remove')
end

local function addItem(src, item, amount, recipe, reward, skill)
    for component, count in pairs(Config.Recipes[recipe][item].components) do
        exports['qb-inventory']:RemoveItem(src, component, count, false, 'failed crafting - '..item..' - '..component)
        TriggerClientEvent('qb-inventory:client:ItemBox', src, QBCore.Shared.Items[component], 'remove')
    end
    exports['qb-inventory']:AddItem(src, item, amount, false, false, 'item crafted - '..item..' - '..amount)
    QBCore.Functions.Notify(string.format(src, Lang:t('notifications.craftMessage'), QBCore.Shared.Items[item].label), 'success')
    addReward(src, reward, skill)
end

-- Callbacks
QBCore.Functions.CreateCallback('qb-crafting:server:getPlayersInventory', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return false end
    local inventory = {}
    for _, item in ipairs(Player.PlayerData.items) do
        inventory[item.name] = item.amount
    end
    cb(inventory)
end)

--Events
RegisterNetEvent('qb-crafting:server:item',function(toggle, args)
    local src = source
    if not src or src <= 0 then return print('Error: source not found') end
    if not toggle then
        return lostComponent(src, args.component, args.amount)
    end
    if not hasEnoughComponents(src, args.item, args.amount, args.recipe) then
        return print('Error handler, player can not create item', src, args.item, args.amount)
    end
    addItem(src, args.item, args.amount, args.recipe, args.reward, args.skill)
end)