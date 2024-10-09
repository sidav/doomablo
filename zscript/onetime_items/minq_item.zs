class MinQItem : Inventory

{
	Default
	{
		Inventory.Pickupmessage "You have gained a level!";
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
			Destroy();
			return true;
        }
		return false;
    }
}
