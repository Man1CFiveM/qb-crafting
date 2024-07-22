Config = {}
Config.Settings = {
    UseItem = false, -- Enable or disable the useable item, if enabled the player will have to use the item to open the crafting menu where it will place the crafting bench else use all the objects in the Config.Benches table
    Target = false, -- Enable or disable the target system, if enabled the player will have to target the crafting bench to open the crafting menu else press E to open the crafting menu
    TargetDistance = 2.5, -- Distance to target the crafting bench
    TargetIcon = 'fas fa-tools', -- Icon to display when targeting the crafting bench
    Minigame = true, -- Enable or disable the skill check, if enabled the player will have to complete a skill check to craft the item
    LostComponent = true, -- Enable or disable losing a component, if player fails the skill check or cancels the progresssbar they will lose a component
    ImageBasePath = "nui://qb-inventory/html/images/", -- When using a different inventory, change this to the base path of the inventory images
    CraftingTime = {
        Min = 1000, -- Minimum time in milliseconds to craft the item
        Max = 2000, -- Maximum time in milliseconds to craft the item
        Multiplied = true -- Enable or disable the multiplied crafting time, if enabled the crafting time will be multiplied by the amount of items to craft
    },
}

Config.Minigame = function() -- Minigame to use for the skill check, needs to return atleast a true when succesfull
    return exports['qb-minigames']:Skillbar('easy', '12345')
end

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
        ['electronickit'] = {
            required = 0,
            reward = 3,
            components = {
                metalscrap = 30,
                plastic = 45,
                aluminum = 28
            }
        },
        ['radioscanner'] = {
            required = 0,
            reward = 4,
            components = {
                electronickit = 2,
                plastic = 52,
                steel = 40
            }
        },
        ['gatecrack'] = {
            required = 110,
            reward = 5,
            components = {
                metalscrap = 10,
                plastic = 50,
                aluminum = 30,
                iron = 17,
                electronickit = 2
            }
        },
        ['handcuffs'] = {
            required = 160,
            reward = 6,
            components = {
                metalscrap = 36,
                steel = 24,
                aluminum = 28
            }
        },
        ['repairkit'] = {
            required = 200,
            reward = 7,
            components = {
                metalscrap = 32,
                steel = 43,
                plastic = 61
            }
        },
        ['pistol_ammo'] = {
            required = 250,
            reward = 8,
            components = {
                metalscrap = 50,
                steel = 37,
                copper = 26
            }
        },
        ['ironoxide'] = {
            required = 300,
            reward = 9,
            components = {
                iron = 60,
                glass = 30
            }
        },
        ['aluminumoxide'] = {
            required = 300,
            reward = 10,
            components = {
                aluminum = 60,
                glass = 30
            }
        },
        ['armor'] = {
            required = 350,
            reward = 11,
            components = {
                iron = 33,
                steel = 44,
                plastic = 55,
                aluminum = 22
            }
        },
        ['drill'] = {
            required = 1750,
            reward = 12,
            components = {
                iron = 50,
                steel = 50,
                screwdriverset = 3,
                advancedlockpick = 2
            }
        },
    },
    attachment = {
        ['clip_attachment'] = {
            required = 0,
            reward = 10,
            components = {
                metalscrap = 140,
                steel = 250,
                rubber = 60
            }
        },
        ['suppressor_attachment'] = {
            required = 0,
            reward = 10,
            components = {
                metalscrap = 165,
                steel = 285,
                rubber = 75
            }
        },
        ['drum_attachment'] =  {
            required = 0,
            reward = 10,
            components = {
                metalscrap = 230,
                steel = 365,
                rubber = 130
            }
        },
        ['smallscope_attachment'] = {
            required = 0,
            reward = 10,
            components = {
                metalscrap = 255,
                steel = 390,
                rubber = 145
            }
        },
    }
}

Config.Benches = {
    [1] = { -- item bench
        item = 'useableitemtoplaceitembench', -- item to use to open the crafting menu
        model = "prop_toolchest_05", -- object to use to open the crafting menu
        skill = 'craftingrep', -- xp type to use for the crafting xp. its part of the metadata
        recipes = 'default', -- recipes to use for the crafting bench
        locations = {
            vector3(-13.94, -1086.91, 26.67),
            vector3(-14.19, -1102.33, 26.67),
        } -- location of crafting bench for using press button. this can be ignored if Config.Settings.target is enabled
    },
    [2] = { -- attachment bench
        item = 'useableitemtoplaceattachmentbench',
        model = "prop_tool_bench02_ld",
        skill = 'attachmentcraftingrep',
        recipes = 'attachment',
        locations = {
            vector3(0, 0, 0)
        }
    },
}