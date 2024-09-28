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
		let itm = RandomizedWeapon(e.thing);
		if (itm) {
			if (itm.bTossed) {
				itm.Destroy(); // Prevents excessive spawn of shotguns from shotgunners and chainguns from chaingunners
				return;
			}
			if (level.maptime < 35) {
				// The item is map-placed, let's increase its rarity and/or quality
			}
			itm.bSPECIAL = false; // Make it not automatically pickupable
		}
	}
}