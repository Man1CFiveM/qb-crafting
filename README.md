# qb-crafting

This is a crafting script for the QBCore Framework in FiveM. It allows players to craft items using resources in their inventory.

## Features

- Players can craft items using resources in their inventory.
- Crafting benches can be accessed in two ways: either by placing a workbench using an item, or by utilizing existing workbenches in the world.
- Either target or use key can be used to use the work bench
- Crafting recipes can be easily configured in the config.lua under the Config.Recipes section
- The crafting menu shows which items can be crafted based on the player's current inventory and skill level.

## Configuration Settings

Crafting recipes are defined in the `Config.Recipes` table in `config.lua`. Each recipe has a name, a list of required components, and a required skill level.

The behavior of the crafting system can be customized through the `Config.Settings` table in `config.lua`. Here's what each setting does:

- `UseItem`: If enabled, the player will have to use an item to open the crafting menu. If disabled, all objects in the `Config.Benches` table can be used to open the crafting menu.
- `Target`: If enabled, the player will have to target the crafting bench to open the crafting menu. If disabled, the crafting menu can be opened by pressing 'E'.
- `TargetDistance`: The maximum distance from which the crafting bench can be targeted.
- `TargetIcon`: The icon to display when targeting the crafting bench.
- `Minigame`: If enabled, the player will have to complete a skill check to craft the item.
- `LostComponent`: If enabled, the player will lose a component if they fail the skill check or cancel the progress bar.
- `ImageBasePath`: The base path of the inventory images. Change this if you're using a different inventory system.
- `CraftingTime`: The time it takes to craft an item. The `Min` and `Max` values are the minimum and maximum time in milliseconds, respectively. If `Multiplied` is enabled, the crafting time will be multiplied by the number of items to craft.

## Skill Check Minigame

The `Config.Minigame` function in `config.lua` determines the minigame that is used for the skill check when crafting an item. This function needs to return at least `true` when successful.
Currently, it is set to use the 'easy' skill bar minigame from the `qb-minigames` resource, with '12345' as the sequence to be matched.
You can replace this function with any minigame of your choice, as long as it returns `true` upon success.

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