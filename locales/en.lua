local Translations = {
    menus = {
        header = 'Crafting Menu',
        entercraftAmount = 'Enter Craft Amount:',
    },
    target = {
        pickupStation = 'Pick up Workbench',
    },
    notifications = {
        pickupStation = 'You have picked up the workbench.',
        invalidAmount = 'Invalid Amount Entered',
        invalidInput = 'Invalid Input Entered',
        notenoughMaterials = "You don't have enough materials!",
        craftingCancelled = 'You cancelled the crafting',
        craftingFailed = 'Crafting failed, some materials have been lost!',
        tablePlace = 'Your Crafting Table was placed',
        craftMessage = 'You have crafted a %s',
        xpGain = 'You have gained %d XP in %s',
    },
    commands = {
        checkXp = 'Check your XP : ',
    },
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
