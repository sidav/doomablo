// Green armor --------------------------------------------------------------

class RwGreenArmor : RwArmor
{
	Default
	{
		Inventory.Pickupmessage "$GOTARMOR";
		Inventory.Icon "ARM1A0";
	}
	States
	{
	Spawn:
		ARM1 A 6;
		ARM1 B 7 bright;
		loop;
	}

	override void setBaseStats() {
		rwbaseName = "Green Armor";
		stats = New('RwArmorStats');
		stats.currDurability = 150;
		stats.maxDurability = 150;
		stats.AbsorbsPercentage = 35;
		stats.RepairFromBonusx1000 = 4000;
    }

	override string GetRandomFluffName() {
        static const string specialNames[] =
        {
            "Protector",
            "Shield",
            "Covering"
        };
        return specialNames[rnd.randn(specialNames.Size())];
    }
}
