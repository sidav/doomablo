class RwBFG2704 : RandomizedWeapon
{
	Default
	{
		Weapon.SlotNumber 7;
		Height 20;
		Weapon.SelectionOrder 2800;
		Weapon.AmmoType "Cell";
		+WEAPON.NOAUTOFIRE;
		Inventory.PickupMessage "$GOTBFG9000";
		Tag "$TAG_BFG9000";
	}
	States
	{
	Ready:
		BF27 A 1 A_WeaponReady;
		Loop;
	Deselect:
		BF27 A 1 A_Lower;
		Loop;
	Select:
		BF27 A 1 A_Raise;
		Loop;
	Fire:
		BF27 B 3 {
			RWA_ApplyRateOfFire();
			A_StartSound("BFG2704/Charge", CHAN_WEAPON);
		}
		BF27 ABABABABABABAB 3 {
			RWA_ApplyRateOfFire();
		}
		BF27 C 4 {
			RWA_ApplyRateOfFire();
		}
	Hold:
		BF27 DAEACDEADAEACDEAEDEDCAEDC 2 {
			RWA_ApplyRateOfFire();
			Fire();
		}
		BF27 F 10 {
			RWA_ReFire();
			RWA_ApplyRateOfFire();
		}
		Goto Ready;
	Flash:
		TNT1 A 3 Bright {
			RWA_ApplyRateOfFireToFlash();
			A_Light1();
		}
		TNT1 A 3 Bright {
			RWA_ApplyRateOfFireToFlash();
			A_Light2();
		}
		Goto LightDone;
	Spawn:
		WBF2 A -1;
		Stop;
	}

	bool lastFiredFirstVariant;
	action void Fire() {
		State flash = invoker.FindState('Flash');
		if (flash != null) {
			player.SetSafeFlash(invoker, flash, random[FirePlasma](0, 1));
		}

		if (invoker.lastFiredFirstVariant) {
			invoker.stats.projClass = 'RwPlasmaBall2';
		} else {
			invoker.stats.projClass = 'RwPlasmaBall1';
		}
		invoker.lastFiredFirstVariant = !invoker.lastFiredFirstVariant;

		RWA_DoFire();
	}

	override void setBaseStats() {
		stats = RWStatsClass.NewWeaponStats(
			10, 35,
			1,
			1,
			14.0,
			4.0
		);
		stats.recoil = 0.1;
		stats.ShooterKickback = 0.1;
		stats.clipSize = 0;
		stats.firesProjectiles = true;
		stats.projClass = 'RwPlasmaBall1';
		rwBaseName = "BFG2704";
    }

	override string GetRandomFluffName() {
        static const string specialNames[] =
        {
			"Old Freaking Gun",
			"Boson field generator",
			"Blast Field Generator",
			"Good ol' BFG"
        };
        return specialNames[rnd.randn(specialNames.Size())];
    }
}
