Config = {}
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

Config.Crafting = {
    [1] = {
        useitem = { -- item to use to open the crafting menu
            target = true, -- true sets the target system, false or removed will use the press a button system
            item = 'crafting1',
            model = "prop_toolchest_02",
            icon = 'fas fa-tools', -- icon to display when targeting the object
            label = 'Crafting Bench',  -- label to display when targeting the object
        },
        skill = 'craftingrep', -- xp type to use for the crafting xp. its part of the metadata
        recipe = 'default', -- recipe to use for the crafting bench
    },
    [2] = {
        useitem = {
            item = 'crafting2',
            model = "prop_toolchest_04",
            icon = 'fas fa-tools',
            label = 'Crafting Bench',
        },
        skill = 'craftingrep',
        recipe = 'default',
    },
    [3] = {
        object = {
            model = "prop_toolchest_01", -- this uses the AddTargetModel function, it will set target to every single object with this model
            icon = 'fas fa-tools', -- icon to display when targeting the object
            label = 'Crafting Bench - Using Model Target',  -- label to display when targeting the object
        },
        skill = 'craftingrep', -- xp type to use for the crafting xp. its part of the metadata
        recipe = 'default', -- recipe to use for the crafting bench
    },
    [4] = { -- target a existing object and place a polyzone with target on it. this is usefull if you dont want all object to have targat but only a selected one/couple
        object = {
            icon = 'fas fa-tools', -- icon to display when targeting the object
            label = 'Crafting Bench - Setup Zone',  -- label to display when targeting the object
            location = {
                vector4(1091.72, 3072.62, 39.48, 190.16),
                vector4(1077.57, 3068.95, 39.79, 190.16)
            },
        },
        skill = 'craftingrep', -- xp type to use for the crafting xp. its part of the metadata
        recipe = 'default', -- recipe to use for the crafting bench
    },
    -- [5] = {
    --     object = {
    --         location = vector4(-13.94, -1086.91, 26.67, 0.0), -- a single location or a list can be passed
    --         length = 3.0, -- length of the polyzone
    --         width = 3.0, -- width of the polyzone
    --         minZ = 26.67, -- ground level of the polyzone
    --         maxZ = 27.67, -- height of the polyzone
    --         -- location = {
    --         --     vector4(-13.94, -1086.91, 26.67, 0.0),
    --         --     vector4(-13.94, -1086.91, 26.67, 0.0)
    --         -- },
    --     },
    --     skill = 'craftingrep', -- xp type to use for the crafting xp. its part of the metadata
    --     recipe = 'default', -- recipe to use for the crafting bench
    -- },

    [6] = {
        ped = {
            target = true, -- true sets the target system, false or removed will use the press a button system
            location = vector4(-13.94, -1086.91, 26.67, 0.0),
            -- location = {
            --     vector4(-13.94, -1086.91, 26.67, 0.0),
            --     vector4(-13.94, -1086.91, 26.67, 0.0)
            -- },
            model = 'a_m_m_hillbilly_01',
        },
        skill = 'craftingrep', -- xp type to use for the crafting xp. its part of the metadata
        recipe = 'default', -- recipe to use for the crafting bench
    },
    [8] = {
        ped = {
            location = vector4(-13.94, -1086.91, 26.67, 0.0), -- a single location or a list can be passed
            model = 'a_m_m_hillbilly_01',
            -- location = {
            --     vector4(-13.94, -1086.91, 26.67, 0.0),
            --     vector4(-13.94, -1086.91, 26.67, 0.0)
            -- },
        },
        skill = 'craftingrep', -- xp type to use for the crafting xp. its part of the metadata
        recipe = 'default', -- recipe to use for the crafting bench
    },






    -- [5] = { -- attachment bench
    --     target = false,
    --     placement = 'useableitemtoplaceattachmentbench',
    --     model = "prop_tool_bench02_ld",
    --     skill = 'attachmentcraftingrep',
    --     recipe = 'attachment',
    --     locations = {
    --         vector3(-25.08, -1082.77, 26.63)
    --     }
    -- },
}
