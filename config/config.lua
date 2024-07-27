Config = {}
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
    }, -- TODO do we want to have a option for minigame on every single ta
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

    [5] = {
        ped = {
            target = true, -- true sets the target system, false or removed will use the press a button system
            model = 'A_M_Y_BusiCas_01',
            icon = 'fas fa-tools', -- icon to display when targeting the object
            label = 'Crafting Bench - Using Ped Target',  -- label to display when targeting the object
            location = {
                vector4(1063.96, 3091.41, 41.06, 12.84),
                vector4(1076.11, 3095.08, 40.58, 96.96)
            },
        },
        skill = 'craftingrep', -- xp type to use for the crafting xp. its part of the metadata
        recipe = 'default', -- recipe to use for the crafting bench
    },
    [6] = {
        ped = {
            model = 'A_F_Y_Vinewood_04',
            location = {
                vector4(1066.29, 3079.34, 41.06, 5.99),
                vector4(1082.41, 3083.88, 40.41, 351.55)
            },
        },
        skill = 'craftingrep', -- xp type to use for the crafting xp. its part of the metadata
        recipe = 'default', -- recipe to use for the crafting bench
    },
}

-- [5] = { --TODO do we need this one?
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
