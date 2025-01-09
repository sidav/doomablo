class StartingItemsHandler : EventHandler
{
	override void PlayerSpawned(PlayerEvent e)
	{
		PlayerPawn pmo = players[e.PlayerNumber].mo;
		// Before the first tick after level change the pmo points to some other PlayerPawn with null inventory
		// which causes bugs. Thus we skip this routine if pmo.Inv is null.
		// TODO: solve this via some unremovable item in inventory and changing default weapons in HandlePickup() for that item.
		// This may even make this handler redundant

		// Update: this damn bug returns once again and I once again don't know why
		// WeapCheck is a new shiny workaround for that
		let rWeap = players[e.PlayerNumber].ReadyWeapon;
		bool weapCheck = (rWeap == null) || ((rWeap.GetClass() != 'RwFist') && (RandomizedWeapon(rWeap) == null));

		if (pmo && pmo.Inv && weapCheck) {
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
			pmo.GiveInventory('RwFist', 1);
			let given = RandomizedWeapon(pmo.GiveInventoryType('RwPistol'));
			given.Generate(3, 1);
			if (rw_start_with_shotgun) {
				let shg = RandomizedWeapon(pmo.GiveInventoryType('RwShotgun'));
				shg.Generate(0, 1);
				pmo.GiveInventory('Shell', shg.stats.clipSize);
			}
			if (rw_start_with_smg) {
				let shg = RandomizedWeapon(pmo.GiveInventoryType('RwSmg'));
				shg.Generate(0, 1);
			}
		}
	}
}