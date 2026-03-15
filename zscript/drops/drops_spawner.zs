class DropsSpawner {

    static play Actor createDropByClass(Actor dropper, class <Actor> whatToDrop) {
        bool unused; // Required by zscript syntax for multiple returned values; is indeed unused
        Actor spawnedItem;
        [unused, spawnedItem] = dropper.A_SpawnItemEx(whatToDrop);
        return spawnedItem;
    }

    static play Actor SpawnRandomConsumableDrop(Actor dropper) {
        Actor itemDrop;
        DropDatabaseHandler db = DropDatabaseHandler.Get();
        String spawnedClass = db.PickConsumable();
        itemDrop = createDropByClass(dropper,spawnedClass);
        return itemDrop;
    }

    static play Actor SpawnRandomAmmoDrop(Actor dropper, int maxAmmoPercentage = 200) {
        Actor ammoDrop;
        DropDatabaseHandler db = DropDatabaseHandler.Get();
        String spawnedClass = db.PickAmmo();
        ammoDrop = createDropByClass(dropper,spawnedClass);

        // Randomly increase dropped ammo amount
        let invItem = Inventory(ammoDrop);
        if (invItem) {
            invItem.amount = Random(invItem.amount, math.getIntPercentage(invItem.amount, maxAmmoPercentage));
        }
        return invItem;
    }

    static play Actor SpawnRandomRWArtifactItemDrop(Actor dropper, bool preferUnique) {
        int dropType = rnd.weightedRand(6, 4, 3);
        switch (dropType) {
            case 0: 
                return SpawnRWeaponDrop(dropper, preferUnique);
            case 1: 
                return SpawnRArmorDrop(dropper, preferUnique);
            case 2:
                return SpawnREquipDrop(dropper, preferUnique); 
                // Backpacks and Flasks are currently merged into the same drop pool,
                // which doesn't matter for now because they have equal weights.
                // May become an issue if new equip slots are added.
            default:
                debug.panic("SpawnRandomRWArtifactItemDrop crashed");
        }
        return null;
    }

    private static play Actor SpawnRWeaponDrop(Actor dropper, bool preferUnique) {
        Actor spawnedItem;
        DropDatabaseHandler db = DropDatabaseHandler.Get();
        String spawnedClass = db.PickWeapon(preferUnique);
        spawnedItem = createDropByClass(dropper,spawnedClass);
        return spawnedItem;
    }

    private static play Actor SpawnRArmorDrop(Actor dropper, bool preferUnique) {
        Actor spawnedItem;
        DropDatabaseHandler db = DropDatabaseHandler.Get();
        String spawnedClass = db.PickArmor(preferUnique);
        spawnedItem = createDropByClass(dropper,spawnedClass);
        return spawnedItem;
    }

    private static play Actor SpawnREquipDrop(Actor dropper, bool preferUnique) {
        Actor spawnedItem;
        DropDatabaseHandler db = DropDatabaseHandler.Get();
        String spawnedClass = db.PickEquip(preferUnique);
        spawnedItem = createDropByClass(dropper,spawnedClass);
        return spawnedItem;
    }
}
