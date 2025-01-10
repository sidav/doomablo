class StatScroll : Inventory {
	Default
	{
		Height 16;
		Inventory.Pickupmessage "Stat scroll! Stat point acquired!";
		// +INVENTORY.ALWAYSPICKUP - should be false
		+Inventory.AUTOACTIVATE
		+BRIGHT
	}
	States
	{
	Spawn:
		HRAD ABCDEFGHIJKLMNOP 3;
		loop;
	}

	override bool CanPickup(Actor toucher) {
		return RwPlayer(toucher) != null;
	}

	override bool Use(bool pickup) {
		let plr = RwPlayer(owner);
		if (plr) {
			plr.stats.statPointsAvailable++;
			return true;
        }
		return false;
	}
}
