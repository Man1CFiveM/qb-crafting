local QBCore = exports['qb-core']:GetCoreObject()
--Functions
local function addReward(src, reward, skill)
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.AddRep(skill, reward)
    QBCore.Functions.Notify(src, string.format(Lang:t('notifications.xpGain'), reward, skill), 'success')
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

local function randomLostComponents(src, recipe, item, amount)
    local components = Config.Recipes[recipe][item].components

    local componentKeys = {}
    for component, _ in pairs(components) do
        componentKeys[#componentKeys+1] = component
    end

    local randomComponent = componentKeys[math.random(#componentKeys)]
    local maxAmount = components[randomComponent] * amount
    local randomAmount = math.random(maxAmount)

    exports['qb-inventory']:RemoveItem(src, randomComponent, randomAmount, false, 'qb-crafting:server:removeMaterials')
    TriggerClientEvent('qb-inventory:client:ItemBox', src, QBCore.Shared.Items[randomComponent], 'remove')
end

local function addItem(src, item, amount, recipe, skill)
    local itemRecipe = Config.Recipes[recipe][item]
    for component, count in pairs(itemRecipe.components) do
        exports['qb-inventory']:RemoveItem(src, component, count * amount, false, 'Remove component for crafting - '..item..' - '..component)
        TriggerClientEvent('qb-inventory:client:ItemBox', src, QBCore.Shared.Items[component], 'remove', count * amount)
    end
    exports['qb-inventory']:AddItem(src, item, amount, false, false, 'item crafted - '..item..' - '..amount)
    TriggerClientEvent('qb-inventory:client:ItemBox', src, QBCore.Shared.Items[item], 'add', amount)
    QBCore.Functions.Notify(string.format(src, Lang:t('notifications.craftMessage'), QBCore.Shared.Items[item].label), 'success')
    addReward(src, itemRecipe.reward * amount, skill)
end

-- Callbacks
QBCore.Functions.CreateCallback('qb-crafting:server:getPlayersInventory', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return false end
    local inventory = {}
    for _, item in pairs(Player.PlayerData.items) do
        inventory[item.name] = item.amount
    end
    cb(inventory)
end)

--Events
RegisterNetEvent('qb-crafting:server:item',function(toggle, args)
    local src = source
    if not src or src <= 0 then return print('Error: source not found') end
    if not toggle then
        return randomLostComponents(src, args.recipe, args.item, args.amount)
    end
    if not hasEnoughComponents(src, args.item, args.amount, args.recipe) then
        return print('Error handler, player can not create item', src)
    end
    addItem(src, args.item, args.amount, args.recipe, args.skill)
end)



for _, craft in pairs(Config.Crafting) do
    if craft.useitem then
        QBCore.Functions.CreateUseableItem(craft.useitem.item, function(source)
            local netId = CreateObject:New(source, craft.useitem.model)
            TriggerClientEvent('qb-crafting:client:use_create_item', source, {netid = NetworkGetNetworkIdFromEntity(netId), option = craft})
        end)
    end
end