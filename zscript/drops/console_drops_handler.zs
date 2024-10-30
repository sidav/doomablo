// Defines console command "netevent spawn <item id> <rarity> <quality>"
// to be used instead of "summon <item>"
class ConsoleDropsHandler : EventHandler
{
    mixin AffixableGenerationHelperable;

    override void NetworkProcess(ConsoleEvent e) {
        if (e.Name == "spawn") {
            spawnItem(players[e.Player].mo, e.args[0], e.args[1], e.args[2]);
        }
    }

    const xofs = 50.0;
    const zvel = 10.0;
    static void spawnItem(Actor player, int itemID, int rarity, int quality) {

        bool unused; // Required by zscript syntax for multiple returned values; is indeed unused
        Actor spawnedItem;

        switch (itemID) {

            // Weapons
            case 2: 
                [unused, spawnedItem] = player.A_SpawnItemEx('RwPistol', xofs: xofs, zvel: zvel);
                break;
            case 3: 
                [unused, spawnedItem] = player.A_SpawnItemEx('RwShotgun', xofs: xofs, zvel: zvel);
                break;
            case 33: 
                [unused, spawnedItem] = player.A_SpawnItemEx('RwSuperShotgun', xofs: xofs, zvel: zvel);
                break;
            case 4: 
                [unused, spawnedItem] = player.A_SpawnItemEx('RwChaingun', xofs: xofs, zvel: zvel);
                break;
            case 44:
                [unused, spawnedItem] = player.A_SpawnItemEx('RwSmg', xofs: xofs, zvel: zvel);
                break;
            case 5: 
                [unused, spawnedItem] = player.A_SpawnItemEx('RwRocketLauncher', xofs: xofs, zvel: zvel);
                break;
            case 6: 
                [unused, spawnedItem] = player.A_SpawnItemEx('RwPlasmarifle', xofs: xofs, zvel: zvel);
                break;
            
            // Armors
            case 10: 
                [unused, spawnedItem] = player.A_SpawnItemEx('RwGreenArmor', xofs: xofs, zvel: zvel);
                break;
            case 11:
                [unused, spawnedItem] = player.A_SpawnItemEx('RwBlueArmor', xofs: xofs, zvel: zvel);
                break;
            case 12:
                [unused, spawnedItem] = player.A_SpawnItemEx('RwEnergyArmor', xofs: xofs, zvel: zvel);
                break;

            // Backpack
            case 20: 
                [unused, spawnedItem] = player.A_SpawnItemEx(RwBackpack.GetRandomVariantClass(), xofs: xofs, zvel: zvel);
                break;
            
            default:
                debug.print("Unknown drop code "..itemID);
        }

        if (spawnedItem) {

            if (rarity == 0) {
                [rarity, quality] = DropsDecider.rollRarityAndQuality(0, 0);
            } else if (quality == 0) {
                quality = rnd.Rand(1, 100);
            }

            GenerateAffixableItem(spawnedItem, rarity, quality);
        }
    }
}