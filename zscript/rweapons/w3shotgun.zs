class rwShotgun : RandomizedWeapon
{
	Default
	{
        Weapon.SlotNumber 3;

		Weapon.SelectionOrder 1300;
		// Weapon.AmmoGive 8;
		Weapon.AmmoType "Shell";
		Inventory.PickupMessage "$GOTSHOTGUN";
		Obituary "$OB_MPSHOTGUN";
		Tag "$TAG_SHOTGUN";
		RandomizedWeapon.Weight 25;
	}
	States
	{
	Ready:
		TNT1 A 0 RWA_ReloadOrSwitchIfEmpty;
		SHTG A 1 RWA_WeaponReadyReload;
		Loop;
	Deselect:
		SHTG A 1 A_Lower;
		Loop;
	Select:
		TNT1 A 0 A_WeaponOffset(0, 0, WOF_KEEPY | WOF_INTERPOLATE); // Reset the X-offset which may be off because of reload
		SHTG A 1 A_Raise;
		Loop;
	Fire:
		SHTG A 3 RWA_ApplyRateOfFire();
		SHTG A 7 {
			RWA_ApplyRateOfFire();
			RWA_DoFire();
			A_StartSound("weapons/shotgf", CHAN_WEAPON);
			A_GunFlash();
		}
		SHTG BC 5 RWA_ApplyRateOfFire();
		SHTG D 4 RWA_ApplyRateOfFire();
		SHTG CB 5 RWA_ApplyRateOfFire();
		SHTG A 3 RWA_ApplyRateOfFire();
		SHTG A 7 {
			RWA_ReFire();
			// RWA_ApplyRateOfFire();
		}
		Goto Ready;
	Reload:
		SHTG AAABBBCCCC 1 A_WeaponOffset(-2, 4, WOF_ADD | WOF_INTERPOLATE);
		SHTG CD 15 RWA_ApplyReloadSpeed();
		SHTG D 25 {
			RWA_ApplyReloadSpeed();
            A_StartSound("misc/w_pkup"); // plays Doom's "weapon pickup" sound
            A_MagazineReload(); //do the reload
		}
		SHTG CCCCCBBBBB 1 A_WeaponOffset(2, -4, WOF_ADD | WOF_INTERPOLATE);
		Goto Ready;
	Flash:
		SHTF A 4 Bright {
			RWA_ApplyRateOfFireToFlash();
			A_Light1();
		}
		SHTF B 3 Bright {
			RWA_ApplyRateOfFireToFlash();
			A_Light2();
		}
		Goto LightDone;
	Spawn:
		SHOT A -1;
		Stop;
	}

	override void setBaseStats() {
		stats = RWStatsClass.NewWeaponStats(
			5, 11,
			7,
			1,
			10.5,
			2.5
		);
		stats.recoil = 1.5;
		stats.clipSize = 5;
		stats.ShooterKickback = 0.3;
        rwBaseName = "Shotgun";
    }

	override string GetRandomFluffName() {
        static const string specialNames[] =
        {
			"Boomstick",
			"Canister rifle",
			"12 Gauge",
            "Hunter",
			"Loader",
			"Pump",
			"Scattergun"
        };
        return specialNames[rnd.randn(specialNames.Size())];
    }
}
