class RwMinQItem : Inventory

{
	Default
	{
		Inventory.Pickupmessage "Emblem of chaos! Minimum item quality increased!";
		// +INVENTORY.ALWAYSPICKUP - should be false
		+Inventory.AUTOACTIVATE
		+BRIGHT
	}
	States
	{
	Spawn:
		TELO ABCD 5;
		loop;
	}

	override bool TryPickup(in out Actor toucher) {
        let plr = MyPlayer(toucher);
        if (plr) {
			plr.minItemQuality = min(plr.minItemQuality + 2, 75);
			if (plr.minItemQuality >= plr.maxItemQuality) {
				plr.maxItemQuality = plr.minItemQuality+1;
			}
			Destroy();
			return true;
        }
		return false;
    }
}
