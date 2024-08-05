# qb-crafting
This is a crafting script for the QBCore Framework in FiveM. It allows players to craft items using resources in their inventory.

## Features

- **Crafting System**: Players can craft items using resources in their inventory. The crafting process is interactive and requires player engagement.
- **Configurable**: All settings and crafting recipes are easily configurable in the `Config.Settings` and `Config.Recipes` tables.
- **Crafting Recipes**: Crafting recipes are defined in the `config\recipe.lua` file. Each recipe includes a name, a list of required components, and a required skill level.
- **Crafting Benches**: Players can craft items at crafting benches. These can be placed using an item or found at various locations in the world.
- **Interaction**: Players can interact with the crafting bench either by targeting it or using a key press.
- **Crafting Menu**: The crafting menu displays which items can be crafted based on the player's current inventory and skill level. This provides a clear and intuitive interface for crafting.
- **Skill Check Minigame**: The crafting process includes a skill check minigame, adding an extra layer of challenge and engagement.
- **Component Loss**: If a player fails the skill check or cancels the crafting process, they risk losing a component, adding a risk-reward element to crafting.

## Config.Settings

- `ImageBasePath`: The base path of the inventory images. Change this if you're using a different inventory.
- `TargetDistance`: The distance at which the crafting bench can be targeted.
- `TargetIcon`: The icon to display when targeting the crafting bench.
- `Distance`: The distance to place the crafting bench on the ground.
- `Minigame`: Enable or disable the skill check. If enabled, the player will have to complete a skill check to craft the item.
- `LostComponent`: Enable or disable losing a component. If the player fails the skill check or cancels the progress bar, they will lose a component.
- `CraftingTime`: The time it takes to craft an item.
  - `Min`: The minimum time in milliseconds to craft the item.
  - `Max`: The maximum time in milliseconds to craft the item.
  - `Multiplied`: Enable or disable the multiplied crafting time. If enabled, the crafting time will be multiplied by the amount of items to craft.
- `DebugPoly`: Enable or disable the debug poly for the crafting benches.
- `BoxZone`: The dimensions of the box zone for the crafting benches.
  - `Length`: The length of the box zone.
  - `Width`: The width of the box zone.

## Config.Minigame

This function is used to specify the minigame for the skill check. It needs to return at least `true` when successful. The current configuration uses the 'easy' skill bar from the 'qb-minigames' module.

Config.Minigame = function()
    return exports['qb-minigames']:Skillbar('easy', '12345')
end

## Commands

The command checkxp will return every reputation you have and its total xp on it

```
/checkxp
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