class RwFlaskRefill : Inventory

{
	Default
	{
		Inventory.Pickupmessage "You pour the liquid in your flask.";
		+FLOATBOB
		-COUNTITEM
		// +INVENTORY.ALWAYSPICKUP - should be false
		+Inventory.AUTOACTIVATE
	}
	States
	{
	Spawn:
		FKCG A 1;
		loop;
	}

	override bool TryPickup(in out Actor toucher) {
        let plr = RwPlayer(toucher);
        if (plr && plr.CurrentEquippedFlask) {
            let fsk = plr.CurrentEquippedFlask;
			if (fsk.currentCharges < fsk.stats.maxCharges) {
				fsk.Refill(3);
				Destroy();
				return true;
			}
        }
		return false;
    }
}
