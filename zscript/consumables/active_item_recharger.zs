class ActiveItemRecharger : RwStoredConsumable {
	Default
	{
		Height 16;
		Inventory.Pickupmessage "Time-charge sphere!";
		RwStoredConsumable.RwBaseMaxAmount 2;
		Inventory.Icon "SALVB0";
        // +INVENTORY.ALWAYSPICKUP - should be false
		-Inventory.AUTOACTIVATE
        +INVENTORY.INVBAR
		+BRIGHT
	}
	States
	{
	Spawn:
		SALV ABCDEDCB 5;
		loop;
	}

	override bool Use(bool pickup) {
        let plr = RwPlayer(owner);
		if (plr && plr.EquippedActiveSlotItem) {
            let asi = plr.EquippedActiveSlotItem;
            if (!asi.isOnCooldown() && asi.isFullyCharged()) {
                return false;
            }
            asi.cooldownTicksRemaining = 1;
            let refillThisMuch = max(
                34 * asi.GetMaxCharges()/ 100, // ~33%, rounding up
                asi.GetChargesConsumptionPerUse() // but at least one full use is guaranteed
            );
            asi.Refill(refillThisMuch);
            return true;
        }
		return false;
	}
}
