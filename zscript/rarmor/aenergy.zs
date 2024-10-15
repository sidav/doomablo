class RwEnergyArmor : RandomizedArmor
{
	Default
	{
		Inventory.Pickupmessage "Energy Armor";
		Inventory.Icon "EARMA0";
	}
	States
	{
	Spawn:
		EARM A 10 bright;
		EARM B 10;
		loop;
	}


	override void DoEffect() {
		super.DoEffect();
		if (ticksSinceDamage() >= stats.delayUntilRecharge) {
			if (ticksSinceDamage() % stats.energyRestorePeriod == 0) {
				stats.currDurability = min(stats.currDurability+1, stats.maxDurability);
			}
		}
    }

	override void setBaseStats() {
		rwbaseName = "Energy Armor";
		stats = New('RwArmorStats');
		stats.currDurability = 0;
		stats.maxDurability = 10;
		stats.AbsorbsPercentage = 75;
		
		stats.energyRestorePeriod = TICRATE/2;
		stats.delayUntilRecharge = TICRATE*10;
    }

	override string GetRandomFluffName() {
        static const string specialNames[] =
        {
            "Force Field",
			"Impact compensator",
            "Power Shield"
        };
        return specialNames[rnd.randn(specialNames.Size())];
    }
}
