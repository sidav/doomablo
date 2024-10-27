class DropsSpawner {

    static play Actor createDropByClass(Actor dropper, class <Actor> whatToDrop) {
        bool unused;
        Actor spawnedItem;
        [unused, spawnedItem] = dropper.A_SpawnItemEx(whatToDrop);
        return spawnedItem;
    }

    static play Actor SpawnRandomOneTimeItemDrop(Actor dropper) {
        int dropType = rnd.weightedRand(3, 2, 1);
        switch (dropType) {
            case 0: 
                return createDropByClass(dropper, 'RwArmorBonus');
            case 1: 
                return createDropByClass(dropper, 'HealthBonus');
            case 2: 
                return createDropByClass(dropper, 'Stimpack');
            default:
                debug.panic("Ammo random drop spawner crashed");
        }
        return null;
    }

    static play Actor SpawnRandomAmmoDrop(Actor dropper) {
        int dropType = rnd.weightedRand(8, 10, 1, 4);
        Actor ammoDrop;
        switch (dropType) {
            case 0: 
                ammoDrop = createDropByClass(dropper, 'Clip');
                break;
            case 1: 
                ammoDrop = createDropByClass(dropper, 'Shell');
                break;
            case 2: 
                ammoDrop = createDropByClass(dropper, 'RocketAmmo');
                break;
            case 3:
                ammoDrop = createDropByClass(dropper, 'Cell');
                break;
            default:
                debug.panic("Ammo random drop spawner crashed");
        }
        // Randomly increase dropped ammo amount
        let invItem = Inventory(ammoDrop);
        if (invItem) {
            invItem.amount = Random(invItem.amount, 2*invItem.amount);
        }
        return invItem;
    }

    static play Actor SpawnRandomProgressionItemDrop(Actor dropper) {
        int dropType = rnd.weightedRand(3, 1);
        if (dropType == 1) {
            return createDropByClass(dropper, 'RwMinqItem');
        }
        return createDropByClass(dropper, 'RwMaxqItem');
    }

    static play Actor SpawnRandomRWArtifactItemDrop(Actor dropper) {
        int dropType = rnd.weightedRand(3, 2, 1);
        switch (dropType) {
            case 0: 
                return SpawnRWeaponDrop(dropper);
            case 1: 
                return SpawnRArmorDrop(dropper);
            case 2: 
                return SpawnRBackpackDrop(dropper);
            default:
                debug.panic("SpawnRandomRWArtifactItemDrop crashed");
        }
        return null;
    }

    private static play Actor SpawnRWeaponDrop(Actor dropper) {
        bool unused;
        Actor spawnedItem;
        int dropType = rnd.weightedRand(25, 25, 15, 25, 10, 10); // SSG is supported even in Doom 1 now.
        switch (dropType) {
            case 0: 
                [unused, spawnedItem] = dropper.A_SpawnItemEx('RwPistol');
                break;
            case 1: 
                [unused, spawnedItem] = dropper.A_SpawnItemEx('RwShotgun');
                break;
            case 2: 
                [unused, spawnedItem] = dropper.A_SpawnItemEx('RwSuperShotgun');
                break;
            case 3: 
                [unused, spawnedItem] = dropper.A_SpawnItemEx('RwChaingun');
                break;
            case 4: 
                [unused, spawnedItem] = dropper.A_SpawnItemEx('RwRocketLauncher');
                break;
            case 5: 
                [unused, spawnedItem] = dropper.A_SpawnItemEx('RwPlasmarifle');
                break;
            default:
                debug.panic("RWeapon drop spawner crashed");
        }
        return spawnedItem;
    }

    private static play Actor SpawnRArmorDrop(Actor dropper) {
        bool unused;
        Actor spawnedItem;
        let dropType = rnd.weightedRand(10, 10, 5);
        switch (dropType) {
            case 0: 
                [unused, spawnedItem] = dropper.A_SpawnItemEx('RwGreenArmor');
                break;
            case 1: 
                [unused, spawnedItem] = dropper.A_SpawnItemEx('RwBlueArmor');
                break;
            case 2:
                [unused, spawnedItem] = dropper.A_SpawnItemEx('RwEnergyArmor');
                break;
            default:
                debug.panic("Drop spawner crashed");
        }
        return spawnedItem;
    }

    private static play Actor SpawnRBackpackDrop(Actor dropper) {
        return createDropByClass(dropper, RwBackpack.GetRandomVariantClass());
    }
}