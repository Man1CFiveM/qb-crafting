Zone = {}
Zone.Create = function(self, option)
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
            print('out the zone')
            exports['qb-core']:HideText()
            Crafting:Destroy()
            PressButtonToOpenCrafting(false)
        end
    end)
end

Zone.Get = function(self)
    return self.option
end
