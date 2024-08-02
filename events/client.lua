local QBCore = exports['qb-core']:GetCoreObject()

local isCraftingActive = false
function PressButtonToOpenCrafting(isActive, recipe, skill, label)
    isCraftingActive = isActive
    CreateThread(function()
        exports['qb-core']:DrawText(label, 'left')
        while isCraftingActive do
            if IsControlJustPressed(0, 38) then
                exports['qb-core']:HideText()
                CraftingMenu:new(recipe, skill):openMenu()
                break
            end
            Wait(1)
        end
    end)
end

RegisterNetEvent('qb-crafting:client:place_crafting_station',function(netId, target)
    local workstation = CraftingStation:new():waitForState(netId)
    if not workstation then return print('qb-crafting:client:place_crafting_station: error waiting for state')end
    if target then
        return Targeting:new(workstation.label, workstation.icon):addEntity(workstation.entity, workstation.recipe, workstation.skill, true)
    end
    ZoneBuilder:new(workstation.recipe, workstation.skill, workstation.label):useableItem(workstation.entity)
end)

local function workStationHandler(workstation)
    if workstation.ped then
        return ZoneBuilder:new(workstation.recipe, workstation.skill, workstation.label):createPed(workstation.location, workstation.length, workstation.width, workstation.ped)
    end
    if workstation.object then
        return ZoneBuilder:new(workstation.recipe, workstation.skill, workstation.label):createObject(workstation.location, workstation.length, workstation.width, workstation.object)
    end
end

if Config.CraftingStations then
    for _, workstation in pairs(Config.CraftingStations) do
        if workstation.model then
            Targeting:new(workstation.label, workstation.icon):addModel(workstation.model, workstation.recipe, workstation.skill)
        end
        if workstation.location then
            workStationHandler(workstation)
        end
        if not workstation.model and not workstation.location then
            ZoneBuilder:new(workstation.recipe, workstation.skill, workstation.label):boxZone(workstation.location, workstation.length, workstation.width)
        end
    end
end


-- CreateThread(function()
--     RequestModel('s_m_m_postal_01')
--     while not HasModelLoaded('s_m_m_postal_01') do Wait(0) end
--     local ped = CreatePed(0, 's_m_m_postal_01', 1065.75, 3065.07, 40.92, 200.0, false, false)
--     FreezeEntityPosition(ped, true)
--     SetEntityInvincible(ped, true)
--     SetBlockingOfNonTemporaryEvents(ped, true)
-- end)


-- AddStateBagChangeHandler("crafting", nil, function(bagName, _, bag)
--     local entity = GetEntityFromStateBagName(bagName)
--     if entity == 0 then return end
--     while not HasCollisionLoadedAroundEntity(entity) do
--         if not DoesEntityExist(entity) then return end
--         Wait(100)
--     end
--     SetEntityInvincible(entity, true)
--     FreezeEntityPosition(entity, true)
--     SetBlockingOfNonTemporaryEvents(entity, true)
--     -- Target:New(entity, nil, bag.icon, bag.label, nil, bag.recipe, bag.skill, false):Entity()
-- end)


-- local exampleZoneBenche = {}
-- CreateThread(function()
--     local model = joaat('prop_tool_bench02')
--     while not HasModelLoaded(model) do
--         RequestModel(model)
--         Wait(100)
--     end
--     exampleZoneBenche[#exampleZoneBenche+1] = CreateObject(model, 1075.75, 3065.07, 39.92, true, false, false)
--     exampleZoneBenche[#exampleZoneBenche+1] = CreateObject(model, 1072.01, 3080.22, 39.83, true, false, false) -- this will not have a polzyone to shocase 
--     exampleZoneBenche[#exampleZoneBenche+1] = CreateObject(model, 1067.55, 3097.19, 39.91, true, false, false)
--     SetModelAsNoLongerNeeded(model)
-- end)

-- for key, value in pairs(exampleZoneBenche) do
--     DeleteEntity(value)
-- end


-- if not safeLocation then
--     print('no safe location found')
-- else
--     print('safe location found')
--     -- safeLocation = getRandomSafeLocation(vector3(-2268.07, 817.73, 213.17), vector3(1910.88, 762.9, 192.08), vector3(1644.76, -2496.73, 79.1), vector3(-1868.7, -3014.71, 13.94))
--     -- local ped = CreatePed(4, "a_m_m_skater_01", safeLocation.x, safeLocation.y, safeLocation.z, 0.0, false, true)
-- end