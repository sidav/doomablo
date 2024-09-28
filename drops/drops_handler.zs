class DropsHandler : EventHandler
{
    override void WorldThingDied(WorldEvent e) {
        if (rnd.OneChanceFrom(5)) {
            createDrop(e.Thing);
        }
    }

    const zvel = 10.0;
    private void createDrop(Actor dropper) {
        let whatToDrop = rnd.weightedRand(10, 5, 5);

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

            let rar = DropQualityDecider.decideRarity();
			let qty = DropQualityDecider.decideQuality();

            if (spawnedItem is 'RandomizedWeapon') {
                RandomizedWeapon(spawnedItem).Generate(rar, qty);
            } else if (spawnedItem is 'RandomizedArmor') {
                RandomizedArmor(spawnedItem).Generate(rar, qty);
            }
        }
        return;
    }
}