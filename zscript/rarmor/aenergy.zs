class RwEnergyArmor : RwArmor
{
	Default
	{
		Inventory.Pickupmessage "Energy Armor";
		Inventory.Icon "EARMA0";
		RwArmor.Weight 5;
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
		RechargeEnergyArmor();
    }

	override void setBaseStats() {
		rwbaseName = "Energy Armor";
		stats = New('RwArmorStats');
		stats.currDurability = 0;
		stats.maxDurability = 50;
		stats.AbsorbsPercentage = 75;
		
		stats.energyRestoreSpeedX1000 = math.divideIntWithRounding(1250, TICRATE); // 1.25 per second
		stats.delayUntilRecharge = 50*TICRATE/10;
    }

	// Needs to be called before generation, after generatedQuality is set.
	override void prepareForGeneration() {
		stats.maxDurability += math.getIntPercentage(generatedQuality, 33);
		stats.delayUntilRecharge = math.getIntPercentage(stats.delayUntilRecharge, 100 - math.getIntPercentage(generatedQuality, 50));
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
