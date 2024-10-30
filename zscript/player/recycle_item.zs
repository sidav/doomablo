extend class RwPlayer {

    mixin DropSpreadable;

    void tryRecycleCurrentTargetedItem() {

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
            debug.print("Unhandled recycled item class (report this): "..itm.GetClassName());
        }

        handler.currentItemToPickUp = null;
        itm.Destroy();

    }

    ui int getRecycleProgressPercentage() {
        return math.getPercentageFromInt(recycleItemButtonPressedTicks, ticksToRecycleItem);
    }

}