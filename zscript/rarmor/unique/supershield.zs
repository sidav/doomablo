class RwuSuperShield : RwUniqueArmorBase
{
	Default
	{
		Inventory.Pickupmessage "$GOT_SUPERSHIELD";
		Inventory.Icon "ARMXB0";
	}
	States
	{
	Spawn:
		ARMX AB 4 Bright;
		loop;
	}

	override void DoEffect() {
		super.DoEffect();
		RechargeEnergyArmor();
    }


	override void prepareForGeneration() {
		super.prepareForGeneration();
		appliedAffixes.push(RwFluffAffix.Create("Handcrafted for those who've never had to ask the price."));
		appliedAffixes.push(RwFluffAffix.Create("UAC Armor Kits(TM) are sold separately."));
		appliedAffixes.push(RwFluffAffix.Create("They say UAC CEO wears one on a daily basis."));
	}

	override void setBaseStats() {
		rwbaseName = "CEO-132 Aegis shield";
		stats = New('RwArmorStats');
		stats.maxDurability = 250;
		stats.AbsorbsPercentage = 95;
		
		stats.energyRestoreSpeedX1000 = math.divideIntWithRounding(12500, TICRATE);
		stats.delayUntilRecharge = 20*TICRATE;
    }
}
