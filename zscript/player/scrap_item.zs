extend class RwPlayer {

    mixin DropSpreadable;

    const ticksToScrapItem = 3*TICRATE/2;
    Inventory currentItemBeingScrapped;

    void onScrapItemButtonPressed() {
        if (scrapItemButtonPressedTicks == 1) { // Save current targeted item
            let handler = PressToPickupHandler(EventHandler.Find('PressToPickupHandler'));
            currentItemBeingScrapped = handler.currentItemToPickUp;

        } else if (scrapItemButtonPressedTicks % 7 == 0) { // Check if the targeted item is still the one being scrapped
            let handler = PressToPickupHandler(EventHandler.Find('PressToPickupHandler'));
            if (handler.currentItemToPickUp == null || handler.currentItemToPickUp != currentItemBeingScrapped) {
                // ... if not, reset the progress
                scrapItemButtonPressedTicks = 1;
                currentItemBeingScrapped = null;
                return;
            }
        }
        scrapItemButtonPressedTicks++;

        if (scrapItemButtonPressedTicks % ticksToScrapItem == 0) {
            tryScrapCurrentTargetedItem();
            scrapItemButtonPressedTicks = 0;
        }
    }

    void tryScrapCurrentTargetedItem() {
        let handler = PressToPickupHandler(EventHandler.Find('PressToPickupHandler'));
        let itm = handler.currentItemToPickUp;

        if (itm == null || !AffixableDetector.IsAffixableItem(itm) || itm.owner) {
            return;
        }

        if (itm is 'RandomizedWeapon') {

            let dropAmount = RandomizedWeapon(itm).GetRarity() + 1;
            for (let i = 0; i < dropAmount; i++) {
                let drop = DropsSpawner.createDropByClass(itm, RandomizedWeapon(itm).ammotype1);
                AssignVeryMinorSpreadVelocityTo(drop);
            }

        } else if (itm is 'RandomizedArmor') {

            let dropAmount = RandomizedArmor(itm).GetRarity() + 1;
            for (let i = 0; i < dropAmount; i++) {
                Actor drop;
                if (RandomizedArmor(itm).stats.IsEnergyArmor() && rnd.OneChanceFrom(2)) {
                    drop = DropsSpawner.createDropByClass(itm, 'Cell');
                } else {
                    drop = DropsSpawner.createDropByClass(itm, 'RwArmorBonus');
                }
                AssignVeryMinorSpreadVelocityTo(drop);
            }

        } else if (itm is 'RwBackpack') {

            let dropAmount = RwBackpack(itm).GetRarity() + 1;
            for (let i = 0; i < dropAmount; i++) {
                Actor drop;
                let whatToDrop = rnd.weightedRand(3, 1);
                if (whatToDrop == 0) {
                    drop = DropsSpawner.SpawnRandomAmmoDrop(itm);
                } else {
                    drop = DropsSpawner.SpawnRandomOneTimeItemDrop(itm);
                }
                AssignVeryMinorSpreadVelocityTo(drop);
            }

        } else {
            debug.print("Unhandled scrapped item class (report this): "..itm.GetClassName());
        }

        handler.currentItemToPickUp = null;
        itm.Destroy();

    }

    ui int getScrapProgressPercentage() {
        return math.getPercentageFromInt(scrapItemButtonPressedTicks, ticksToScrapItem);
    }

}