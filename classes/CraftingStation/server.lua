local QBCore = exports['qb-core']:GetCoreObject()

local existingStation = {}
CraftingStation = {}
CraftingStation.new = function(self, src, model, item, recipe, skill, label, icon)
    self.source = src
    self.model = model
    self.item = item
    self.recipe = recipe
    self.skill = skill
    self.label = label
    self.icon = icon
    self.distance = Config.Settings.Distance
    return self
end

CraftingStation.place = function(self)
    self:getForwardVector()
    self:checkExistingPlacement()
    local craftingStation = CreateObjectNoOffset(joaat(self.model), self.x, self.y, self.z-1, true, true, false)
    SetEntityHeading(craftingStation, self.w)
    existingStation[self.source] = craftingStation
    self:setItemState(craftingStation)
    return craftingStation
end

CraftingStation.setItemState = function(self, craftingStation)
    local craftingStationState = Entity(craftingStation).state
    craftingStationState:set('craftingStation', {
        item = self.item,
        recipe = self.recipe,
        skill = self.skill,
        model = self.model,
        label = self.label,
        icon = self.icon
    }, true)
end

CraftingStation.getForwardVector = function(self)
    local ped = GetPlayerPed(self.source)
    local playerCoords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    local radian = math.rad(heading + 180) -- Convert heading to radians and adjust by 180 degrees
    self.x = playerCoords.x + math.sin(radian) * self.distance
    self.y = playerCoords.y - math.cos(radian) * self.distance
    self.z = playerCoords.z
    self.w = heading
end

CraftingStation.checkExistingPlacement = function(self)
    --TODO
    -- use this to check if player has a station placed already and got disconnected
end

CraftingStation.delete = function(self)
    if not existingStation[self.source] then return end
    if DoesEntityExist(existingStation[self.source]) then
        DeleteEntity(existingStation[self.source])
    end
    CraftingStation[self.source] = nil
end

CraftingStation.pickup = function(self, entity)
    if existingStation[self.source] ~= entity then return print(self.source, entity)end
    local craftingStation = Entity(entity).state.craftingStation
    self:delete()
    exports['qb-inventory']:AddItem(self.source, craftingStation.item, 1, false, false, 'pickup workbench for crafting')
    TriggerClientEvent('qb-inventory:client:ItemBox', self.source, QBCore.Shared.Items[craftingStation.item], 'add', 1)
    QBCore.Functions.Notify(self.source, string.format(Lang:t('notifications.pickupStation')), "primary")
end

RegisterNetEvent('QBCore:Server:OnPlayerLoaded', function(Player)
    local craftingStation = existingStation[Player.PlayerData.source]
    if craftingStation then
        TriggerClientEvent('qb-crafting:client:place_crafting_station', Player.PlayerData.source, NetworkGetNetworkIdFromEntity(craftingStation), false)
    end
end)