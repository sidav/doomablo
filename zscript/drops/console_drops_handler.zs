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
            case 1: 
                [unused, spawnedItem] = player.A_SpawnItemEx('RwChainsaw', xofs: xofs, zvel: zvel);
                break;
            case 2: 
                [unused, spawnedItem] = player.A_SpawnItemEx('RwPistol', xofs: xofs, zvel: zvel);
                break;
            case 22: 
                [unused, spawnedItem] = player.A_SpawnItemEx('RwRevolver', xofs: xofs, zvel: zvel);
                break;
            case 3: 
                [unused, spawnedItem] = player.A_SpawnItemEx('RwShotgun', xofs: xofs, zvel: zvel);
                break;
            case 33: 
                [unused, spawnedItem] = player.A_SpawnItemEx('RwSuperShotgun', xofs: xofs, zvel: zvel);
                break;
            case 333: 
                [unused, spawnedItem] = player.A_SpawnItemEx('RwAutoShotgun', xofs: xofs, zvel: zvel);
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
            case 55: 
                [unused, spawnedItem] = player.A_SpawnItemEx('RwGrenadeLauncher', xofs: xofs, zvel: zvel);
                break;
            case 6: 
                [unused, spawnedItem] = player.A_SpawnItemEx('RwPlasmarifle', xofs: xofs, zvel: zvel);
                break;
            case 66: 
                [unused, spawnedItem] = player.A_SpawnItemEx('RwRailgun', xofs: xofs, zvel: zvel);
                break;
            case 7:
                [unused, spawnedItem] = player.A_SpawnItemEx('RwBfg', xofs: xofs, zvel: zvel);
                break;
            case 77:
                [unused, spawnedItem] = player.A_SpawnItemEx('RwBfg2704', xofs: xofs, zvel: zvel);
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
            
            // Flask
            case 30:
                [unused, spawnedItem] = player.A_SpawnItemEx('RwSmallFlask', xofs: xofs, zvel: zvel);
                break;
            case 31:
                [unused, spawnedItem] = player.A_SpawnItemEx('RwMediumFlask', xofs: xofs, zvel: zvel);
                break;
            case 32:
                [unused, spawnedItem] = player.A_SpawnItemEx('RwBigFlask', xofs: xofs, zvel: zvel);
                break;
            
            // Turret spawner
            case 40:
                [unused, spawnedItem] = player.A_SpawnItemEx('RwTurretItem', xofs: xofs, zvel: zvel);
                break;

            // Progression items. "Rarity" holds the amount of them to spawn
            case 100:
                for (let i = 0; i < rarity; i++) {
                    [unused, spawnedItem] = player.A_SpawnItemEx('InfernoBook', xofs: xofs, zvel: zvel);
                }
                return; // We don't need to generate it
            case 101:
                for (let i = 0; i < rarity; i++) {
                    [unused, spawnedItem] = player.A_SpawnItemEx('InfernoSigil', xofs: xofs, zvel: zvel);
                }
                return; // We don't need to generate it
            // Give exp
            case 200:
                if (rarity == 0) {
                    rarity = 1;
                }
                for (let i = 0; i < rarity; i++) {
                    RwPlayer(player).receiveExperience(RwPlayer(player).stats.getRequiredXPForNextLevel());
                }
                return;
            case 201:
                RwPlayer(player).infernoLevel += rarity;
                return;
            

            default:
                debug.print("Unknown drop code "..itemID);
        }

        if (spawnedItem) {

            if (rarity == -1) {
                [rarity, quality] = DropsDecider.rollRarityAndQuality(0, 0);
            } else if (quality == 0) {
                quality = rnd.Rand(1, 100);
            }

            GenerateAffixableItem(spawnedItem, rarity, quality);
        }
    }
}