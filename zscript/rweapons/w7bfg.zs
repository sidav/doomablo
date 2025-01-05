class RwBFG : RandomizedWeapon
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
		TNT1 A 0 A_WeaponOffset(0, 0, WOF_KEEPY | WOF_INTERPOLATE); // Reset the X-offset which may be off because of reload
		BFGG A 1 A_Raise;
		Loop;
	Fire:
		BFGG A 20 {
			RWA_ApplyRateOfFire();
			A_StartSound("weapons/bfgf", CHAN_WEAPON);
		}
		BFGG B 10 {
			RWA_ApplyRateOfFire();
			A_GunFlash();
		}
		BFGG B 10 {
			RWA_ApplyRateOfFire();
			RWA_DoFire();
		}
		BFGG B 20 {
			RWA_ApplyRateOfFire();
			A_ReFire();
		}
		Goto Ready;
	Flash:
		BFGF A 11 Bright {
			RWA_ApplyRateOfFireToFlash();
			A_Light1();
		}
		BFGF B 6 Bright {
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

	// Scale rays damage too
	override void prepareForGeneration() {
		super.prepareForGeneration();
        stats.RayDmgMin = StatsScaler.ScaleIntValueByLevelRandomized(stats.RayDmgMin, generatedQuality);
        stats.RayDmgMax = StatsScaler.ScaleIntValueByLevelRandomized(stats.RayDmgMax, generatedQuality);
    }

	override void setBaseStats() {
		stats = RWStatsClass.NewWeaponStats(
			100, 500,
			1,
			50,
			5.0,
			0.5
		);
		stats.recoil = 1.5;
		stats.ShooterKickback = 5.0;
		stats.clipSize = 0;
		stats.firesProjectiles = true;
		stats.projClass = 'RwBFGBall';
		rwBaseName = "BFG";

		// BFG-only
		stats.NumberOfRays = 40;
		stats.RaysConeAngle = 90.;
		stats.RayDmgMin = 15;
		stats.RayDmgMax = 75;
		stats.raysWillOriginateFromMissile = false;
    }

	override string GetRandomFluffName() {
		if (rnd.oneChanceFrom(3)) {
			return "BFG"..Random(5000, 10000);
		}
        static const string specialNames[] =
        {
			"Annihilator",
			"Big Freaking Gun",
			"Big Fucking Gun",
            "Bio-Force Gun",
			"Disintegrator"
        };
        return specialNames[rnd.randn(specialNames.Size())];
    }
}
