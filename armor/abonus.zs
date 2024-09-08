class RwArmorBonus : Inventory

{
	Default
	{
		Inventory.Pickupmessage "$GOTARMBONUS";
		Inventory.Icon "BON2A0";
		+COUNTITEM
		+INVENTORY.ALWAYSPICKUP
	}
	States
	{
	Spawn:
		BON2 ABCDCB 6;
		loop;
	}

	override void Touch(Actor toucher) {
        let plr = MyPlayer(toucher);
        if (plr && plr.CurrentEquippedArmor) {
            let arm = plr.CurrentEquippedArmor;
            if (arm.stats.BonusRepair > 0) {
                arm.stats.CurrentAmount += arm.stats.BonusRepair;
                if (arm.stats.CurrentAmount > arm.stats.MaxAmount) {
                    arm.stats.CurrentAmount = arm.stats.MaxAmount;
                }
                Destroy();
                console.printf("You repaired your armor.");
            }
        }
    }
}
