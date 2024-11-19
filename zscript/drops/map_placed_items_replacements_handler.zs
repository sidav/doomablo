// Handles the replacement of default weapons/items. 
class MapPlacedItemsToRWCounterpartsReplacementHandler : EventHandler
{
	mixin AffixableGenerationHelperable;

	override void CheckReplacement(ReplaceEvent e)
	{
		let cls = e.Replacee.GetClassName();
		int dropType;
        switch (cls) {

		// WEAPONS
		case 'Chainsaw':
            e.Replacement = 'rwChainsaw';
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
            if (rnd.OneChanceFrom(2)) {
                e.Replacement = 'rwChaingun';
            } else {
                e.Replacement = 'rwSmg';
            }
            break;
		case 'Rocketlauncher':
			e.Replacement = 'rwRocketLauncher';
            break;
		case 'Plasmarifle':
			e.Replacement = 'rwPlasmarifle';
            break;
		case 'BFG9000':
            if (rnd.OneChanceFrom(2)) {
                e.Replacement = 'rwBFG';
            } else {
                e.Replacement = 'rwBFG2701';
            }
			break;

		// ARMORS:
        case 'GreenArmor':
			e.Replacement = 'RwGreenArmor';
            break;
        case 'BlueArmor':
            if (rnd.OneChanceFrom(3)) {
                e.Replacement = 'RwEnergyArmor';
            } else {
			    e.Replacement = 'RwBlueArmor';
            }
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
                if (tryOverrideDeadSimpleBackpackPlacement(RwBackpack(itm))) {
                    return;
                }

				// let's generate (and give it better rarity and/or quality)
				int rar, qty;
            	[rar, qty] = DropsDecider.rollRarityAndQuality(
                    rnd.weightedRand(0, 100, 25, 1),
                    rnd.rand(1, 10)
                );

				GenerateAffixableItem(itm, rar, qty);
			}
		}
	}

    // MAP07: Dead Simple has like 10 backpacks in one place. That's fun, but can break the balance here. Let's spawn random ammo instead.
    static bool tryOverrideDeadSimpleBackpackPlacement(RwBackpack b) {
        if (b) {
            Inventory itm;
            let ti = ThinkerIterator.Create('Inventory');
            while (itm = Inventory(ti.next())) {
                if (itm != b && RwBackpack(itm) && itm.Distance3D(b) < b.radius) {
                    DropsSpawner.SpawnRandomAmmoDrop(b, 300);
                    DropsSpawner.SpawnRandomAmmoDrop(b, 300);
                    DropsSpawner.SpawnRandomAmmoDrop(b, 300);
                    b.Destroy();
                    return true;
                }
            }
        }
        return false;
    }
}
