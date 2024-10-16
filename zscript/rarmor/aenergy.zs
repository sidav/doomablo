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
		if (stats.currDurability < stats.maxDurability) {
			let delay = stats.delayUntilRecharge;
			if (RwPlayer(owner) && RwPlayer(owner).CurrentEquippedBackpack) {
				let aff = RwPlayer(owner).CurrentEquippedBackpack.FindAppliedAffix('BSuffBetterEarmorDelay');
				if (aff) {
					delay = math.getIntPercentage(delay, aff.modifierLevel);
				}
			}
			if (ticksSinceDamage() >= delay) {
				if (ticksSinceDamage() % stats.energyRestorePeriod == 0) {
					if (stats.currDurability == 0) {
						owner.Player.bonusCount += 5;
					}
					stats.currDurability = min(stats.currDurability+1, stats.maxDurability);
				}
			}
		}
    }

	override void setBaseStats() {
		rwbaseName = "Energy Armor";
		stats = New('RwArmorStats');
		stats.currDurability = 0;
		stats.maxDurability = 15;
		stats.AbsorbsPercentage = 75;
		
		stats.energyRestorePeriod = 2*TICRATE/3;
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
