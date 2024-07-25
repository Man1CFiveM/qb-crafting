local QBCore = exports['qb-core']:GetCoreObject()
--Functions

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
    Item:Add(src, args.item, args.amount, args.recipe, args.skill)
end)

for _, craft in pairs(Config.Crafting) do
    if craft.useitem then
        QBCore.Functions.CreateUseableItem(craft.useitem.item, function(source)
            local netId = CreateObject:New(source, craft.useitem.model)
            TriggerClientEvent('qb-crafting:client:use_create_item', source, {netid = NetworkGetNetworkIdFromEntity(netId), option = craft})
        end)
    end
end