class DropsSpawner {

    static play Actor createDropByClass(Actor dropper, class <Actor> whatToDrop) {
        bool unused; // Required by zscript syntax for multiple returned values; is indeed unused
        Actor spawnedItem;
        [unused, spawnedItem] = dropper.A_SpawnItemEx(whatToDrop);
        return spawnedItem;
    }

    static play Actor SpawnRandomOneTimeItemDrop(Actor dropper) {
        int dropType = rnd.weightedRand(500, 500, 100, 10, 7, 5, 3, 1, 10);
        switch (dropType) {
            case 0: 
                return createDropByClass(dropper, 'RwArmorBonus');
            case 1: 
                return createDropByClass(dropper, 'HealthBonus');
            case 2: 
                return createDropByClass(dropper, 'Stimpack');
            case 3:
                return createDropByClass(dropper, 'BlurSphere');
            case 4:
                return createDropByClass(dropper, 'SoulSphere');
            case 5:
                return createDropByClass(dropper, 'Berserk');
            case 6:
                return createDropByClass(dropper, 'MegaSphere');
            case 7:
                return createDropByClass(dropper, 'InvulnerabilitySphere');
            case 8:
                return createDropByClass(dropper, 'StatScroll');
            default:
                debug.panic("Random one-time item drop spawner crashed");
        }
        return null;
    }

    static play Actor SpawnRandomAmmoDrop(Actor dropper, int maxAmmoPercentage = 200) {
        int dropType = rnd.weightedRand(5, 5, 1, 2);
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
            invItem.amount = Random(invItem.amount, math.getIntPercentage(invItem.amount, maxAmmoPercentage));
        }
        return invItem;
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
        Actor spawnedItem;
        int dropType = rnd.weightedRand(
            5,  // Chainsaw
            25, // Pistol
            25, // Shotgun
            15, // SSG (it is supported in Doom 1 too)
            20, // Chaingun
            20, // SMG
            10, // Rocket Launcher
            10, // Plasma Rifle
            1,  // BFG
            1   // BFG-2704
        );
        switch (dropType) {
            case 0: 
                spawnedItem = createDropByClass(dropper, 'RwChainsaw');
                break;
            case 1: 
                spawnedItem = createDropByClass(dropper, 'RwPistol');
                break;
            case 2: 
                spawnedItem = createDropByClass(dropper, 'RwShotgun');
                break;
            case 3: 
                spawnedItem = createDropByClass(dropper, 'RwSuperShotgun');
                break;
            case 4: 
                spawnedItem = createDropByClass(dropper, 'RwChaingun');
                break;
            case 5:
                spawnedItem = createDropByClass(dropper, 'RwSmg');
                break;
            case 6: 
                spawnedItem = createDropByClass(dropper, 'RwRocketLauncher');
                break;
            case 7: 
                spawnedItem = createDropByClass(dropper, 'RwPlasmarifle');
                break;
            case 8:
                spawnedItem = createDropByClass(dropper, 'RwBFG');
                break;
            case 9:
                spawnedItem = createDropByClass(dropper, 'RwBFG2704');
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