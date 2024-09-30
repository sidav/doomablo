class StartingItemsHandler : EventHandler
{
	override void PlayerSpawned(PlayerEvent e)
	{
		PlayerPawn pmo = players[e.PlayerNumber].mo;
		// Before the first tick after level change the pmo points to some other PlayerPawn with null inventory
		// which causes bugs. Thus we skip this routine if pmo.Inv is null.
		// TODO: solve this via some unremovable item in inventory and changing default weapons in HandlePickup() for that item.
		// This may event make this handler redundant
		if (pmo && pmo.Inv) {
			clearBasicItems(pmo);
		}
	}

	void clearBasicItems(PlayerPawn pmo) {
		// Remove default weapons (and BasicArmor - we use custom armor logic);
		int rwCount = 0; // How many randomized ones the player has; needed later
		let invlist = pmo.inv;
        while(invlist != null) {
			Inventory toDestroy;
            if (Weapon(invlist) || BasicArmor(invlist)) {
				if (RandomizedWeapon(invlist)) {
					rwCount++;
				} else {
                	toDestroy = invlist;
				}
            }
            invlist=invlist.Inv;
			if (toDestroy) {
				toDestroy.Destroy();
			}
        }
		// If player has no RWs instances, this means it's a game start. Let's give them basic weapons:
		if (rwCount == 0) {
			pmo.GiveInventory('Fist', 1);
			let given = RandomizedWeapon(pmo.GiveInventoryType('RwPistol'));
			given.Generate(3, rnd.Rand(50, 75));
		}
	}
}