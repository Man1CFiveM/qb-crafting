# Crafting Recipe Configuration

Crafting recipes are defined in the `recipe.lua` file located in the `config` folder.

```lua
Config.Recipes = {
    default = {  --This is the recipe group. You use the group in config.lua in recipe.
        ['lockpick'] = {  --The name of the item that will be crafted.
            required = 0,  --The minimum skill or XP level required to craft the item.
            reward = 1,  --The amount of XP that the player will receive for crafting the item.
            components = {  --A list of components to use to craft the item
                metalscrap = 22,  --The first part is the item we need to craft it and the second part if the amount
                plastic = 32
            }
        },
    }
}
```

# Crafting Bench Configuration Arguments

- `target`: Want to use the target system? Set this to true! If you prefer the press-a-button system, set this to false or simply remove it.
- `icon`: This is the icon that shows up when you're targeting the crafting bench. You can pick any FREE [FontAwesome](https://fontawesome.com/search?m=free&o=r) icon you like.
- `item`: This is the name of the item that, when used, opens up the crafting menu. Make sure it matches an item in your game's item database.
- `model`: This is the model of the item or crafting bench. It can be an in-game object or a ped.
- `label`: This is what players see when they target the crafting bench or item. It's usually shown in the interaction prompt.
- `skill`: Here's where you specify the type of XP for the crafting XP. It should match a skill already in your metadata or you can provide a new one.
- `recipe`: This is the recipe that the crafting bench uses. It should match a recipe in your game's crafting system.
- `object`: This field is used when you want to target all instances of a specific model. If you want to target a single specific object, you can use the `location` sub-field to specify the coordinates of the object.
- `ped`: This field is used when you want to target a specific ped. It has the same sub-fields as `object`, plus an additional `target` sub-field which works the same way as in `item`.
- `location`: This field is used to specify the coordinates where the object or ped can be found. It's an array of vector4 objects, each representing a location.

### Item Usage: Crafting Station with Placeable Object and Target System
```lua
Config.Useitem = {
    [1] = {
    target = true, --Set this to true to use the target system. If set to false or removed, the system will use the press a button system.
    item = 'crafting1', --The item to use to open the crafting menu. example crafting1, you need to add this to your items.lua to use this example item  
    model = 'v_ind_cs_toolbox4', --The model of the item you want to use
    icon = 'fas fa-tools', --The icon to display when targeting the crafting bench. 
    label = 'Crafting Bench place item with target ',
    skill = 'craftingrep',
    recipe = 'default',
    }
}
```

### Item Usage: Crafting Station with Placeable Object and press button
```lua
Config.Useitem = {
    [1] = {
    target = false,
    item = 'crafting2',
    model = "v_ind_cs_toolbox1",
    label = 'Crafting Bench use item Press E', --We remove icon as we dont need it, label is now used for the drawtext
    skill = 'craftingrep',
    recipe = 'default',
    }
}
```

### Crafting Station: Global Model Target
```lua
Config.CraftingStations = {
    [1] = {
    model = 'prop_toolchest_05', -- example location of 1 crafting station, vector3(-41.16, -1088.03, 25.42)
    icon = 'fas fa-tools', -- icon to display when targeting the object
    label = 'Crafting Model Global Target',  -- label to display when targeting the object
    skill = 'craftingrep', -- xp type to use for the crafting xp. its part of the metadata
    recipe = 'default', -- recipe to use for the crafting bench
    },
}
```

### Crafting Station: Target System with Pedestrian
```lua
Config.CraftingStations = {
    [1] = {
    icon = 'fas fa-tools', -- icon to display when targeting the object
    label = 'Crafting Person Target',  -- label to display when targeting the object
    ped = 's_m_m_postal_01', -- the model to use
    location = {
        vector4(1059.1, 3061.37, 40.48, 98.62),
        vector4(1056.7, 3070.51, 40.46, 98.38),
    },
    skill = 'craftingrep', -- xp type to use for the crafting xp. its part of the metadata
    recipe = 'default', -- recipe to use for the crafting bench
    },
}
```

### Crafting Station: Press Button System with create Pedestrian
```lua
Config.CraftingStations = {
    [1] = {
    label = 'Crafting Person Press E',  -- label to display when targeting the object
    ped = 's_m_m_postal_01', -- the model to use
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
```

### Crafting Station: Target System with create Object
```lua
Config.CraftingStations = {
    [1] = {
    icon = 'fas fa-tools', -- icon to display when targeting the object
    label = 'Crafting Person Press E',  -- label to display on drawtext
    object = 'prop_toolchest_05',
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
```

### Crafting Station: Only Location with Target System
```lua
Config.CraftingStations = {
    [1] = {
    icon = 'fas fa-tools', -- icon to display when targeting the object
    label = 'Crafting Location Target',  -- label to display when targeting the object
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
```

### Crafting Station: Only Location with Button System
```lua
Config.CraftingStations = {
    [1] = {
    label = 'Crafting Location Press E',  -- label to display on drawtext
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
```