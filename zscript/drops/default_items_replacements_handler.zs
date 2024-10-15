// Handles the replacement of default weapons/items. 
class DefaultItemsToRWCounterpartsReplacementHandler : EventHandler
{
	mixin AffixableGenerationHelperable;

	override void CheckReplacement(ReplaceEvent e)
	{
		let cls = e.Replacee.GetClassName();
		int dropType;
        switch (cls) {

		// WEAPONS
		case 'Chainsaw':
			dropType = rnd.weightedRand(0, 25, 0, 25, 1, 1);
			switch (dropType) {
                case 0: 
                    e.Replacement ='RwPistol';
                    break;
                case 1: 
                    e.Replacement ='RwShotgun';
                    break;
                case 2: 
                    e.Replacement ='RwSuperShotgun';
                    break;
                case 3: 
                    e.Replacement ='RwChaingun';
                    break;
                case 4: 
                    e.Replacement ='RwRocketLauncher';
                    break;
                case 5: 
                    e.Replacement ='RwPlasmarifle';
                    break;
                default:
                    debug.panic("Chainsaw replacer crashed");
            }
			break;
		case 'Pistol':
			e.Replacement = 'rwPistol';
            break;
		case 'Shotgun':
			e.Replacement = 'rwShotgun';
            break;
		case 'SuperShotgun':
			e.Replacement = 'rwSuperShotgun';
            break;
		case 'Chaingun':
			e.Replacement = 'rwChaingun';
            break;
		case 'Rocketlauncher':
			e.Replacement = 'rwRocketLauncher';
            break;
		case 'Plasmarifle':
			e.Replacement = 'rwPlasmarifle';
            break;
		case 'BFG9000': // TODO: rework when randomized BFG is implemented
			dropType = rnd.weightedRand(0, 0, 0, 0, 5, 5);
			switch (dropType) {
                case 0: 
                    e.Replacement ='RwPistol';
                    break;
                case 1: 
                    e.Replacement ='RwShotgun';
                    break;
                case 2: 
                    e.Replacement ='RwSuperShotgun';
                    break;
                case 3: 
                    e.Replacement ='RwChaingun';
                    break;
                case 4: 
                    e.Replacement ='RwRocketLauncher';
                    break;
                case 5: 
                    e.Replacement ='RwPlasmarifle';
                    break;
                default:
                    debug.panic("BFG replacer crashed");
            }
			break;

		// ARMORS:
        case 'GreenArmor':
			e.Replacement = 'RwGreenArmor';
            break;
        case 'BlueArmor':
			e.Replacement = 'RwBlueArmor';
            break;

        // BACKPACK:
        case 'Backpack':
            e.Replacement = RwBackpack.GetRandomVariantClass();
            break;

		// ONE-TIME PICKUPS:
		case 'ArmorBonus':
			e.Replacement = 'RwArmorBonus';
            break;
        }
	}

	override void WorldThingSpawned(worldEvent e)
	{
		let itm = Inventory(e.thing);
		let isRWInstance = (AffixableDetector.IsAffixableItem(itm));

		if (itm && isRWInstance) {
			if (itm.bTossed) {
				itm.Destroy(); // Prevents excessive spawn of shotguns from shotgunners and chainguns from chaingunners
				return;
			}

			itm.bSPECIAL = false; // Make it not automatically pickupable (for use-to-pickup)

			// The item is map-placed by map design.
			// Owner check is needed so that we know it's not in the inventory
			if (itm.owner == null && level.maptime < TICRATE) {
				// let's generate (and give it better rarity and/or quality)
				int rar, qty;
            	[rar, qty] = DropsDecider.rollRarityAndQuality(1, 25);

				GenerateAffixableItem(itm, rar, qty);
			}
		}
	}
}
