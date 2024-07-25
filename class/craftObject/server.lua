local placed = {}
CraftObject = {}

CraftObject.New = function(self, src, model)
    self.source = src
    self.model = model
    self.distance = Config.Settings.Distance
    return self
end

CraftObject.Create = function(self)
    self:ForwardVector()
    self:Existing()
    local workbench = CreateObjectNoOffset(joaat(self.model), self.x, self.y, self.z-1, true, true, false)
    SetEntityHeading(self.netid, self.w)
    placed[self.source] = workbench
    return workbench
end

CraftObject.ForwardVector = function(self)
    local ped = GetPlayerPed(self.source)
    local playerCoords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    local radian = math.rad(heading + 180)
    self.x = playerCoords.x + math.sin(radian) * self.distance
    self.y = playerCoords.y - math.cos(radian) * self.distance
    self.z = playerCoords.z
    self.w = heading
end

CraftObject.Existing = function(self)
    if placed[self.source] then
        self:Delete(self.source)
    end
end

CraftObject.Delete = function(self)
    if DoesEntityExist(placed[self.source]) then
        DeleteEntity(placed[self.source])
    end
    placed[self.source] = nil
end

CraftObject.Pickup = function(self, entity)
    if not placed[self.source] == entity then return print(self.source, entity)end
    if DoesEntityExist(placed[self.source]) then
        DeleteEntity(placed[self.source])
        placed[self.source] = nil
    end
end