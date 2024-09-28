// Handles the replacement of default weapons/items. 
class DefaultItemsToRWCounterpartsReplacementHandler : EventHandler
{
	override void CheckReplacement(ReplaceEvent e)
	{
		let cls = e.Replacee.GetClassName();
        switch (cls) {

		// WEAPONS
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

		// ARMORS:
        case 'GreenArmor':
			e.Replacement = 'RwGreenArmor';
            break;
        case 'BlueArmor':
			e.Replacement = 'RwBlueArmor';
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
		let isRWInstance = (itm is 'RandomizedArmor' || itm is 'RandomizedWeapon');

		if (itm && isRWInstance) {
			if (itm.bTossed) {
				itm.Destroy(); // Prevents excessive spawn of shotguns from shotgunners and chainguns from chaingunners
				return;
			}

			itm.bSPECIAL = false; // Make it not automatically pickupable (for use-to-pickup)

			// The item is map-placed by map design.
			// Owner check is needed so that we know it's not in the inventory
			if (itm.owner == null && level.maptime < 35) {
				// let's generate (and give it better rarity and/or quality)
				let rar = DropQualityDecider.decideRarity(1);
				let qty = DropQualityDecider.decideQuality(25);

				if (itm is 'RandomizedWeapon') {
					RandomizedWeapon(itm).Generate(rar, qty);
				} else if (itm is 'RandomizedArmor') {
					RandomizedArmor(itm).Generate(rar, qty);
				}
			}
		}
	}
}
