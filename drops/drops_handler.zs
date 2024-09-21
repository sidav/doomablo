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
        if (whatToDrop == 0) { // drop one-time pickup

            dropper.A_SpawnItemEx('RwArmorBonus', zvel: zvel);

        } else if (whatToDrop == 1) { // drop weapon

            let dropType = rnd.weightedRand(25, 25, 15, 25, 10, 10);
            switch (dropType) {
                case 0: 
                    dropper.A_SpawnItemEx('RwPistol', zvel: zvel);
                    break;
                case 1: 
                    dropper.A_SpawnItemEx('RwShotgun', zvel: zvel);
                    break;
                case 2: 
                    dropper.A_SpawnItemEx('RwSuperShotgun', zvel: zvel);
                    break;
                case 3: 
                    dropper.A_SpawnItemEx('RwChaingun', zvel: zvel);
                    break;
                case 4: 
                    dropper.A_SpawnItemEx('RwRocketLauncher', zvel: zvel);
                    break;
                case 5: 
                    dropper.A_SpawnItemEx('RwPlasmarifle', zvel: zvel);
                    break;
                default:
                    debug.panic("Drop spawner crashed");
            }

        } else if (whatToDrop == 2) { // Drop armor

            let dropType = rnd.weightedRand(10, 5);
            switch (dropType) {
                case 0: 
                    dropper.A_SpawnItemEx('RwGreenArmor', zvel: zvel);
                    break;
                case 1: 
                    dropper.A_SpawnItemEx('RwBlueArmor', zvel: zvel);
                    break;
                default:
                    debug.panic("Drop spawner crashed");
            }

        }
        return;
    }
}