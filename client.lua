local QBCore = exports['qb-core']:GetCoreObject()

CreateThread(function()
    local prop = 'prop_toolchest_01'
    RequestModel(prop)
    while not HasModelLoaded(prop) do
        Wait(0)
    end
    CreateObject(joaat(prop), 1101.73, 3074.53, 39.49, true, true, true)
end)

local isCraftingActive = false
function PressButtonToOpenCrafting(isActive, recipe, item, skill)
    isCraftingActive = isActive
    CreateThread(function()
        exports['qb-core']:DrawText('Press E to use Crafting', 'left')
        while isCraftingActive do
            if IsControlJustPressed(0, 38) then
                exports['qb-core']:HideText()
                Menu:New(recipe, item, skill):OpenMenu()
                break
            end
            Wait(1)
        end
    end)
end

RegisterNetEvent('qb-crafting:client:use_create_item',function(option)
    local time = GetGameTimer()
    while not NetworkDoesEntityExistWithNetworkId(option.netid) do
        if GetGameTimer() - time > 1000 then
            return print('Error handler - NetiD: ',option.netid)
        end
        Wait(1)
    end
    if option.useitem.target then
        return Target:New(option.netid, option.useitem.model, option.useitem.icon, option.useitem.label, option.useitem.item, option.recipe, option.skill):Entity()
    end
    local entity = NetToEnt(option.netid)
    local coords = GetEntityCoords(entity)
    local heading = GetEntityHeading(entity)
    Zone:New(vector4(coords.x, coords.y, coords.z, heading), nil, option.useitem.model, option.recipe, option.useitem.item, option.skill):UseableItem()
end)

AddEventHandler('qb-menu:client:menuClosed', function()
    if Menu:Get() then
        PressButtonToOpenCrafting(true, Zone:Get())
    end
end)

for _, craft in pairs(Config.Crafting) do
    if craft.object then
        if craft.object.model then
            Target:New(nil, craft.object.model, craft.object.icon, craft.object.label, nil, craft.recipe, craft.skill):Model()
        end
        if craft.object.location then
            QBCore.Debug(craft)
            Zone:New(nil, craft.object.location, nil, craft.recipe, nil, craft.skill):Combo()
        end
    end
end





-- local function setupUsingCraftingTable(option)
--     if not Config.Settings.target then
--         return Zone:Create(option)
--     end
--     setupTarget(option.model, 'model')
-- end

-- if not Config.Settings.UseItem then
--     for key, option in ipairs(Config.Benches) do
--         setupUsingCraftingTable(option)
--     end
-- end

-- for _, crafting in pairs(Config.Benches) do
--     if crafting.useitem then
--         print('useitem')
--         -- createUseableTables(option)
--     end
-- end

CreateThread(function()
    local model = 'prop_toolchest_03_l2'
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end
    CreateObject(joaat(model), 1091.72, 3072.62, 39.48, true, true, true)
    CreateObject(joaat(model), 1085.39, 3071.17, 39.53, true, true, true)
    CreateObject(joaat(model), 1077.57, 3068.95, 39.79, true, true, true)
end)


local function PickupBench(benchType)
    local playerPed = PlayerPedId()
    local propHash = Config[benchType].object
    local entity = GetClosestObjectOfType(GetEntityCoords(playerPed), 3.0, propHash, false, false, false)
    if DoesEntityExist(entity) then
        DeleteEntity(entity)
        TriggerServerEvent('qb-crafting:server:addCraftingTable', benchType)
        QBCore.Functions.Notify(string.format(Lang:t('notifications.pickupBench')), 'success')
    end
end