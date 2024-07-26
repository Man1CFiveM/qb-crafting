local peds = {}
Ped = {}

Ped.New = function(self, model, coords, skill, recipe, label, icon, target)
    self.model = model
    self.coords = coords
    self.skill = skill
    self.recipe = recipe
    self.label = label
    self.icon = icon
    self.target = target
    self.ped = nil
    return self
end

Ped.Spawn = function(self)
    for _, coord in ipairs(self.coords) do
        self.ped = CreatePed(0, joaat(self.model), coord.x, coord.y, coord.z, coord.w, true, true)
        SetEntityHeading(self.ped, coord.w)
        if self.target then
            self:SetState()
        end
        peds[#peds + 1] = self.ped
    end
end

Ped.SetState = function(self)
    Entity(self.ped).state:set('crafting', {skill = self.skill, recipe = self.recipe, label = self.label, icon = self.icon})
end

Ped.Reset = function()
    for _, ped in ipairs(peds) do
        if DoesEntityExist(ped) then
            DeleteEntity(ped)
        end
    end
end

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        Ped:Reset()
    end
end)