local QBCore = exports['qb-core']:GetCoreObject()
ItemCrafting = {}
ItemCrafting.New = function(self, source, item, amount, recipe, skill)
    self.source = source
    self.amount = amount
    self.recipe = recipe
    self.skill = skill
    self.item = item
    self.xp = Config.Recipes[recipe][item].reward
    self.components = Config.Recipes[recipe][item].components
    return self
end

ItemCrafting.itemToCraft = function(self)
    if not self:checkSufficientComponents() then
        return print('Error handler, player can not create item', self.source) --TODO proper error handling. at this stage player should have enough components
    end
    self:removeComponentsForCrafting()
    exports['qb-inventory']:AddItem(self.source, self.item, self.amount, false, false, 'item crafted - '..self.item..' - '..self.amount)
    QBCore.Functions.Notify(self.source, string.format(Lang:t('notifications.craftMessage'), self.amount..' x '.. QBCore.Shared.Items[self.item].label), 'success')
end

ItemCrafting.removeComponentsForCrafting = function(self)
    for component, count in pairs(self.components) do
        print(component, count)
        exports['qb-inventory']:RemoveItem(self.source, component, count * self.amount, false, 'Remove component for crafting - '..self.item..' - '..component)
        TriggerClientEvent('qb-inventory:client:ItemBox', self.source, QBCore.Shared.Items[component], 'remove', count * self.amount)
    end
end

ItemCrafting.earnExperiencePoints = function(self)
    local Player = QBCore.Functions.GetPlayer(self.source)
    Player.Functions.AddRep(self.skill, self.xp)
    QBCore.Functions.Notify(self.source, string.format(Lang:t('notifications.xpGain'), self.xp, self.skill), 'success')
end

ItemCrafting.checkSufficientComponents = function(self)
    local Player = QBCore.Functions.GetPlayer(self.source)
    local inventory = {}
    for _, _item in pairs(Player.PlayerData.items) do
        inventory[_item.name] = _item.amount
    end
    local components = Config.Recipes[self.recipe][self.item].components
    for component, requiredAmount in pairs(components) do
        if not inventory[component] or inventory[component] < requiredAmount * self.amount then
            return false
        end
    end
    return true
end

ItemCrafting.loseRandomComponents = function(self) --TODO Do we need to do any checks here?
    local components = Config.Recipes[self.recipe][self.item].components

    local componentKeys = {}
    for component, _ in pairs(components) do
        componentKeys[#componentKeys+1] = component
    end

    local randomComponent = componentKeys[math.random(#componentKeys)]
    local maxAmount = components[randomComponent] * self.amount
    local randomAmount = math.random(maxAmount)

    exports['qb-inventory']:RemoveItem(self.source, randomComponent, randomAmount, false, 'qb-crafting:server:removeMaterials')
    TriggerClientEvent('qb-inventory:client:ItemBox', self.source, QBCore.Shared.Items[randomComponent], 'remove')
end