local QBCore = exports['qb-core']:GetCoreObject()
Targeting = {}
Targeting.new = function(self, label, icon)
    self.label = label
    self.icon = icon
    self.distance = Config.Settings.TargetDistance
    return self
end

Targeting.setPedAttributes = function(self, stationPed, ped)
    SetEntityInvincible(stationPed, true)
    SetBlockingOfNonTemporaryEvents(stationPed, true)
    FreezeEntityPosition(stationPed, true)
    SetEntityAsMissionEntity(stationPed, true, true)
    SetModelAsNoLongerNeeded(ped)
end

Targeting.createPed = function(self, model, recipe, skill, location)
    QBCore.Functions.LoadModel(model)
    if type(location) == 'table' then
        for _, loc in ipairs(location) do
            local ped = CreatePed(0, model, loc.x, loc.y, loc.z, loc.h, false, false)
            self:addEntity(ped, recipe, skill, false)
            self:setPedAttributes(ped, model)
        end
    end
    local ped = CreatePed(0, model, location.x, location.y, location.z, location.h, false, false)
    self:addEntity(model, recipe, skill, false)
    self:setPedAttributes(ped, model)
end

Targeting.addEntity = function(self, entity, recipe, skill, pickup)
    self.entity = entity
    local options = {
        {
            num = 1,
            icon = self.icon,
            label = self.label,
            action = function()
                CraftingMenu:new(recipe, skill):openMenu()
            end,
        },
    }

    if pickup then
        table.insert(options, self:enablePickup())
    end

    exports['qb-target']:AddTargetEntity(self.entity, {
        options = options,
        distance = Config.Settings.TargetDistance,
    })
end

Targeting.enablePickup = function(self)
    return {
        num = 2,
        icon = 'fa-solid fa-trash',
        label = string.format(Lang:t('target.pickupStation')),
        action = function(entity)
            QBCore.Functions.PlayAnim("pickup_object", "pickup_low", false, 2.0)
            self:remove()
            TriggerServerEvent('qb-crafting:server:pickup_bench', NetworkGetNetworkIdFromEntity(entity))
        end,
    }
end

Targeting.addModel = function(self, model, recipe, skill)
    exports['qb-target']:AddTargetModel(joaat(model), {
        options = {
                {
                    icon = self.icon,
                    label = self.label,
                    action = function()
                        CraftingMenu:new():useTargetModel(model, recipe, skill)
                    end,
                },
            },
            distance = Config.Settings.TargetDistance,
        })
end

Targeting.remove = function(self)
    exports['qb-target']:RemoveTargetEntity(self.entity)
end