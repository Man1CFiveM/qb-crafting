local QBCore = exports['qb-core']:GetCoreObject()
local isMenuOpen = false
CraftingMenu = {}
CraftingMenu.new = function(self, recipe, skill, label, target)
    self.target = target
    self.recipe = recipe
    self.skill = skill
    self.label = label
    self.playerInventory = self:getPlayerInventory()
    return self
end

CraftingMenu.openMenu = function(self)
    isMenuOpen = true
    self.experience = QBCore.Functions.GetPlayerData().metadata.rep[self.skill] or 0
    self.menuItems = self:createSortedMenuItems()
    exports['qb-menu']:openMenu(self.menuItems)
end

CraftingMenu.getPlayerInventory = function(self)
    local i = promise:new()
    QBCore.Functions.TriggerCallback('qb-crafting:server:getPlayersInventory', function(inventory)
        i:resolve(inventory)
        self.playerInventory = inventory
    end)
    return Citizen.Await(i)
end

CraftingMenu.createSortedMenuItems = function(self)
    local menuItemsCreatable = {}
    local menuItemsNonCreatable = {}
    
    -- Obtains the player job, gang and grade from qb-core
    local playerData = QBCore.Functions.GetPlayerData()
    local playerJob = playerData.job.name
    local playerJobGrade = playerData.job.grade.level
    local playerGang = playerData.gang.name
    local playerGangGrade = playerData.gang.grade.level

    for name, item in pairs(Config.Recipes[self.recipe]) do
        if self.experience >= item.required then
            -- Check if the player job or gang matches with the jobNeeded if it is diferent than none
            if item.jobNeeded == 'none' or
            (item.jobNeeded == playerJob and (tonumber(item.jobGrade) <= tonumber(playerJobGrade))) or
            (item.jobNeeded == playerGang and (tonumber(item.jobGrade) <= tonumber(playerGangGrade))) then
                local disable, discription = self:enableItemInMenu(item.components)
                local menuItem = self:createMenuItem(name, disable, discription)
                if disable then
                    menuItemsCreatable[#menuItemsCreatable + 1] = menuItem
                else
                    menuItemsNonCreatable[#menuItemsNonCreatable + 1] = menuItem
                end
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

CraftingMenu.enableItemInMenu = function(self, component)
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

CraftingMenu.createMenuItem = function(self,name, disable, discription)
    return {
        header = QBCore.Shared.Items[name].label,
        txt = discription,
        icon = Config.Settings.ImageBasePath .. QBCore.Shared.Items[name].image,
        params = {
            isAction = true,
            event = function()
                self:checkItem(name)
            end,
            args = {}
        },
        disabled = not disable
    }
end

CraftingMenu.checkItem = function(self, item)
    local itemRecipe = Config.Recipes[self.recipe][item]
    self.reward = itemRecipe.reward
    self.item = item
    self.amount = self:amountOfItemsToCraft()
    if not self:hasEnoughComponents() then
        PressButtonToOpenCrafting(true, self.recipe, self.skill, self.label)
        return QBCore.Functions.Notify(string.format(Lang:t('notifications.notenoughMaterials')), 'error')
    end
    self:createItem()
end

CraftingMenu.hasEnoughComponents = function(self)
    if not self.amount or self.amount <= 0  then
        return false
    end
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

CraftingMenu.amountOfItemsToCraft = function(self)
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
        PressButtonToOpenCrafting(true, self.recipe, self.skill, self.label)
        return QBCore.Functions.Notify(string.format(Lang:t('notifications.invalidInput')), 'error')
    end
    local amount = tonumber(dialog.amount)
    if not dialog or amount <= 0 then
        PressButtonToOpenCrafting(true, self.recipe, self.skill, self.label)
        return QBCore.Functions.Notify(string.format(Lang:t('notifications.invalidAmount')), 'error')
    end
    return amount
end

CraftingMenu.createItem = function(self)
    if not Config.Settings.Minigame then
        return self:runProgressbarForCrafting()
    end
    local success = Config.Minigame()
    if not success then
        if not Config.Settings.LostComponent then
            PressButtonToOpenCrafting(true, self.recipe, self.skill, self.label)
            return QBCore.Functions.Notify(string.format(Lang:t('notifications.craftingFailed')), 'error')
        end
        PressButtonToOpenCrafting(true, self.recipe, self.skill, self.label)
        return TriggerServerEvent('qb-crafting:server:item', false, {recipe = self.recipe, item = self.item, amount = self.amount})
    end
    self:runProgressbarForCrafting()
end

CraftingMenu.playAnim = function(dict, anim, ped)
    print(dict, anim, ped)
    local peds = ped or PlayerPedId()
    local start = GetGameTimer()
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        if (GetGameTimer() - start) > 100 then
            return print('Animation dictionary failed to load')
        end
        Wait(1)
    end
    TaskPlayAnim(peds, dict, anim, 8.0, 8.0, -1, 50, 0, false, false, false)
end

CraftingMenu.runProgressbarForCrafting = function(self)
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
        flags = 1,
    }, {}, {}, function()
        TriggerServerEvent('qb-crafting:server:item', true, {item = self.item, amount = self.amount, recipe = self.recipe, skill = self.skill})
        if not self.target then
            PressButtonToOpenCrafting(true, self.recipe, self.skill, self.label)
        end
    end, function()
        TriggerServerEvent('qb-crafting:server:item', false, {recipe = self.recipe, item = self.item, amount = self.amount})
        if not self.target then
            PressButtonToOpenCrafting(true, self.recipe, self.skill, self.label)
        end
    end)
end

CraftingMenu.get = function(self)
    if isMenuOpen and not self.target then
        return self.entity
    end
    return false
end

AddEventHandler('qb-menu:client:menuClosed', function()
    if CraftingMenu:get() then
        PressButtonToOpenCrafting(true, CraftingMenu:get())
    end
end)