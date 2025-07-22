class RwRocketLauncher : RwWeapon
{
	Default
	{
		Weapon.SlotNumber 5;

		Weapon.SelectionOrder 2500;
		// Weapon.AmmoGive 5;
		Weapon.AmmoType "RocketAmmo";
		+WEAPON.NOAUTOFIRE
		Inventory.PickupMessage "$GOTLAUNCHER";
		Tag "$TAG_ROCKETLAUNCHER";
		RwWeapon.Weight 10;
	}
	States
	{
	Ready:
		TNT1 A 0 RWA_ReloadOrSwitchIfEmpty;
		MISG A 1 RWA_WeaponReadyReload;
		Loop;
	Deselect:
		MISG A 1 A_Lower;
		Loop;
	Select:
		TNT1 A 0 A_WeaponOffset(0, 0, WOF_KEEPY | WOF_INTERPOLATE); // Reset the X-offset which may be off because of reload
		MISG A 1 A_Raise;
		Loop;
	Fire:
		MISG B 8 {
			RWA_ApplyRateOfFire();
			A_GunFlash();
		}
		MISG B 12 {
			RWA_ApplyRateOfFire();
			RWA_DoFire();
		}
		MISG B 0 RWA_ReFire;
		Goto Ready;
	Reload:
		MISG BBBBBBBBBB 1 A_WeaponOffset(-3, 1, WOF_ADD | WOF_INTERPOLATE);
		MISG B 15 {
			RWA_ApplyReloadSpeed();
			A_WeaponOffset(-6, 0, WOF_ADD | WOF_INTERPOLATE);
		}
		MISG B 15 {
			RWA_ApplyReloadSpeed();
			A_WeaponOffset(0, 5, WOF_ADD | WOF_INTERPOLATE);
		}
		MISG B 15 {
			RWA_ApplyReloadSpeed();
			A_WeaponOffset(12, 3, WOF_ADD | WOF_INTERPOLATE);
		}
		MISG A 10 {
			RWA_ApplyReloadSpeed();
			A_StartSound("misc/w_pkup");
            A_MagazineReload(); //do the reload
			A_WeaponOffset(-12, -3, WOF_ADD | WOF_INTERPOLATE);
		}
		MISG A 10 {
			RWA_ApplyReloadSpeed();
			A_WeaponOffset(6, -5, WOF_ADD | WOF_INTERPOLATE);
		}
		MISG AAAAAAAAAA 1 A_WeaponOffset(3, -1, WOF_ADD | WOF_INTERPOLATE);
		MISG A 5;
		Goto Ready;
	Flash:
		MISF A 3 Bright {
			RWA_ApplyRateOfFireToFlash();
			A_Light1();
		}
		MISF B 4 Bright {
			RWA_ApplyRateOfFireToFlash();
		}
		MISF CD 4 Bright {
			RWA_ApplyRateOfFireToFlash();
			A_Light2();
		}
		Goto LightDone;
	Spawn:
		LAUN A -1;
		Stop;
	}

	override void setBaseStats() {
		stats = RWStatsClass.NewWeaponStats(
			96, 128,
			1,
			1,
			3.0,
			1.5
		);
		stats.fireType = stats.FTProjectile;

		stats.recoil = 0.5;
		stats.ShooterKickback = 0.8;
		stats.clipSize = 3;
		stats.projClass = 'RwRocket';
		stats.BaseExplosionRadius = 96;
		stats.ExplosionRadius = 96;
		rwBaseName = "Rocket Launcher";
    }

	override string GetRandomFluffName() {
        static const string specialNames[] =
        {
			"Argument",
			"Bazooka",
            "Destructor",
			"Demolisher",
            "Obliterator",
			"Ruiner"
        };
        return specialNames[rnd.randn(specialNames.Size())];
    }
}
