Config.Recipes = {
    default = {
        ['lockpick'] = {
            required = 0,
            reward = 1,
            jobNeeded = 'none', -- none or job name or gang name
            jobGrade = 0, -- only works if jobNeeded is not 'none'
            components = {
                metalscrap = 22,
                plastic = 32
            }
        },
        ['screwdriverset'] = {
            required = 0,
            reward = 2,
            jobNeeded = 'mechanic', -- job example
            jobGrade = 1,
            components = {
                metalscrap = 30,
                plastic = 42
            }
        },
        ['electronickit'] = {
            required = 0,
            reward = 3,
            jobNeeded = 'lostmc', -- gang example
            jobGrade = 2,
            components = {
                metalscrap = 30,
                plastic = 45,
                aluminum = 28
            }
        },
        ['radioscanner'] = {
            required = 0,
            reward = 4,
            jobNeeded = 'none',
            jobGrade = 0,
            components = {
                electronickit = 2,
                plastic = 52,
                steel = 40
            }
        },
        ['gatecrack'] = {
            required = 10,
            reward = 5,
            jobNeeded = 'none',
            jobGrade = 0,
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
            jobNeeded = 'none',
            jobGrade = 0,
            components = {
                metalscrap = 36,
                steel = 24,
                aluminum = 28
            }
        },
        ['repairkit'] = {
            required = 200,
            reward = 7,
            jobNeeded = 'none',
            jobGrade = 0,
            components = {
                metalscrap = 32,
                steel = 43,
                plastic = 61
            }
        },
        ['pistol_ammo'] = {
            required = 250,
            reward = 8,
            jobNeeded = 'none',
            jobGrade = 0,
            components = {
                metalscrap = 50,
                steel = 37,
                copper = 26
            }
        },
        ['ironoxide'] = {
            required = 300,
            reward = 9,
            jobNeeded = 'none',
            jobGrade = 0,
            components = {
                iron = 60,
                glass = 30
            }
        },
        ['aluminumoxide'] = {
            required = 300,
            reward = 10,
            jobNeeded = 'none',
            jobGrade = 0,
            components = {
                aluminum = 60,
                glass = 30
            }
        },
        ['armor'] = {
            required = 350,
            reward = 11,
            jobNeeded = 'none',
            jobGrade = 0,
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
            jobNeeded = 'none',
            jobGrade = 0,
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
            jobNeeded = 'none',
            jobGrade = 0,
            components = {
                metalscrap = 140,
                steel = 250,
                rubber = 60
            }
        },
        ['suppressor_attachment'] = {
            required = 0,
            reward = 10,
            jobNeeded = 'none',
            jobGrade = 0,
            components = {
                metalscrap = 165,
                steel = 285,
                rubber = 75
            }
        },
        ['drum_attachment'] =  {
            required = 0,
            reward = 10,
            jobNeeded = 'none',
            jobGrade = 0,
            components = {
                metalscrap = 230,
                steel = 365,
                rubber = 130
            }
        },
        ['smallscope_attachment'] = {
            required = 0,
            reward = 10,
            jobNeeded = 'none',
            jobGrade = 0,
            components = {
                metalscrap = 255,
                steel = 390,
                rubber = 145
            }
        },
    }
}
