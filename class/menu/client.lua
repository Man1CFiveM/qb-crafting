local QBCore = exports['qb-core']:GetCoreObject()
local isMenuOpen = false
Menu = {}
Menu.New = function(self, recipe, item, skill)
    self.recipe = recipe
    self.item = item
    self.skill = skill
    self.amount = nil
    self.isOpen = false
    self.playerInventory = self:GetPlayerInventory()
    self.experience = QBCore.Functions.GetPlayerData().metadata.rep[self.skill] or 0
    self.menuItems = self:CreateSortedMenuItems()
    self:OpenMenu()
    return self
end

Menu.OpenMenu = function(self)
    isMenuOpen = true
    exports['qb-menu']:openMenu(self.menuItems)
end

Menu.GetPlayerInventory = function(self)
    local i = promise:new()
    QBCore.Functions.TriggerCallback('qb-crafting:server:getPlayersInventory', function(inventory)
        i:resolve(inventory)
        self.playerInventory = inventory
    end)
    return Citizen.Await(i)
end

Menu.CreateSortedMenuItems = function(self)
    local menuItemsCreatable = {}
    local menuItemsNonCreatable = {}
    for name, item in pairs(Config.Recipes[self.recipe]) do
        if self.experience >= item.required then
            local disable, discription = self:EnableItemInMenu(item.components)
            local menuItem = self:CreateMenuItem(name, disable, discription)
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

Menu.EnableItemInMenu = function(self, component)
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

Menu.CreateMenuItem = function(self,name, disable, discription)
    return {
        header = QBCore.Shared.Items[name].label,
        txt = discription,
        icon = Config.Settings.ImageBasePath .. QBCore.Shared.Items[name].image,
        params = {
            isAction = true,
            event = function()
                self:CheckItem(name)
            end,
            args = {}
        },
        disabled = not disable
    }
end

Menu.CheckItem = function(self, item)
    local itemRecipe = Config.Recipes[self.recipe][item]
    self.reward = itemRecipe.reward
    self.item = item
    self.amount = self:AmountOfItemsToCraft()

    if not self:HasEnoughComponents() then
        PressButtonToOpenCrafting(true, self.option)
        return QBCore.Functions.Notify(string.format(Lang:t('notifications.notenoughMaterials')), 'error')
    end
    self:CreateItem()
end

Menu.HasEnoughComponents = function(self)
    local multipliedComponents = {}
    for comp, amount in pairs(Config.Recipes[self.recipe][self.item].components) do
        multipliedComponents[comp] = amount * self.amount
    end

    for item, amount in pairs(multipliedComponents) do
        if not self.playerInventory[item] or self.playerInventory[item] < amount then
            return false
        end
    end
    return true
end

Menu.AmountOfItemsToCraft = function(self)
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

Menu.CreateItem = function(self)
    if not Config.Settings.Minigame then
        return self:RunProgressbarForCrafting()
    end
    local success = Config.Minigame()
    if not success then
        if not Config.Settings.LostComponent then
            PressButtonToOpenCrafting(true, self.option)
            return QBCore.Functions.Notify(string.format(Lang:t('notifications.craftingFailed')), 'error')
        end
        PressButtonToOpenCrafting(true, self.option)
        return TriggerServerEvent('qb-crafting:server:item', false, {recipe = self.recipe, item = self.item, amount = self.amount})
    end
    self:RunProgressbarForCrafting()
end

Menu.RunProgressbarForCrafting = function(self)
    local timer = math.random(Config.Settings.CraftingTime.Min or 1000, Config.Settings.CraftingTime.Max or 2000)
    if Config.Settings.CraftingTime.Multiplied then
        timer = timer * self.amount
    end
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
        TriggerServerEvent('qb-crafting:server:item', true, {item = self.item, amount = self.amount, recipe = self.recipe, skill = self.skill})
        if not Config.Settings.target then
            PressButtonToOpenCrafting(true, self.option)
        end
    end, function()
        TriggerServerEvent('qb-crafting:server:item', false, {recipe = self.recipe, item = self.item, amount = self.amount})
        if not Config.Settings.target then
            PressButtonToOpenCrafting(true, self.option)
        end
    end)
end

Menu.Get = function(self)
    return isMenuOpen
end