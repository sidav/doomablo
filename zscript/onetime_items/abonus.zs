class RwArmorBonus : Inventory

{
	Default
	{
		Inventory.Pickupmessage "You repaired your armor.";
		Inventory.Icon "BON2A0";
		+COUNTITEM
		// +INVENTORY.ALWAYSPICKUP - should be false
		+Inventory.AUTOACTIVATE
	}
	States
	{
	Spawn:
		BON2 ABCDCB 6;
		loop;
	}

	override bool TryPickup(in out Actor toucher) {
        let plr = RwPlayer(toucher);
        if (plr && plr.CurrentEquippedArmor) {
            let arm = plr.CurrentEquippedArmor;
			if (arm.stats.BonusRepair > 0 && arm.stats.currDurability < arm.stats.maxDurability) {
				let repairAmount = arm.stats.BonusRepair;
				arm.RepairFor(repairAmount);
				Destroy();
				return true;
			}
        }
		return false;
    }
}
