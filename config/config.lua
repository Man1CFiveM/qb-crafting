Config = {}
Config.Useitem = {
    [1] = {-- item to use to open the crafting menu
        target = true, -- if true it uses the target system, if false it uses the press a button system
        item = 'crafting1', -- provide any item name that you want to use to t place the crafting station
        model = 'prop_toolchest_02',
        icon = 'fas fa-tools', -- icon to display when targeting the object
        label = 'Crafting Bench',  -- label to display when targeting the object
        skill = 'craftingrep', -- xp type to use for the crafting xp. its part of the metadata
        recipe = 'default', -- recipe to use for the crafting bench
    }, -- example of a crafting station that uses a object that you can place and use the press a button system
    [2] = {
        target = false,
        item = 'crafting2',
        model = "prop_toolchest_04",
        label = 'Crafting Bench use item Press E',
        skill = 'craftingrep',
        recipe = 'default',
    },
}

Config.CraftingStations = {
    [1] = {
        model = 'prop_toolchest_05', -- example loaction of 1 crafting station, vector3(-41.16, -1088.03, 25.42)
        icon = 'fas fa-tools', -- icon to display when targeting the object
        label = 'Crafting Model Target',  -- label to display when targeting the object
        skill = 'craftingrep', -- xp type to use for the crafting xp. its part of the metadata
        recipe = 'default', -- recipe to use for the crafting bench
    },
    [2] = {
        icon = 'fas fa-tools', -- icon to display when targeting the object
        label = 'Crafting Person Press E',  -- label to display when targeting the object
        ped = 's_m_m_postal_01', 
        location = {
            vector4(1059.1, 3061.37, 40.48, 98.62),
            vector4(1056.7, 3070.51, 40.46, 98.38),
        },
        length = 1.5,
        width = 1.5,
        skill = 'craftingrep', -- xp type to use for the crafting xp. its part of the metadata
        recipe = 'default', -- recipe to use for the crafting bench
    },
}
