local QBCore = exports['qb-core']:GetCoreObject()
Zone = {}
Zone.New = function(self, coords, option)
    self.option = option
    self.x = coords.x
    self.y = coords.y
    self.z = coords.z
    self.w = coords.w
    return self
end

Zone.Combo = function(self, option)
    local comboZone = {}
    for key, location in ipairs(option.locations) do
        local workbenchZone = BoxZone:Create(location, 3.0, 5.0, {
            name = option.model..'_'..tostring(key),
            debugPoly = Config.Settings.DebugPoly,
            data = option
        })
        comboZone[#comboZone + 1] = workbenchZone
    end

    local combo = ComboZone:Create(comboZone, {name="combo"})
    combo:onPlayerInOut(function(isPointInside, _, zone)
        if isPointInside then
            PressButtonToOpenCrafting(true, zone.data)
            self.option = zone.data
        else
            exports['qb-core']:HideText()
            PressButtonToOpenCrafting(false)
        end
    end)
end

Zone.UseableItem = function(self)
    self.zone = CircleZone:Create(vector3(self.x, self.y, self.z), 3.0, {
        name = "workbenchzone" ,
        debugPoly = true,
        useZ = true
    })
    self.zone:onPlayerInOut(function(isPointInside)
        if isPointInside then
            PressButtonToOpenCrafting(true, self.option)
        else
            local pickup = GetClosestObjectOfType(self.x, self.y, self.z, 2.0, joaat(self.option.useitem.model), false,false,false)
            TriggerServerEvent('qb-crafting:server:pickup_bench', NetworkGetNetworkIdFromEntity(pickup))
            exports['qb-core']:HideText()
            PressButtonToOpenCrafting(false)
            self:Destroy()
        end
    end)
end

Zone.Destroy = function(self)
    self.zone:destroy()
end

Zone.Get = function(self)
    return self.option
end