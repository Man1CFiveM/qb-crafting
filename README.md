# qb-crafting
This is a crafting script for the QBCore Framework in FiveM. It allows players to craft items using resources in their inventory.

## Features
- Players can craft items using resources in their inventory.
- Config folder etc
- Crafting recipes are defined in the `Config.Recipes` table in `config\recipe.lua`. Each recipe has a name, a list of required components, and a required skill level.
- Crafting benches can be accessed in two ways: either by placing a workbench using an item, or by utilizing existing workbenches in the world.
- Either target or use key can be used to use the work bench
- The crafting menu shows which items can be crafted based on the player's current inventory and skill level.

### useitem: This field is used when you want to open the crafting menu by using a specific item:
- `target`: Set this to true to use the target system. If set to false or removed, the system will use the press a button system.
- `icon`: The icon to display when targeting the crafting bench.
- `item`: The name of the item to use to open the crafting menu.
- `model`: The model of the item.
- `label`: The label to display when targeting the object.
- `skill`: This field is used to specify the type of XP to use for the crafting XP. It's part of the metadata.
- `recipe`: This field is used to specify the recipe to use for the crafting bench.

### Code Snippet
Example 1: In this example, we're using an item (crafting1) to open the crafting menu. The target system is enabled (target = true).
```
[1] = {
    useitem = {
        target = true,
        item = 'crafting1',
        model = "prop_toolchest_02",
        icon = 'fas fa-tools',
        label = 'Crafting Bench',
    },
    skill = 'craftingrep',
    recipe = 'default',
},
```
Example 2: In this example, we're using an item (crafting2) to open the crafting menu. The target system is not specified, so it will use the press a button system.
```
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
```

### object: This field is used when you want to target all instances of a specific model. If you want to target a single specific object, you can use the `polyzone` feature:
- `model`: The model of the object to target.
- `icon`: The icon to display when targeting the object.
- `label`: The label to display when targeting the object.
- `location`: The locations where the object can be found. Each location is represented as a vector4 with the x, y, z coordinates and the heading.
- `ped`: This field is used when you want to target a specific ped. It has the same sub-fields as object, plus an additional target sub-field which works the same way as in useitem.
- `skill`: This field is used to specify the type of XP to use for the crafting XP. It's part of the metadata.
- `recipe`: This field is used to specify the recipe to use for the crafting bench.

### Code Snippet
- Example 3: In this example, we're targeting all objects of a specific model (prop_toolchest_01). This uses the AddTargetModel function, which sets the target to every single object with this model.
```
[3] = {
    object = {
        model = "prop_toolchest_01",
        icon = 'fas fa-tools',
        label = 'Crafting Bench - Using Model Target',
    },
    skill = 'craftingrep',
    recipe = 'default',
},
```
Example 4: In this example, we're targeting a specific object and placing a polyzone with a target on it. This is useful if you don't want all objects to have a target, but only a selected one or a couple.
```
[4] = {
    object = {
        icon = 'fas fa-tools',
        label = 'Crafting Bench - Setup Zone',
        location = {
            vector4(1091.72, 3072.62, 39.48, 190.16),
            vector4(1077.57, 3068.95, 39.79, 190.16)
        },
    },
    skill = 'craftingrep',
    recipe = 'default',
},
```

### ped: This field is used when you want to target a specific ped. It contains the following sub-fields:
- `target`: Set this to true to use the target system. If set to false or removed, the system will use the press a button system.
- `model`: The model of the ped.
- `icon`: The icon to display when targeting the ped.
- `label`: The label to display when targeting the ped.
- `location`: The coordinates where the ped is located. It's an array of vector4 objects, each representing a location.
- `skill`: This field is used to specify the type of XP to use for the crafting XP. It's part of the metadata.
- `recipe`: This field is used to specify the recipe to use for the crafting bench.

### Code Snippet
- Example 5: In this example, we're using a ped (A_M_Y_BusiCas_01) with the target system enabled (target = true).
```
[5] = {
    ped = {
        target = true,
        model = 'A_M_Y_BusiCas_01',
        icon = 'fas fa-tools',
        label = 'Crafting Bench - Using Ped Target',
        location = {
            vector4(1063.96, 3091.41, 41.06, 12.84),
            vector4(1076.11, 3095.08, 40.58, 96.96)
        },
    },
    skill = 'craftingrep',
    recipe = 'default',
},
```
- Example 6: In this example, we're using a ped (A_F_Y_Vinewood_04) without the target system.
```
[6] = {
    ped = {
        model = 'A_F_Y_Vinewood_04',
        location = {
            vector4(1066.29, 3079.34, 41.06, 5.99),
            vector4(1082.41, 3083.88, 40.41, 351.55)
        },
    },
    skill = 'craftingrep',
    recipe = 'default',
},
```

## Recipe Configuration

### Each recipe group is an object that contains one or more recipes. Each recipe is identified by a key (like lockpick or screwdriverset in the example) and has the following sub-fields:
- `required`: This field specifies the required level to craft the item. In the example, it's set to 0, meaning there's no level requirement.
- `reward`: This field specifies the amount of XP rewarded for crafting the item.
- `components`: This field is an object that lists the components required to craft the item. Each key in this object is the name of a component, and the corresponding value is the quantity required.

```
Config.Recipes = {
    default = {
        ['lockpick'] = {
            required = 0,
            reward = 1,
            components = {
                metalscrap = 22,
                plastic = 32
            }
        },
        ['screwdriverset'] = {
            required = 0,
            reward = 2,
            components = {
                metalscrap = 30,
                plastic = 42
            }
        },
    }
}
```

## Settings Configuration

- `ImageBasePath`: This is the base path of the inventory images. If you're using a different inventory, change this to the base path of the new inventory images.
- `TargetDistance`: This is the distance to target the crafting bench.
- `TargetIcon`: This is the icon to display when targeting the crafting bench.
- `Distance`: This is the distance to place the crafting bench on the ground.
- `Minigame`: This field enables or disables the skill check. If enabled, the player will have to complete a skill check to craft the item.
- `LostComponent`: This field enables or disables losing a component. If a player fails the skill check or cancels the progress bar, they will lose a component.
- `CraftingTime`: This field is an object that specifies the minimum and maximum time in milliseconds to craft the item, and whether the crafting time should be multiplied by the amount of items to craft.
- `DebugPoly`: This field enables or disables the debug poly for the crafting benches.
- `BoxZone`: This field is an object that specifies the length and width of the boxzone.

### Config.Minigame: 

- This function specifies the minigame to use for the skill check. It needs to return at least true when successful. In the example, it uses the 'easy' skillbar from the 'qb-minigames' module with '12345' as the argument.

```
Config.Settings = {
    ImageBasePath = "nui://qb-inventory/html/images/",
    TargetDistance = 2.5,
    TargetIcon = 'fas fa-tools',
    Distance = 2.0,
    Minigame = true,
    LostComponent = true,
    CraftingTime = {
        Min = 1000,
        Max = 2000,
        Multiplied = true
    },
    DebugPoly = true,
    BoxZone = {
        Length = 3.5,
        Width = 1.4,
    },
}

Config.Minigame = function()
    return exports['qb-minigames']:Skillbar('easy', '12345')
end
```

# License

    QBCore Framework
    Copyright (C) 2024 Joshua Eger

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>