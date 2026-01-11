class RwActiveItemRefill : Inventory {

	Default
	{
		Scale 0.75;
		Inventory.Amount 5;
		Inventory.Pickupmessage "You consume the energy crystal.";
		+FLOATBOB
		-COUNTITEM
		// +INVENTORY.ALWAYSPICKUP - should be false
		+Inventory.AUTOACTIVATE
	}
	States
	{
	Spawn:
		TBCY A 35;
		TBCY B 3;
		TBCY C 3;
		TBCY D 3;
		TBCY E 3;
		TBCY F 3;
		loop;
	}

	override bool TryPickup(in out Actor toucher) {
        let plr = RwPlayer(toucher);
        if (plr && plr.EquippedActiveSlotItem) {
            let asi = plr.EquippedActiveSlotItem;
			if (asi.currentCharges < asi.GetMaxCharges()) {
				asi.Refill(amount);
				Destroy();
				return true;
			}
        }
		return false;
    }
}
