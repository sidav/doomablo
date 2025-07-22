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

    static play Actor SpawnRandomRWArtifactItemDrop(Actor dropper) {
        int dropType = rnd.weightedRand(6, 4, 3);
        switch (dropType) {
            case 0: 
                return SpawnRWeaponDrop(dropper);
            case 1: 
                return SpawnRArmorDrop(dropper);
            case 2:
                return SpawnREquipDrop(dropper); 
                // Backpacks and Flasks are currently merged into the same drop pool,
                // which doesn't matter for now because they have equal weights.
                // May become an issue if new equip slots are added.
            default:
                debug.panic("SpawnRandomRWArtifactItemDrop crashed");
        }
        return null;
    }

    private static play Actor SpawnRWeaponDrop(Actor dropper) {
        Actor spawnedItem;
        DropDatabaseHandler db = DropDatabaseHandler.Get();
        String spawnedClass = db.PickWeapon();
        spawnedItem = createDropByClass(dropper,spawnedClass);
        return spawnedItem;
    }

    private static play Actor SpawnRArmorDrop(Actor dropper) {
        Actor spawnedItem;
        DropDatabaseHandler db = DropDatabaseHandler.Get();
        String spawnedClass = db.PickArmor();
        spawnedItem = createDropByClass(dropper,spawnedClass);
        return spawnedItem;
    }

    // private static play Actor SpawnRBackpackDrop(Actor dropper) {
    //     return createDropByClass(dropper, RwBackpack.GetRandomVariantClass());
    // }
        // TODO: GetRandomVariantClass is no longer necessary
        // because subclasses of RwBackpack are added to the equipment pool
        // and have the same weights as normal backpacks.
        // It should probably be removed, maybe replaced with a more generic
        // 'item skins' system that can also be used for weapons and the like.

    // private static play Actor SpawnRFlaskDrop(Actor dropper) {
    //     let dropType = rnd.weightedRand(10, 10, 10);
    //     bool unused;
    //     Actor spawnedItem;
    //     switch (dropType) {
    //         case 0: 
    //             [unused, spawnedItem] = dropper.A_SpawnItemEx('RwSmallFlask');
    //             break;
    //         case 1: 
    //             [unused, spawnedItem] = dropper.A_SpawnItemEx('RwMediumFlask');
    //             break;
    //         case 2:
    //             [unused, spawnedItem] = dropper.A_SpawnItemEx('RwBigFlask');
    //             break;
    //         default:
    //             debug.panic("Drop spawner crashed");
    //     }
    //     return spawnedItem;
    // }

    private static play Actor SpawnREquipDrop(Actor dropper) {
        Actor spawnedItem;
        DropDatabaseHandler db = DropDatabaseHandler.Get();
        String spawnedClass = db.PickEquip();
        spawnedItem = createDropByClass(dropper,spawnedClass);
        return spawnedItem;
    }
}
