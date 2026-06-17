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
		PKRL A 1 RWA_WeaponReadyReload;
		Loop;
	Deselect:
		PKRL A 1 A_Lower;
		Loop;
	Select:
		TNT1 A 0 A_WeaponOffset(0, 0, WOF_KEEPY | WOF_INTERPOLATE); // Reset the X-offset which may be off because of reload
		PKRL A 1 A_Raise;
		Loop;
	Fire:
		PKRL A 4 {
			RWA_ApplyRateOfFire();
			A_GunFlash();
		}
		PKRL B 2 RWA_ApplyRateOfFire();
		PKRL D 3 {
			RWA_ApplyRateOfFire();
			RWA_DoFire();
		}
		PKRL C 3 RWA_ApplyRateOfFire();
		PKRL BE 2 RWA_ApplyRateOfFire();
		PKRL FG 2 RWA_ApplyRateOfFire();
		PKRL A 0 RWA_ReFire;
		Goto Ready;
	Reload:
		PKRL GGGGGGGGGG 1 A_WeaponOffset(-3, 1, WOF_ADD | WOF_INTERPOLATE);
		PKRL G 15 {
			RWA_ApplyReloadSpeed();
			A_WeaponOffset(-6, 0, WOF_ADD | WOF_INTERPOLATE);
		}
		PKRL G 15 {
			RWA_ApplyReloadSpeed();
			A_WeaponOffset(0, 5, WOF_ADD | WOF_INTERPOLATE);
		}
		PKRL F 15 {
			RWA_ApplyReloadSpeed();
			A_WeaponOffset(12, 3, WOF_ADD | WOF_INTERPOLATE);
		}
		PKRL F 10 {
			RWA_ApplyReloadSpeed();
			A_StartSound("misc/w_pkup");
            A_MagazineReload(); //do the reload
			A_WeaponOffset(-12, -3, WOF_ADD | WOF_INTERPOLATE);
		}
		PKRL G 10 {
			RWA_ApplyReloadSpeed();
			A_WeaponOffset(6, -5, WOF_ADD | WOF_INTERPOLATE);
		}
		PKRL AAAAAAAAAA 1 A_WeaponOffset(3, -1, WOF_ADD | WOF_INTERPOLATE);
		PKRL A 5;
		Goto Ready;
	Flash:
		PKRF A 4 Bright {
			RWA_ApplyRateOfFireToFlash();
			A_Light1();
		}
		PKRF B 2 Bright {
			RWA_ApplyRateOfFireToFlash();
		}
		PKRF C 2 Bright {
			RWA_ApplyRateOfFireToFlash();
			A_Light2();
		}
		PKRF DE 3 Bright {
			RWA_ApplyRateOfFireToFlash();
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
            "Destructor"
        };
        return specialNames[rnd.randn(specialNames.Size())];
    }
}
