class DropsHandler : EventHandler
{
    override void WorldThingDied(WorldEvent e) {
        // debug.print("Actor "..e.Thing.GetClassName().." died; max health is "..e.Thing.GetMaxHealth());
        if (DropsDecider.decideIfCreateDrop(e.Thing.GetMaxHealth())) {
            createDrop(e.Thing);
        }
    }

    const zvel = 10.0;
    private void createDrop(Actor dropper) {
        let whatToDrop = DropsDecider.dropArtifactOnly(dropper.GetMaxHealth()) ? rnd.weightedRand(0, 5, 5) : rnd.weightedRand(10, 5, 5);

        bool unused; // Required by zscript syntax for multiple returned values; is indeed unused
        Actor spawnedItem;

        if (whatToDrop == 0) { // drop one-time pickup

            dropper.A_SpawnItemEx('RwArmorBonus', zvel: zvel);

        } else if (whatToDrop == 1) { // drop weapon

            int dropType;
            if (GameDetector.isDoom1()) {
                // Exclude SSG
                dropType = rnd.weightedRand(25, 25, 0, 25, 10, 10);
            } else {
                dropType = rnd.weightedRand(25, 25, 15, 25, 10, 10);
            }

            switch (dropType) {
                case 0: 
                    [unused, spawnedItem] = dropper.A_SpawnItemEx('RwPistol', zvel: zvel);
                    break;
                case 1: 
                    [unused, spawnedItem] = dropper.A_SpawnItemEx('RwShotgun', zvel: zvel);
                    break;
                case 2: 
                    [unused, spawnedItem] = dropper.A_SpawnItemEx('RwSuperShotgun', zvel: zvel);
                    break;
                case 3: 
                    [unused, spawnedItem] = dropper.A_SpawnItemEx('RwChaingun', zvel: zvel);
                    break;
                case 4: 
                    [unused, spawnedItem] = dropper.A_SpawnItemEx('RwRocketLauncher', zvel: zvel);
                    break;
                case 5: 
                    [unused, spawnedItem] = dropper.A_SpawnItemEx('RwPlasmarifle', zvel: zvel);
                    break;
                default:
                    debug.panic("Drop spawner crashed");
            }

        } else if (whatToDrop == 2) { // Drop armor

            let dropType = rnd.weightedRand(10, 5);
            switch (dropType) {
                case 0: 
                    [unused, spawnedItem] = dropper.A_SpawnItemEx('RwGreenArmor', zvel: zvel);
                    break;
                case 1: 
                    [unused, spawnedItem] = dropper.A_SpawnItemEx('RwBlueArmor', zvel: zvel);
                    break;
                default:
                    debug.panic("Drop spawner crashed");
            }

        }
        // Generate stats/affixes for the spawned item.
        if (spawnedItem) {

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
        return;
    }
}