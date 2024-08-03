local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('qb-crafting:server:getPlayersInventory', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return false end
    local inventory = {}
    for _, item in pairs(Player.PlayerData.items) do
        inventory[item.name] = item.amount
    end
    cb(inventory)
end)

RegisterNetEvent('qb-crafting:server:item',function(success, options)
    local src = source
    if not src or src <= 0 then return print('Error: source not found') end
    local item = ItemCrafting:New(src, options.item, options.amount, options.recipe, options.skill)
    if not success then
        return item:loseRandomComponents()
    end
    item:itemToCraft()
end)

RegisterNetEvent('qb-crafting:server:pickup_station', function(netId)
    local src = source
    if not src or src <= 0 then return print('Error: source not found') end
    local entity = NetworkGetEntityFromNetworkId(netId)
    if not DoesEntityExist(entity) then return print('Error: entity not found') end
    CraftingStation:pickup(entity)
end)

local function usableItem(useitem)
    QBCore.Functions.CreateUseableItem(useitem.item, function(source)
        local recipe,skill,model,label,icon,item,target,src = useitem.recipe,useitem.skill,useitem.model,useitem.label,useitem.icon,useitem.item, useitem.target or false, source
        local craftingStation = CraftingStation:new(src, model, item, recipe, skill, label, icon):place()
        TriggerClientEvent('qb-crafting:client:place_crafting_station', src, NetworkGetNetworkIdFromEntity(craftingStation), target)
        exports['qb-inventory']:RemoveItem(src, item, 1, false, 'place item bench for crafing')
        TriggerClientEvent('qb-inventory:client:ItemBox', src, QBCore.Shared.Items[item], 'remove')
    end)
end

if Config.Useitem then
    for _, useitem in pairs(Config.Useitem) do
        usableItem(useitem)
    end
end