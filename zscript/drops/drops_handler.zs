class DropsHandler : EventHandler
{

    mixin AffixableGenerationHelperable;
    mixin DropSpreadable;

    override void WorldThingDied(WorldEvent e) {
        if (e.Thing is 'ExplosiveBarrel') {
            return;
        }
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
            spawnedItem = SpawnOneTimeItemDrop(dropper);
        } else if (whatToDrop == 1) { // drop weapon
            spawnedItem = SpawnRWeaponDrop(dropper);
        } else if (whatToDrop == 2) { // Drop armor
            spawnedItem = SpawnRArmorDrop(dropper);
        } else if (whatToDrop == 3) { // Drop backpack
            bool unused;
            [unused, spawnedItem] = dropper.A_SpawnItemEx(RwBackpack.GetRandomVariantClass());
        }

        if (spawnedItem) {            
            // Generate stats/affixes for the spawned item.
            if (AffixableDetector.IsAffixableItem(spawnedItem)) {

                int rarmod, qtymod;
                [rarmod, qtymod] = DropsDecider.rollRarQtyModifiers(dropper.GetMaxHealth());
                int rar, qty;
                [rar, qty] = DropsDecider.rollRarityAndQuality(rarmod, qtymod);

                GenerateAffixableItem(spawnedItem, rar, qty);
            }
        }
        AssignSpreadVelocityTo(spawnedItem); // Add random speed for the spawned item.
        return;
    }

    Actor SpawnOneTimeItemDrop(Actor dropper) {
        bool unused;
        Actor spawnedItem;
        int dropType;
        if (RwPlayer(Players[0].mo).ProgressionEnabled()) {
            dropType = rnd.weightedRand(100, 100, 50, 10);
        } else {
            // Don't drop progression items
            dropType = rnd.weightedRand(100, 100, 0, 0);
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

    static Actor SpawnRandomAmmoDrop(Actor dropper) {
        bool unused;
        Actor spawnedItem;
        int dropType = rnd.weightedRand(8, 10, 1, 4);
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
        // Randomly increase dropped ammo amount - not needed currently, there are new affixes for that
        // let invitem = Inventory(spawnedItem);
        // if (invitem) {
        //     invitem.amount = rnd.Rand(invitem.amount, 2*invitem.amount);
        //     return Actor(invitem);
        // }
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
}