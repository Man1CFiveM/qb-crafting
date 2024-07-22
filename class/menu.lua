local QBCore = exports['qb-core']:GetCoreObject()

Crafting = {}
Crafting.Open = function(self, option)
    self.option = option
    self.playerInventory = self:GetPlayerInventory()
    self.recipe = option.recipes
    self.skill = option.skill
    self.item = nil

    local PlayerData = QBCore.Functions.GetPlayerData()
    local experience = PlayerData.metadata[option.skill] or 0

    local menuItems = self:CreateSortedMenuItems(experience)
    self:OpenMenu(menuItems)
end

Crafting.Destroy = function(self)
    self.option = nil
    self.recipe = nil
    self.skill = nil
    self.item = nil
    self.components = nil
end

Crafting.CreateSortedMenuItems = function(self, experience)
    local menuItemsCreatable = {}
    local menuItemsNonCreatable = {}

    for name, item in pairs(Config.Recipes[self.recipe]) do
        if experience >= item.required then
            local disable, text = self:EnableItemInMenu(item.components)
            local menuItem = self:CreateMenuItem(name, item, disable, text)
            if disable then
                menuItemsCreatable[#menuItemsCreatable + 1] = menuItem
            else
                menuItemsNonCreatable[#menuItemsNonCreatable + 1] = menuItem
            end
        end
    end

    local menuItems = {
        {
            header = string.format(Lang:t('menus.header')),
            icon = 'fas fa-drafting-compass',
            isMenuHeader = true,
        }
    }

    for _, item in ipairs(menuItemsCreatable) do
        menuItems[#menuItems + 1] = item
    end

    for _, item in ipairs(menuItemsNonCreatable) do
        menuItems[#menuItems + 1] = item
    end

    return menuItems
end

Crafting.OpenMenu = function(self, menuItems)
    exports['qb-menu']:openMenu(menuItems)
end

Crafting.GetPlayerInventory = function(self)
    local i = promise:new()
    QBCore.Functions.TriggerCallback('qb-crafting:server:getPlayersInventory', function(inventory)
        i:resolve(inventory)
        self.playerInventory = inventory
    end)
    return Citizen.Await(i)
end

Crafting.CreateMenuItem = function(self,name, item, disable, discription)
    return {
        header = QBCore.Shared.Items[name].label,
        txt = discription,
        icon = Config.Settings.ImageBasePath .. QBCore.Shared.Items[name].image,
        params = {
            isAction = true,
            event = function()
                self:CanCreateItem(name, item.components, item.reward, self.skill)
            end,
            args = {}
        },
        disabled = not disable
    }
end

Crafting.EnableItemInMenu = function(self, component)
    local disable = true
    local discription = ''
    for item, amount in pairs(component) do
        local itemLabel = QBCore.Shared.Items[item].label
        discription = discription .. ' x' .. tostring(amount) .. ' ' .. itemLabel .. '<br>'
        if (self.playerInventory[item] or 0) < amount then
            disable = false
        end
    end
    return disable, discription
end

Crafting.CanCreateItem = function(self, item, components, reward, type)
    local amountToCraft = self:AmountOfItemsToCraft()
    local multipliedComponents = {}
    for comp, amount in pairs(components) do
        multipliedComponents[comp] = amount * amountToCraft
    end
    if not self:HasEnoughComponents(multipliedComponents) then
        PressButtonToOpenCrafting(true, self.option)
        return QBCore.Functions.Notify(string.format(Lang:t('notifications.notenoughMaterials')), 'error')
    end
    self.item = item
    self:CreateItem(multipliedComponents, amountToCraft, reward, type)
end

Crafting.HasEnoughComponents = function(self, multipliedItems)
    local hasEnough = true
    for item, amount in pairs(multipliedItems) do
        if not self.playerInventory[item] or self.playerInventory[item] < amount then
            hasEnough = false
        end
    end
    return hasEnough
end

Crafting.AmountOfItemsToCraft = function(self)
    local dialog = exports['qb-input']:ShowInput({
        header = string.format(Lang:t('menus.entercraftAmount')),
        submitText = 'Confirm',
        inputs = {
            {
                type = 'number',
                name = 'amount',
                label = 'Amount',
                text = 'Enter Amount',
                isRequired = true
            },
        },
    })

    if not dialog then
        PressButtonToOpenCrafting(true, self.option)
        return QBCore.Functions.Notify(string.format(Lang:t('notifications.invalidInput')), 'error')
    end
    local amount = tonumber(dialog.amount)
    if not dialog or amount <= 0 then
        PressButtonToOpenCrafting(true, self.option)
        return QBCore.Functions.Notify(string.format(Lang:t('notifications.invalidAmount')), 'error')
    end
    return amount
end

Crafting.LostRandomComponents = function(requiredItems)
    local itemList = {}
    for item in pairs(requiredItems) do
        itemList[#itemList + 1] = item
    end
    local randomItem = itemList[math.random(#itemList)]
    local randomAmount = math.random(requiredItems[randomItem])
    return randomItem, randomAmount
end

Crafting.FailedCreatingItem = function(self, components)
    if not Config.Settings.LostComponent then
        return QBCore.Functions.Notify(string.format(Lang:t('notifications.craftingFailed')), 'error')
    end
    local component, amount = Crafting.LostRandomComponents(components)
    TriggerServerEvent('qb-crafting:server:item', false, {component = component, amount = amount})
    PressButtonToOpenCrafting(true, self.option)
    self.item = nil
    return QBCore.Functions.Notify(string.format(Lang:t('notifications.craftingFailed')), 'error')
end

Crafting.CreateItem = function(self, components, amountToCraft, reward, skill)
    if not Config.Settings.Minigame then
        return self:RunProgressbarForCrafting(amountToCraft, reward, skill)
    end
    local success = Config.Minigame()
    if not success then
        self:FailedCreatingItem(components)
    end
    self.components = components
    self:RunProgressbarForCrafting(amountToCraft, reward, skill)
end

Crafting.RunProgressbarForCrafting = function(self, amountToCraft, reward, skill)
    local timer = math.random(Config.Settings.CraftingTime.Min or 1000, Config.Settings.CraftingTime.Max or 2000) * amountToCraft
    QBCore.Functions.Progressbar('crafting_item', 'Crafting ' .. QBCore.Shared.Items[self.item].label, timer, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = 'mini@repair',
        anim = 'fixing_a_player',
        flags = 16,
    }, {}, {}, function()
        TriggerServerEvent('qb-crafting:server:item', true, {item = self.item, amount = amountToCraft, reward = reward, skill = skill, recipe = self.recipe})
        if not Config.Settings.target then
            PressButtonToOpenCrafting(true, self.option)
        end
    end, function()
        self:FailedCreatingItem(self.components)
        if not Config.Settings.target then
            PressButtonToOpenCrafting(true, self.option)
        end
    end)
end