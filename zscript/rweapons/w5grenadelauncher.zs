class RwGrenadeLauncher : RwWeapon
{
	Default
	{
		Weapon.SlotNumber 5;

		Weapon.SelectionOrder 2500;
		// Weapon.AmmoGive 5;
		Weapon.AmmoType "RocketAmmo";
		+WEAPON.NOAUTOFIRE
		Inventory.PickupMessage "$GOTGRENADELAUNCHER";
		Tag "$TAG_GRENADELAUNCHER";
		RwWeapon.Weight 10;
	}
	States
	{
	Ready:
		TNT1 A 0 RWA_ReloadOrSwitchIfEmpty;
		RGLG A 1 RWA_WeaponReadyReload;
		Loop;
	Deselect:
		RGLG A 1 A_Lower;
		Loop;
	Select:
		TNT1 A 0 A_WeaponOffset(0, 0, WOF_KEEPY | WOF_INTERPOLATE); // Reset the X-offset which may be off because of reload
		RGLG A 1 A_Raise;
		Loop;
	Fire:
		RGLF A 3 {
			RWA_ApplyRateOfFire();
			A_StartSound("40mm/grenfire", CHAN_WEAPON);
			A_GunFlash();
		}
		RGLF B 4 {
			RWA_ApplyRateOfFire();
			RWA_DoFire();
		}
		RGLF C 4 RWA_ApplyRateOfFire();
		RGLG ABCDA 5 RWA_ApplyRateOfFire();
		RGLG A 1 RWA_ReFire;
		Goto Ready;
	Reload:
		RGLG AAAAAAAAAA 1 A_WeaponOffset(-3, 1, WOF_ADD | WOF_INTERPOLATE);
		RGLG A 10 {
			RWA_ApplyReloadSpeed();
			A_WeaponOffset(-6, 0, WOF_ADD | WOF_INTERPOLATE);
		}
		RGLG A 10 {
			RWA_ApplyReloadSpeed();
			A_WeaponOffset(0, 5, WOF_ADD | WOF_INTERPOLATE);
		}
		RGLG A 10 {
			RWA_ApplyReloadSpeed();
			A_WeaponOffset(12, 3, WOF_ADD | WOF_INTERPOLATE);
		}
		RGLG ABCDABCDABCDABCD 3 RWA_ApplyReloadSpeed();
		RGLG A 10 {
			RWA_ApplyReloadSpeed();
			A_StartSound("misc/w_pkup");
            A_MagazineReload(); //do the reload
			A_WeaponOffset(-12, -3, WOF_ADD | WOF_INTERPOLATE);
		}
		RGLG A 10 {
			RWA_ApplyReloadSpeed();
			A_WeaponOffset(6, -5, WOF_ADD | WOF_INTERPOLATE);
		}
		RGLG AAAAAAAAAA 1 A_WeaponOffset(3, -1, WOF_ADD | WOF_INTERPOLATE);
		RGLG A 3;
		Goto Ready;
	Flash:
		TNT1 A 3 Bright {
			RWA_ApplyRateOfFireToFlash();
			A_Light1();
		}
		TNT1 B 4 Bright {
			RWA_ApplyRateOfFireToFlash();
		}
		TNT1 CD 4 Bright {
			RWA_ApplyRateOfFireToFlash();
			A_Light2();
		}
		Goto LightDone;
	Spawn:
		GLMM A -1;
		Stop;
	}

	override void setBaseStats() {
		stats = RWStatsClass.NewWeaponStats(
			minDmg: 72, maxDmg: 96,
			pell: 1,
			ammousg: 1,
			hSpr: 4.5,
			vSpr: 1.5
		);
		stats.fireType = stats.FTProjectile;

		stats.recoil = 0.5;
		stats.ShooterKickback = 0.8;
		stats.clipSize = 5;
		stats.projClass = 'RwGlGrenade';
		stats.BaseExplosionRadius = 128;
		stats.ExplosionRadius = 128;
		rwBaseName = "Grenade Launcher";
    }

	override string GetRandomFluffName() {
        static const string specialNames[] =
        {
			"Demolisher",
            "Obliterator",
			"Ruiner",
			"Surpriser"
        };
        return specialNames[rnd.randn(specialNames.Size())];
    }
}
