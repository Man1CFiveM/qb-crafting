local QBCore = exports['qb-core']:GetCoreObject()

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
            Zone:New(nil, craft.object.location, nil, craft.recipe, nil, craft.skill):Combo()
        end
    end
end

AddStateBagChangeHandler("crafting", nil, function(bagName, _, bag)
    local entity = GetEntityFromStateBagName(bagName)
    if entity == 0 then return end
    while not HasCollisionLoadedAroundEntity(entity) do
        if not DoesEntityExist(entity) then return end
        Wait(100)
    end
    SetEntityInvincible(entity, true)
    FreezeEntityPosition(entity, true)
    TaskSetBlockingOfNonTemporaryEvents(entity, true)
    Target:New(entity, nil, bag.icon, bag.label, nil, bag.recipe, bag.skill):Entity()
end)



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




local testprop = {}

CreateThread(function()
    local prop = 'prop_toolchest_01'
    RequestModel(prop)
    while not HasModelLoaded(prop) do
        Wait(0)
    end
    testprop[#testprop+1] = CreateObject(joaat(prop), 1101.73, 3074.53, 39.49, true, true, true)
end)

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

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        for key, value in pairs(testprop) do
            DeleteEntity(value)
        end
    end
end)