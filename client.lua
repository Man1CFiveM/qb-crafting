local QBCore = exports['qb-core']:GetCoreObject()

local function setupTarget(target, targetType)
    local addFunction = targetType == 'entity' and exports['qb-target'].AddTargetEntity or exports['qb-target'].AddTargetModel
    addFunction(target, {
        options = {
            {
                icon = 'fas fa-tools',
                label = string.format(Lang:t('menus.header')),
                action = function()
                    --still need to apply the options for the menu
                    Crafting:Open()
                end
            }
        },
        distance = 2.5
    })
end

local isCraftingActive = false
function PressButtonToOpenCrafting(isActive, option)
    isCraftingActive = isActive
    CreateThread(function()
        exports['qb-core']:DrawText('Press E to use Crafting', 'left')
        while isCraftingActive do
            if IsControlJustPressed(0, 38) then
                exports['qb-core']:HideText()
                Crafting:Open(option)
                break
            end
            Wait(1)
        end
    end)
end

RegisterNetEvent('qb-crafting:client:useCraftingBench',function(workbench)
    local time = GetGameTimer()
    while not NetworkDoesEntityExistWithNetworkId(workbench) do
        if GetGameTimer() - time > 1000 then
            return print('Error handler - NetiD: ',workbench)
        end
        Wait(1)
    end
    setupTarget(NetToObj(workbench), 'entity')
end)

AddEventHandler('qb-menu:client:menuClosed', function()
    PressButtonToOpenCrafting(true, Zone:Get())
end)

local function setupUsingCraftingTable(option)
    if not Config.Settings.target then
        return Zone:Create(option)
    end
    setupTarget(option.model, 'model')
end

if not Config.Settings.UseItem then
    for key, option in ipairs(Config.Benches) do
        setupUsingCraftingTable(option)
    end
end



















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