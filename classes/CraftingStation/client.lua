local QBCore = exports['qb-core']:GetCoreObject()
CraftingStation = {}
CraftingStation.new = function(self)
    return self
end

CraftingStation.waitForEntityExistence = function(self)
    local time = GetGameTimer()
    while not NetworkDoesEntityExistWithNetworkId(self.netId) do
        if GetGameTimer() - time > 1000 then return print('waitForEntityExistence: exceed allowed time',self.netId) end
        Wait(1)
    end
    self.entity = NetToEnt(self.netId)
    if not DoesEntityExist(self.entity) then return print('waitForEntityExistence: Entity does not exist ',self.entity) end
    return NetToEnt(self.netId)
end

CraftingStation.waitForState = function(self, netId)
    self.netId = netId
    self:waitForEntityExistence()
    local craftingStation, time = nil, GetGameTimer()
    while not craftingStation do
        craftingStation = Entity(self.entity).state.craftingStation
        if GetGameTimer() - time > 1000 then return print('waitForState: Exceeded allowed time ',self.entity) end
        Wait(10)
    end
    self.model = craftingStation.model
    self.item = craftingStation.item
    self.recipe = craftingStation.recipe
    self.skill = craftingStation.skill
    self.label = craftingStation.label
    self.icon = craftingStation.icon
    craftingStation.entity = self.entity
    return craftingStation
end

CraftingStation.get = function(self)
    return self.model, self.item, self.recipe, self.skill, self.label, self.icon
end