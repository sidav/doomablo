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

	int energyRestoreFraction; // Fractional part
	override void DoEffect() {
		super.DoEffect();
		if (stats.currDurability < stats.maxDurability) {
			let delay = stats.delayUntilRecharge;
			if (ticksSinceDamage() >= delay) {
				// if (ticksSinceDamage() == delay) debug.print("--> Recharge Started at "..GetAge());
				let setTo = math.AccumulatedFixedPointAdd(stats.currDurability, stats.energyRestoreSpeedX1000, 1000, energyRestoreFraction);
				if (stats.currDurability == 0 && setTo != 0) {
					owner.Player.bonusCount += 5;
				}
				stats.currDurability = setTo;
			}
		}
    }

	override void setBaseStats() {
		rwbaseName = "Energy Armor";
		stats = New('RwArmorStats');
		stats.currDurability = 0;
		stats.maxDurability = 15;
		stats.AbsorbsPercentage = 75;
		
		stats.energyRestoreSpeedX1000 = (1000 + TICRATE/2)/TICRATE; // 1 per second
		stats.delayUntilRecharge = 75*TICRATE/10; // 7.5 seconds base
    }

	// Needs to be called before generation, after generatedQuality is set.
	override void prepareForGeneration() {
		stats.delayUntilRecharge = math.getIntPercentage(stats.delayUntilRecharge, 100 - (60 * generatedQuality/100));
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
