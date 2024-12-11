class RwMaxQItem : Inventory

{
	Default
	{
		Inventory.Pickupmessage "Tome of knowledge! Maximum item quality increased!";
		// +INVENTORY.ALWAYSPICKUP - should be false
		+Inventory.AUTOACTIVATE
		+BRIGHT
	}
	States
	{
	Spawn:
		TOME ABCDEFGH 5;
		loop;
	}

	override bool TryPickup(in out Actor toucher) {
        let plr = RwPlayer(toucher);
        if (plr) {
			plr.infernoLevel = min(plr.infernoLevel + 1, 100);
			Destroy();
			return true;
        }
		return false;
    }
}
