class ArmorRepairKit : Inventory {
	Default
	{
		Height 16;
		Inventory.Pickupmessage "Armor repair kit!";
		Inventory.Amount 1;
		Inventory.MaxAmount 5;
		Inventory.InterHubAmount 5;
		Inventory.Icon "FKITC0";
        // +INVENTORY.ALWAYSPICKUP - should be false
		-Inventory.AUTOACTIVATE
        +INVENTORY.INVBAR
		+BRIGHT
	}
	States
	{
	Spawn:
		FKIT A 15;
        FKIT B 15;
		loop;
	}

	override bool CanPickup(Actor toucher) {
		return RwPlayer(toucher) != null;
	}

	override bool Use(bool pickup) {
        let plr = RwPlayer(owner);
		if (plr && plr.CurrentEquippedArmor) {
            let arm = plr.CurrentEquippedArmor;
			// if (arm.stats.IsEnergyArmor()) {
			// TODO: add instant recharge
			// }
			if (arm.stats.RepairFromKitx1000 > 0 && arm.stats.currDurability < arm.stats.maxDurability) {
				let repairAmount = math.AccumulatedFixedPointAdd(0, arm.stats.RepairFromKitx1000, 1000, arm.stats.currRepairFraction);
				arm.RepairFor(repairAmount);
				owner.A_StartSound("FieldKit/Use", CHAN_AUTO);
				return true;
			}
        }
		return false;
	}
}
