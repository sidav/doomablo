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

				// TODO: think where else can we do this. It seems a bad place for the implementation. 
				// It will also not synergize with ASuffMedikitsRepairArmor if multi-suffix is enabled
				if (plr.CurrentEquippedBackpack) {
					let aff = plr.CurrentEquippedBackpack.findAppliedAffix('BSuffBetterArmorRepair');
					if (aff != null && rnd.PercentChance(aff.modifierLevel)) {
						repairAmount += Random(1, max(repairAmount, 1));
					}
				}

				arm.RepairFor(repairAmount);
				Destroy();
				return true;
			}
        }
		return false;
    }
}
