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
		stats.currDurability = 100;
		stats.maxDurability = 100;
		stats.AbsorbsPercentage = 50;
		stats.RepairFromBonusx1000 = 2500;
    }

	override string GetRandomFluffName() {
        static const string specialNames[] =
        {
            "Life Saver",
            "Defender",
            "Rhino"
        };
        return specialNames[rnd.randn(specialNames.Size())];
    }
}
