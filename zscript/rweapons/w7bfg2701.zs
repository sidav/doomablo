class RwBFG2701 : RandomizedWeapon
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
		BFGG A 1 A_WeaponReady;
		Loop;
	Deselect:
		BFGG A 1 A_Lower;
		Loop;
	Select:
		BFGG A 1 A_Raise;
		Loop;
	Fire:
		BFGG A 25 {
			RWA_ApplyRateOfFire();
			A_StartSound("weapons/bfgf", CHAN_WEAPON);
		}
		BFGG B 15 {
			RWA_ApplyRateOfFire();
		}
	Hold:
		BFGG BBBBBBBBBBBBBBBBBBBBBBBBB 2 {
			RWA_ApplyRateOfFire();
			Fire();
		}
		BFGG B 10 {
			RWA_ReFire();
			RWA_ApplyRateOfFire();
		}
		Goto Ready;
	Flash:
		BFGF A 3 Bright {
			RWA_ApplyRateOfFireToFlash();
			A_Light1();
		}
		BFGF B 3 Bright {
			RWA_ApplyRateOfFireToFlash();
			A_Light2();
		}
		Goto LightDone;
	Spawn:
		BFUG A -1;
		Stop;
	OldFire:
		BFGG A 10 A_StartSound("weapons/bfgf", CHAN_WEAPON);
		BFGG BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB 1 A_FireOldBFG;
		BFGG B 0 A_Light0;
		BFGG B 20 A_ReFire;
		Goto Ready;
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
			10, 20,
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
		rwBaseName = "BFG2701";
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
