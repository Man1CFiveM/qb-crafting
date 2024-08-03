local QBCore = exports['qb-core']:GetCoreObject()
ZoneBuilder = {}
ZoneBuilder.new = function(self, recipe, skill, label)
    self.recipe = recipe
    self.skill = skill
    self.label = label
    return self
end

ZoneBuilder.createEntity = function(self, location, entityModel)
    QBCore.Functions.LoadModel(entityModel)
    if not self.isPed then
        local object = CreateObject(joaat(entityModel), location.x, location.y, location.z, false, false, false)
        SetEntityHeading(object, location.w)
        FreezeEntityPosition(object, true)
        return object
    end
    local ped = CreatePed(0, joaat(entityModel), location.x, location.y, location.z, location.w, false, false)
    self.ped = ped
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetEntityInvincible(ped, true)
    FreezeEntityPosition(ped, true)
    return ped
end

ZoneBuilder.combo = function(self, locations, length, width, entityModel, isPed)
    self.isPed = isPed
    local zones = {}
    for key, location in ipairs(locations) do
        local zoneData = {
            name = tostring(key),
            debugPoly = Config.Settings.DebugPoly,
            heading = location.heading,
        }
        zoneData.data = zoneData.data or {}
        if not self.isPed then
            self:createEntity(location, entityModel)
        else
            self:createEntity(location, entityModel)
        end
        local workbenchZone = BoxZone:Create(vector3(location.x, location.y, location.z), length, width, zoneData)
        zones[#zones + 1] = workbenchZone
    end

    local craftingZone = ComboZone:Create(zones, {name="combo"})
    craftingZone:onPlayerInOut(function(isPointInside)
        if isPointInside then
            PressButtonToOpenCrafting(true, self.recipe, self.skill, self.label)
        else
            exports['qb-core']:HideText()
            PressButtonToOpenCrafting(false)
        end
    end)
end

ZoneBuilder.boxzone = function(self, location, length, width, station)
    local workbenchZone = BoxZone:Create(vector3(location.x, location.y, location.z), length, width, {
        name = "boxZone",
        debugPoly = Config.Settings.DebugPoly,
        data = station
    })
    workbenchZone:onPlayerInOut(function(isPointInside)
        if isPointInside then
            PressButtonToOpenCrafting(true, self.recipe, self.skill, self.label)
        else
            exports['qb-core']:HideText()
            PressButtonToOpenCrafting(false)
        end
    end)
end

ZoneBuilder.useableItem = function(self, entity)
    self.stationZone = CircleZone:Create(GetEntityCoords(entity), Config.Settings.CircleZone.Radius, {
        name = "stationZoneUsableItem" ,
        debugPoly = Config.Settings.DebugPoly,
        useZ = true
    })
    self.stationZone:onPlayerInOut(function(isPointInside)
        if isPointInside then
            PressButtonToOpenCrafting(true, self.recipe, self.skill, self.label)
        else
            PressButtonToOpenCrafting(false)
            exports['qb-core']:HideText()
            self:destroy()
            return TriggerServerEvent('qb-crafting:server:pickup_station', NetworkGetNetworkIdFromEntity(entity))
        end
    end)
end

ZoneBuilder.destroy = function(self)
    self.stationZone:destroy()
end