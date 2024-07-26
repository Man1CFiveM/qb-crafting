Config.Settings = {
    ImageBasePath = "nui://qb-inventory/html/images/", -- When using a different inventory, change this to the base path of the inventory images
    TargetDistance = 2.5, -- Distance to target the crafting bench
    TargetIcon = 'fas fa-tools', -- Icon to display when targeting the crafting bench
    Distance = 2.0, -- Distance to place the crafting bench on the ground
    Minigame = true, -- Enable or disable the skill check, if enabled the player will have to complete a skill check to craft the item
    LostComponent = true, -- Enable or disable losing a component, if player fails the skill check or cancels the progresssbar they will lose a component
    CraftingTime = {
        Min = 1000, -- Minimum time in milliseconds to craft the item
        Max = 2000, -- Maximum time in milliseconds to craft the item
        Multiplied = true -- Enable or disable the multiplied crafting time, if enabled the crafting time will be multiplied by the amount of items to craft
    },
    DebugPoly = true, -- Enable or disable the debug poly for the crafting benches
    BoxZone = {
        Length = 3.5, -- Length of the boxzone
        Width = 1.4, -- Width of the boxzone
    },
}


Config.Minigame = function() -- Minigame to use for the skill check, needs to return atleast a true when succesfull
    return exports['qb-minigames']:Skillbar('easy', '12345')
end