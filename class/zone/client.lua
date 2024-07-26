local QBCore = exports['qb-core']:GetCoreObject()
Zone = {}
Zone.New = function(self, coords, combo, model, recipe, item, skill)
    print(coords, combo, model, recipe, item, skill)
    self.combo = nil
    self.model = model
    self.recipe = recipe
    self.coords = coords
    self.combo = combo
    self.item = item
    self.skill = skill
    return self
end

Zone.Combo = function(self)
    local comboZone = {}
    for key, location in ipairs(self.combo) do
        local workbenchZone = BoxZone:Create(vector3(location.x, location.y, location.y), 3.0, 5.0, {
            name = tostring(key),
            debugPoly = Config.Settings.DebugPoly,
            heading = location.heading
        })
        comboZone[#comboZone + 1] = workbenchZone
    end

    local combo = ComboZone:Create(comboZone, {name="combo"})
    combo:onPlayerInOut(function(isPointInside, _, zone)
        if isPointInside then
            PressButtonToOpenCrafting(true, self.recipe, self.item, self.skill)
        else
            exports['qb-core']:HideText()
            PressButtonToOpenCrafting(false)
        end
    end)
end

Zone.UseableItem = function(self)
    self.zone = CircleZone:Create(vector3(self.coords.x, self.coords.y, self.coords.z), 3.0, {
        name = "workbenchzone" ,
        debugPoly = true,
        useZ = true
    })
    self.zone:onPlayerInOut(function(isPointInside)
        if isPointInside then
            PressButtonToOpenCrafting(true, self.recipe, self.item, self.skill)
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