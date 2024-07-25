local QBCore = exports['qb-core']:GetCoreObject()
Item = {}
Item.New = function(self, source, item, amount, recipe, skill)
    self.source = source
    self.item = item
    self.amount = amount
    self.recipe = recipe
    self.skill = skill
    self.components = Config.Recipes[recipe][item].components
    self.reward = Config.Recipes[recipe][item].reward
    return self
end

Item.Add = function(self)
    if not self:HasEnoughComponents() then
        return print('Error handler, player can not create item', self.source)
    end
    self:RemoveComponents()
    exports['qb-inventory']:AddItem(self.source, self.item, self.amount, false, false, 'item crafted - '..self.item..' - '..self.amount)
    QBCore.Functions.Notify(self.source, string.format(Lang:t('notifications.craftMessage'), QBCore.Shared.Items[self.item].label), 'success')
end

Item.RemoveComponents = function(self)
    for component, count in pairs(self.components) do
        exports['qb-inventory']:RemoveItem(self.source, component, count * self.amount, false, 'Remove component for crafting - '..self.item..' - '..component)
        TriggerClientEvent('qb-inventory:client:ItemBox', self.source, QBCore.Shared.Items[component], 'remove', count * self.amount)
    end
end

Item.Reward = function(self)
    local Player = QBCore.Functions.GetPlayer(self.source)
    Player.Functions.AddRep(self.skill, self.reward)
    QBCore.Functions.Notify(self.source, string.format(Lang:t('notifications.xpGain'), self.reward, self.skill), 'success')
end

Item.HasEnoughComponents = function(self)
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

Item.RandomLostComponents = function(self)
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