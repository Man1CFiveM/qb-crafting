local QBCore = exports['qb-core']:GetCoreObject()
local placed = {}
Workbench = {}

Workbench.New = function(self, src, model, item, recipe, skill)
    self.source = src
    self.model = model
    self.item = item
    self.recipe = recipe
    self.skill = skill
    self.distance = Config.Settings.Distance
    return self
end

Workbench.Create = function(self)
    self:ForwardVector()
    self:Existing()
    local workbench = CreateObjectNoOffset(joaat(self.model), self.x, self.y, self.z-1, true, true, false)
    SetEntityHeading(workbench, self.w) -- Set the heading of the object
    placed[self.source] = workbench
    Entity(workbench).state:set('workbench', self.item, true)
    local workbenchState = Entity(workbench).state
    workbenchState:set('item', self.item, true)
    workbenchState:set('recipe', self.recipe, true)
    workbenchState:set('skill', self.skill, true)
    return workbench
end

Workbench.ForwardVector = function(self)
    local ped = GetPlayerPed(self.source)
    local playerCoords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    local radian = math.rad(heading + 180) -- Convert heading to radians and adjust by 180 degrees
    self.x = playerCoords.x + math.sin(radian) * self.distance
    self.y = playerCoords.y - math.cos(radian) * self.distance
    self.z = playerCoords.z
    self.w = heading
end

Workbench.Existing = function(self)
    if placed[self.source] then
        self:Delete()
    end
end

Workbench.Delete = function(self)
    if DoesEntityExist(placed[self.source]) then
        DeleteEntity(placed[self.source])
    end
    placed[self.source] = nil
end

Workbench.Pickup = function(self, entity)
    if not placed[self.source] == entity then return print(self.source, entity)end
    if DoesEntityExist(placed[self.source]) then
        DeleteEntity(placed[self.source])
        local workbenchState = Entity(entity).state
        exports['qb-inventory']:AddItem(self.source, workbenchState.item, 1, false, false, 'pickup workbench from crafting')
        TriggerClientEvent('qb-inventory:client:ItemBox', self.source, QBCore.Shared.Items[workbenchState.item].item, 'add', 1)
        QBCore.Functions.Notify(self.source, string.format(Lang:t('notifications.pickupworkbench')),workbenchState.item, "primary")
        placed[self.source] = nil
    end
end