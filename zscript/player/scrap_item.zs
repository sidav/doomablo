extend class RwPlayer {

    mixin DropSpreadable;
    Inventory currentItemBeingScrapped;

    void onScrapItemButtonPressed() {
        if (scrapItemButtonPressedTicks == 1) { // Save current targeted item
            currentItemBeingScrapped = PressToPickupHandler.GetItemUnderCrosshair();

        } else if (scrapItemButtonPressedTicks % 7 == 0) { // Check if the targeted item is still the one being scrapped
            let itm = PressToPickupHandler.GetItemUnderCrosshair();
            if (itm == null || itm != currentItemBeingScrapped) {
                // ... if not, reset the progress
                scrapItemButtonPressedTicks = 1;
                currentItemBeingScrapped = null;
                return;
            }
        }
        scrapItemButtonPressedTicks++;

        if (scrapItemButtonPressedTicks % ticksToScrapItem() == 0) {
            tryScrapCurrentTargetedItem();
            scrapItemButtonPressedTicks = 0;
        }
    }

    void tryScrapCurrentTargetedItem() {
        let itm = PressToPickupHandler.GetItemUnderCrosshair();

        if (itm == null || !AffixableDetector.IsAffixableItem(itm) || itm.owner) {
            return;
        }

        if (itm is 'RandomizedWeapon') {

            let dropAmount = RandomizedWeapon(itm).GetRarity() + 1;
            for (let i = 0; i < dropAmount; i++) {
                Actor drop;
                if (RandomizedWeapon(itm).ammotype1) {
                    drop = DropsSpawner.createDropByClass(itm, RandomizedWeapon(itm).ammotype1);
                } else {
                    drop = DropsSpawner.SpawnRandomAmmoDrop(itm);
                }
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
                    drop = DropsSpawner.SpawnRandomConsumableDrop(itm);
                }
                AssignVeryMinorSpreadVelocityTo(drop);
            }

        } else if (itm is 'RwFlask') {

            let dropAmount = RwFlask(itm).GetRarity() + 2;
            for (let i = 0; i < dropAmount; i++) {
                Actor drop;
                let whatToDrop = rnd.weightedRand(1, 2);
                if (whatToDrop == 0) {
                    drop = DropsSpawner.createDropByClass(itm, 'RwFlaskRefill');
                } else {
                    drop = DropsSpawner.createDropByClass(itm, 'HealthBonus');
                }
                AssignVeryMinorSpreadVelocityTo(drop);
            }
            // Drop guaranteed refills if scrapped flask has charges
            int chgPerRefill = 8;
            dropAmount = (RwFlask(itm).currentCharges + chgPerRefill / 2) / chgPerRefill;
            for (let i = 0; i < dropAmount; i++) {
                Actor drop = DropsSpawner.createDropByClass(itm, 'RwFlaskRefill');
                Inventory(drop).Amount = chgPerRefill;
                AssignVeryMinorSpreadVelocityTo(drop);
            }

        } else {
            debug.print("Unhandled scrapped item class (report this): "..itm.GetClassName());
        }

        let handler = PressToPickupHandler(EventHandler.Find('PressToPickupHandler'));
        handler.currentItemToPickUp = null;
        itm.Destroy();

    }

    clearscope static int ticksToScrapItem() {
        return int(double(TICRATE) * rw_settings_scrapping_time + 0.5);
    }

    ui int getScrapProgressPercentage() {
        return math.getIntFractionInPercent(scrapItemButtonPressedTicks, ticksToScrapItem());
    }

}