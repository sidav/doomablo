class RwBlueArmor : RandomizedArmor
{
	Default
	{
		Inventory.Pickupmessage "$GOTMEGA";
		Inventory.Icon "ARM2A0";
	}
	States
	{
	Spawn:
		ARM2 A 6;
		ARM2 B 6 bright;
		loop;
	}

	override void setBaseStats() {
		rwbaseName = "Blue Armor";
		stats = New('RwArmorStats');
		stats.currDurability = 200;
		stats.maxDurability = 200;
		stats.AbsorbsPercentage = 50;
		stats.DamageReduction = 0;
		stats.BonusRepair = 5;
    }
}
