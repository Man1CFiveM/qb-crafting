Target = {}
Target.New = function(self, netid, model, icon, label, item, recipe, skill)
    self.netid = netid
    self.model = model
    self.icon = icon
    self.label = label
    self.item = item
    self.recipe = recipe
    self.skill = skill
    self.distance = Config.Settings.TargetDistance
    return self
end

Target.Entity = function(self)
    exports['qb-target']:AddTargetEntity(self.netid, {
        options = {
                {
                    num = 1,
                    icon = self.icon,
                    label = self.label,
                    action = function(entity)
                        if entity == NetToEnt(self.netid) then
                            Menu:New(self.recipe, self.item, self.skill):OpenMenu()
                        end
                    end,
                },
                {
                    num = 2,
                    icon = 'fa-solid fa-trash',
                    label = 'Pickup',
                    action = function(entity)
                        local animDict = "pickup_object"
                        RequestAnimDict(animDict)
                        while not HasAnimDictLoaded(animDict) do
                            Wait(0)
                        end
                        TaskPlayAnim(PlayerPedId(), animDict, "pickup_low", 8.0, -8.0, -1, 0, 0, false, false, false)
                        TriggerServerEvent('qb-crafting:server:pickup_bench', NetworkGetNetworkIdFromEntity(entity))
                        self:Delete()
                    end,
            }
            },
            distance = Config.Settings.TargetDistance,
        })
end

Target.Model = function(self)
    exports['qb-target']:AddTargetModel(joaat(self.model), {
        options = {
                {
                    num = 1,
                    icon = self.icon,
                    label = self.label,
                    action = function(entity)
                        if GetEntityModel(entity) == joaat(self.model) then
                            Menu:New(self.recipe, self.item, self.skill):OpenMenu()
                        end
                    end,
                },
            },
            distance = Config.Settings.TargetDistance,
        })
end

Target.Delete = function(self)
    exports['qb-target']:RemoveTargetEntity(self.netid)
end