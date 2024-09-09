class StartingItemsHandler : EventHandler
{
	override void PlayerSpawned(PlayerEvent e)
	{
		PlayerPawn pmo = players[e.PlayerNumber].mo;
		if (pmo)
		{
			clearBasicItems(pmo);
		}
	}

	void clearBasicItems(PlayerPawn pmo) {
		// Destroy BasicArmor - we use custom armor logic;
		let ba = pmo.FindInventory('BasicArmor');
		if (ba) {
			ba.Destroy();
		}

		// Remove default weapons;
		int rwCount = 0; // How many randomized ones the player has; needed later
		let invlist = pmo.inv;
        while(invlist != null) {
			Inventory toDestroy;
            if (Weapon(invlist)) {
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
			pmo.GiveInventory('RwPistol', 1);
		}
	}
}