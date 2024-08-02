local QBCore = exports['qb-core']:GetCoreObject()
ZoneBuilder = {}
ZoneBuilder.new = function(self, recipe, skill, label)
    self.recipe = recipe
    self.skill = skill
    self.label = label
    return self
end

ZoneBuilder.createObject = function(self, location, length, width, object)
    if type(location) == 'table' then
        self.craftingStation = 'object'
        return self:combo(location, length, width, object)
    end
    local station = self:createEntity(object, location)
    return self:boxzone(location, length, width, station)
end

ZoneBuilder.createPed = function(self, location, length, width, ped)
    if type(location) == 'table' then
        self.craftingStation = 'ped'
        return self:combo(location, length, width, ped)
    end
    local station = self:createEntity(ped, location)
    return self:boxzone(location, length, width, station)
end

ZoneBuilder.zone = function(self, location, length, width, object)
    if self:isLocationTable(location) then
        return self:combo(location, length, width, object)
    end
    return self:boxzone(location, length, width, object)
end

ZoneBuilder.createEntity = function(self, entityModel, locations)
    QBCore.Functions.LoadModel(entityModel)
    local craftingStation
    if self.craftingStation == 'object' then
        craftingStation = CreateObject(joaat(entityModel), locations.x, locations.y, locations.z, false, false, false)
        SetEntityHeading(craftingStation, locations.w)
    elseif self.craftingStation == 'ped' then
        craftingStation = CreatePed(0, joaat(entityModel), locations.x, locations.y, locations.z, locations.w, false, false)
        SetBlockingOfNonTemporaryEvents(craftingStation, true)
        SetEntityInvincible(craftingStation, true)
    end
    FreezeEntityPosition(craftingStation, true)
    SetModelAsNoLongerNeeded(entityModel)
    return craftingStation
end

ZoneBuilder.combo = function(self, locations, length, width, object)
    local zones = {}
    for key, location in ipairs(locations) do
        local zoneData = {
            name = tostring(key),
            debugPoly = Config.Settings.DebugPoly,
            heading = location.heading,
        }
        if self.craftingStation then
            zoneData.data = self:createEntity(object, location)
        end
        local workbenchZone = BoxZone:Create(vector3(location.x, location.y, location.z), length, width, zoneData)
        zones[#zones + 1] = workbenchZone
    end

    local craftingZone = ComboZone:Create(zones, {name="combo"})
    craftingZone:onPlayerInOut(function(isPointInside, _, _)
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