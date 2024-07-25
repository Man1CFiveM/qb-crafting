local placed = {}
CreateObject = {}

CreateObject.New = function(self, src, model)
    self.source = src
    self.model = model
    self.x = nil
    self.y = nil
    self.z = nil
    self.w = nil
    self.distance = Config.Settings.Distance
    self.objects = {}--This is just for testing
    self:ForwardVector()
    self:Create()
    return self.netid
end

CreateObject.Create = function(self)
    self:Existing()
    self.netid = CreateObjectNoOffset(joaat(self.model), self.x, self.y, self.z-1, true, true, false)
    SetEntityHeading(self.netid, self.w)
    placed[self.source] = self.netid
    self.objects[self.source] = self.netid
    return self.netid
end

CreateObject.ForwardVector = function(self)
    local ped = GetPlayerPed(self.source)
    local playerCoords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    local radian = math.rad(heading + 180)
    self.x = playerCoords.x + math.sin(radian) * self.distance
    self.y = playerCoords.y - math.cos(radian) * self.distance
    self.z = playerCoords.z
    self.w = heading
end

CreateObject.Existing = function(self)
    if placed[self.source] then
        self.Delete(self, self.source)
    end
end

CreateObject.Delete = function(self, src)
    if DoesEntityExist(placed[src]) then
        DeleteEntity(placed[src])
    end
    placed[src] = nil
end