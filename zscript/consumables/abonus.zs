class RwArmorBonus : Inventory replaces ArmorBonus

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
			if (arm.stats.RepairFromBonusx1000 > 0 && arm.stats.currDurability < arm.stats.maxDurability) {
				let repairAmount = math.AccumulatedFixedPointAdd(0, arm.stats.RepairFromBonusx1000, 1000, arm.stats.currRepairFraction);
				arm.RepairFor(repairAmount);
				Destroy();
				return true;
			}
        }
		return false;
    }
}
