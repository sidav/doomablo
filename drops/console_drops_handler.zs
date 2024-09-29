// Defines console command "netevent spawn <item id> <rarity> <quality>"
// to be used instead of "summon <item>"
class ConsoleDropsHandler : EventHandler
{
    override void NetworkProcess(ConsoleEvent e) {
        if (e.Name == "spawn") {
            spawnItem(players[e.Player].mo, e.args[0], e.args[1], e.args[2]);
        }
    }

    const xofs = 50.0;
    const zvel = 10.0;
    static void spawnItem(Actor player, int whichItem, int rarity, int quality) {

        bool unused; // Required by zscript syntax for multiple returned values; is indeed unused
        Actor spawnedItem;

        switch (whichItem) {

            // Weapons
            case 2: 
                [unused, spawnedItem] = player.A_SpawnItemEx('RwPistol', xofs: xofs, zvel: zvel);
                break;
            case 3: 
                [unused, spawnedItem] = player.A_SpawnItemEx('RwShotgun', xofs: xofs, zvel: zvel);
                break;
            case 4: 
                [unused, spawnedItem] = player.A_SpawnItemEx('RwSuperShotgun', xofs: xofs, zvel: zvel);
                break;
            case 5: 
                [unused, spawnedItem] = player.A_SpawnItemEx('RwChaingun', xofs: xofs, zvel: zvel);
                break;
            case 6: 
                [unused, spawnedItem] = player.A_SpawnItemEx('RwRocketLauncher', xofs: xofs, zvel: zvel);
                break;
            case 7: 
                [unused, spawnedItem] = player.A_SpawnItemEx('RwPlasmarifle', xofs: xofs, zvel: zvel);
                break;
            
            // Armors
            case 10: 
                [unused, spawnedItem] = player.A_SpawnItemEx('RwGreenArmor', xofs: xofs, zvel: zvel);
                break;
            case 11:
                [unused, spawnedItem] = player.A_SpawnItemEx('RwBlueArmor', xofs: xofs, zvel: zvel);
                break;
            
            default:
                debug.print("Unknown drop code "..whichItem);
        }

        if (spawnedItem) {

            if (rarity == 0) {
                [rarity, quality] = DropsDecider.rollRarityAndQuality(0, 0);
            } else if (quality == 0) {
                quality = rnd.Rand(1, 100);
            }

            if (spawnedItem is 'RandomizedWeapon') {
                RandomizedWeapon(spawnedItem).Generate(rarity, quality);
            } else if (spawnedItem is 'RandomizedArmor') {
                RandomizedArmor(spawnedItem).Generate(rarity, quality);
            }
        }
    }
}