local QBCore = exports['qb-core']:GetCoreObject()
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
RegisterNetEvent('qb-crafting:server:item',function(toggle, options)
    local src = source
    if not src or src <= 0 then return print('Error: source not found') end
    local item = Item:New(src, options.item, options.amount, options.recipe, options.skill)
    if not toggle then
        return item:RandomLostComponents()
    end
    item:Add()
end)

RegisterNetEvent('qb-crafting:server:pickup_bench', function(netId)
    local src = source
    if not src or src <= 0 then return print('Error: source not found') end
    local entity = NetworkGetEntityFromNetworkId(netId)
    if not DoesEntityExist(entity) then return print('Error: entity not found') end
    CraftObject:New(src):Pickup(entity)
end)

for _, craft in pairs(Config.Crafting) do
    if craft.useitem then
        QBCore.Functions.CreateUseableItem(craft.useitem.item, function(source)
            local workbench = CraftObject:New(source, craft.useitem.model):Create()
            print("workbench : ",workbench)
            TriggerClientEvent('qb-crafting:client:use_create_item', source, {netid = NetworkGetNetworkIdFromEntity(workbench), option = craft})
        end)
    end
end