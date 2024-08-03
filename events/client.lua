local isCraftingActive = false
function PressButtonToOpenCrafting(isActive, recipe, skill, label)
    isCraftingActive = isActive
    CreateThread(function()
        exports['qb-core']:DrawText(label, 'left')
        while isCraftingActive do
            if IsControlJustPressed(0, 38) then
                exports['qb-core']:HideText()
                CraftingMenu:new(recipe, skill, label):openMenu()
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
    local newZone = ZoneBuilder:new(workstation.recipe, workstation.skill, workstation.label)
    if workstation.ped then
        return newZone:combo(workstation.location, workstation.length, workstation.width, workstation.ped, true)
    end
    if workstation.object then
        return newZone:combo(workstation.location, workstation.length, workstation.width, workstation.object, false)
    end
    newZone:boxZone(workstation.location, workstation.length, workstation.width)
end

if Config.CraftingStations then
    for _, workstation in pairs(Config.CraftingStations) do
        if workstation.model then
            Targeting:new(workstation.label, workstation.icon):addModel(workstation.model, workstation.recipe, workstation.skill)
        end
        if workstation.location then
            workStationHandler(workstation)
        end
    end
end