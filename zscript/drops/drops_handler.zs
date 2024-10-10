class DropsHandler : EventHandler
{

    bool progressionEnabled;

    override void OnRegister() {
        progressionEnabled = CVar.GetCVar('rw_progression_enabled', null).GetBool();
    }

    override void WorldThingDied(WorldEvent e) {
        // debug.print("Actor "..e.Thing.GetClassName().." died; max health is "..e.Thing.GetMaxHealth());
        let dropsCount = DropsDecider.decideDropsCount(e.Thing.GetMaxHealth());
        for (let i = 0; i < dropsCount; i++) {
            createDrop(e.Thing);
        }
    }

    private void createDrop(Actor dropper) {
        let whatToDrop = DropsDecider.whatToDrop(dropper.GetMaxHealth());

        bool unused; // Required by zscript syntax for multiple returned values; is indeed unused
        Actor spawnedItem;

        if (whatToDrop == 0) { // drop one-time pickup
            SpawnOneTimeItemDrop(dropper);
        } else if (whatToDrop == 1) { // drop weapon
            spawnedItem = SpawnRWeaponDrop(dropper);
        } else if (whatToDrop == 2) { // Drop armor
            spawnedItem = SpawnRArmorDrop(dropper);
        }

        if (spawnedItem) {
            // Add random speed for the spawned item.
            spawnedItem.Vel3DFromAngle(rnd.randf(8.0, 10.0), rnd.randf(1.0, 360.0), rnd.randf(-80.0, -60.0));
            // Generate stats/affixes for the spawned item.
            if (RandomizedWeapon(spawnedItem) || RandomizedArmor(spawnedItem)) {

                int rarmod, qtymod;
                [rarmod, qtymod] = DropsDecider.rollRarQtyModifiers(dropper.GetMaxHealth());
                int rar, qty;
                [rar, qty] = DropsDecider.rollRarityAndQuality(rarmod, qtymod);

                if (spawnedItem is 'RandomizedWeapon') {
                    RandomizedWeapon(spawnedItem).Generate(rar, qty);
                } else if (spawnedItem is 'RandomizedArmor') {
                    RandomizedArmor(spawnedItem).Generate(rar, qty);
                }
            }
        }
        return;
    }

    Actor SpawnOneTimeItemDrop(Actor dropper) {
        bool unused;
        Actor spawnedItem;
        int dropType;
        if (progressionEnabled) {
            dropType = rnd.weightedRand(80, 100, 50, 10);
        } else {
            // Don't drop progression items
            dropType = rnd.weightedRand(80, 100, 0, 0);
        }
        switch (dropType) {
            case 0: 
            [unused, spawnedItem] = dropper.A_SpawnItemEx('RwArmorBonus');
                break;
            case 1:
            spawnedItem = SpawnRandomAmmoDrop(dropper);
                break;
            case 2:
            [unused, spawnedItem] = dropper.A_SpawnItemEx('RwMaxqItem');
                break;
            case 3: 
            [unused, spawnedItem] = dropper.A_SpawnItemEx('RwMinqItem');
                break;
            default:
                debug.panic("One-time item drop spawner crashed");
        }
        return spawnedItem;
    }

    Actor SpawnRandomAmmoDrop(Actor dropper) {
        bool unused;
        Actor spawnedItem;
        int dropType = rnd.weightedRand(10, 10, 1, 5);
        switch (dropType) {
            case 0: 
                [unused, spawnedItem] = dropper.A_SpawnItemEx('Clip');
                break;
            case 1: 
                [unused, spawnedItem] = dropper.A_SpawnItemEx('Shell');
                break;
            case 2: 
                [unused, spawnedItem] = dropper.A_SpawnItemEx('RocketAmmo');
                break;
            case 3:
                [unused, spawnedItem] = dropper.A_SpawnItemEx('Cell');
                break;
            default:
                debug.panic("Ammo random drop spawner crashed");
        }
        return spawnedItem;
    }

    Actor SpawnRWeaponDrop(Actor dropper) {
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

    Actor SpawnRArmorDrop(Actor dropper) {
        bool unused;
        Actor spawnedItem;
        let dropType = rnd.weightedRand(10, 5);
        switch (dropType) {
            case 0: 
                [unused, spawnedItem] = dropper.A_SpawnItemEx('RwGreenArmor');
                break;
            case 1: 
                [unused, spawnedItem] = dropper.A_SpawnItemEx('RwBlueArmor');
                break;
            default:
                debug.panic("Drop spawner crashed");
        }
        return spawnedItem;
    }
}