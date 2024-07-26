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
    Workbench:New(src):Pickup(entity)
end)

local function createUsableItem(craft)
    QBCore.Functions.CreateUseableItem(craft.useitem.item, function(source)
        local workbench = Workbench:New(source, craft.useitem.model, craft.useitem.item, craft.recipe, craft.skill):Create()
        craft.netid = NetworkGetNetworkIdFromEntity(workbench)
        TriggerClientEvent('qb-crafting:client:use_create_item', source, craft)
    end)
end

for _, craft in pairs(Config.Crafting) do
    if craft.useitem then
        createUsableItem(craft)
    end
    if craft.ped then
        QBCore.Debug(craft)
        Ped:New(craft.ped.model, craft.ped.location, craft.skill, craft.recipe, craft.ped.label, craft.ped.icon, craft.ped.target or false):Spawn()
    end
end