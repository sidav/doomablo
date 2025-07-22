// Health bonus -------------------------------------------------------------
class RwHealthBonus : Health replaces HealthBonus
{
	Default
	{
		+COUNTITEM
		+INVENTORY.ALWAYSPICKUP
		Inventory.Amount 1;
		Inventory.PickupMessage "$GOTHTHBONUS";
	}
	States
	{
	Spawn:
		BON1 ABCDCB 6;
		Loop;
	}

    override bool TryPickup (in out Actor toucher) {
        let plr = RwPlayer(toucher);
        if (plr == null) return false;
        let amountToRestore = plr.stats.GetMaxHealthPercentage(1);
		if (plr.GiveBody(amountToRestore, 2 * plr.stats.GetMaxHealth()))
		{
			GoAwayAndDie();
			return true;
		}
		return false;
	}

}
	
// Stimpack -----------------------------------------------------------------

class RwStimpack : Health replaces Stimpack
{
	Default
	{
		Inventory.Amount 1;
		Inventory.PickupMessage "$GOTSTIM";
	}
	States
	{
	Spawn:
		STIM A -1;
		Stop;
	}

    override bool TryPickup (in out Actor toucher) {
        let plr = RwPlayer(toucher);
        if (plr == null) return false;
        let amountToRestore = plr.stats.GetMaxHealthPercentage(10);
		if (plr.GiveBody(amountToRestore, plr.stats.GetMaxHealth()))
		{
			GoAwayAndDie();
			return true;
		}
		return false;
	}
}

// Medikit -----------------------------------------------------------------

class RwMedikit : Health replaces Medikit
{
	Default
	{
		Inventory.Amount 1;
		Inventory.PickupMessage "$GOTMEDIKIT";
		Health.LowMessage 25, "$GOTMEDINEED";
	}
	States
	{
	Spawn:
		MEDI A -1;
		Stop;
	}

    override bool TryPickup (in out Actor toucher) {
        let plr = RwPlayer(toucher);
        if (plr == null) return false;
        let amountToRestore = plr.stats.GetMaxHealthPercentage(25);
		if (plr.GiveBody(amountToRestore, plr.stats.GetMaxHealth()))
		{
			GoAwayAndDie();
			return true;
		}
		return false;
	}
}

// Soulsphere --------------------------------------------------------------

class RwSoulsphere : Health replaces Soulsphere
{
	Default
	{
		+COUNTITEM;
		+INVENTORY.AUTOACTIVATE;
		+INVENTORY.ALWAYSPICKUP;
		+INVENTORY.FANCYPICKUPSOUND;
		Inventory.Amount 1;
		Inventory.PickupMessage "$GOTSUPER";
		Inventory.PickupSound "misc/p_pkup";
	}
	States
	{
	Spawn:
		SOUL ABCDCB 6 Bright;
		Loop;
	}

    override bool TryPickup (in out Actor toucher) {
        let plr = RwPlayer(toucher);
        if (plr == null) return false;
        let amountToRestore = plr.stats.GetMaxHealthPercentage(100);
		if (plr.GiveBody(amountToRestore, 2*plr.stats.GetMaxHealth()))
		{
			GoAwayAndDie();
			return true;
		}
		return false;
	}
}

// Megasphere --------------------------------------------------------------

class RwMegasphere : CustomInventory replaces Megasphere
{
	Default
	{
		+COUNTITEM
		+INVENTORY.ALWAYSPICKUP
		+INVENTORY.ISHEALTH
		+INVENTORY.ISARMOR
		Inventory.PickupMessage "$GOTMSPHERE";
		Inventory.PickupSound "misc/p_pkup";
	}
	States
	{
	Spawn:
		MEGA ABCD 6 BRIGHT;
		Loop;
	}

    override bool TryPickup (in out Actor toucher) {
        let plr = RwPlayer(toucher);
        if (plr == null) return false;

        let amountToRestore = plr.stats.GetMaxHealthPercentage(200);
        let healthRestored = plr.GiveBody(amountToRestore, 2*plr.stats.GetMaxHealth());

        let armorRepaired = false;
        if (plr.CurrentEquippedArmor && plr.CurrentEquippedArmor.IsDamaged()) {
            plr.CurrentEquippedArmor.RepairFor(plr.CurrentEquippedArmor.stats.maxDurability);
            armorRepaired = true;
        }

		if (healthRestored || armorRepaired)
		{
			GoAwayAndDie();
			return true;
		}
		return false;
	}
}