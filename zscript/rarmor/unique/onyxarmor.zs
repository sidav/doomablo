class RwuOnyxArmor : RwUniqueArmorBase
{
	Default
	{
		Inventory.Pickupmessage "$GOT_ONYXARMOR";
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
		appliedAffixes.push(RwFluffAffix.Create("One of the rare occasions of UAC caring about the user."));
		appliedAffixes.push(RwFluffAffix.Create("Allegedly standard issue for UAC board members. Allegedly."));
	}

	override void setBaseStats() {
		rwbaseName = "Onyx Armor";
		stats = New('RwArmorStats');
		stats.maxDurability = 200;
		stats.AbsorbsPercentage = 95;
		
		stats.energyRestoreSpeedX1000 = math.divideIntWithRounding(7500, TICRATE);
		stats.delayUntilRecharge = 50*TICRATE/10;
    }
}
