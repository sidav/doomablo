class rwShotgun : RwWeapon
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
		RwWeapon.Weight 25;
	}
	States
	{
	Ready:
		TNT1 A 0 RWA_ReloadOrSwitchIfEmpty;
		PKSG A 1 RWA_WeaponReadyReload;
		Loop;
	Deselect:
		PKSG A 1 A_Lower;
		Loop;
	Select:
		TNT1 A 0 A_WeaponOffset(0, 0, WOF_KEEPY | WOF_INTERPOLATE); // Reset the X-offset which may be off because of reload
		PKSG A 1 A_Raise;
		Loop;
	Fire:
		PKSG A 3 RWA_ApplyRateOfFire();
		PKSG A 6 {
			RWA_ApplyRateOfFire();
			RWA_DoFire();
			A_StartSound("weapons/shotgf", CHAN_WEAPON);
			A_GunFlash();
		}
		PKSG BCDEFGH 2 RWA_ApplyRateOfFire();
		PKSG HGFEDC 2 RWA_ApplyRateOfFire();
		PKSG A 2;
		PKSG A 5 {
			RWA_ReFire();
			// RWA_ApplyRateOfFire();
		}
		Goto Ready;
	Reload:
		PKSG AABBCCDDEE 1 A_WeaponOffset(-2, 4, WOF_ADD | WOF_INTERPOLATE);
		PKSG FG 15 RWA_ApplyReloadSpeed();
		PKSG H 5 {
			RWA_ApplyReloadSpeed();
            A_StartSound("misc/w_pkup"); // plays Doom's "weapon pickup" sound
            A_MagazineReload(); //do the reload
		}
		PKSG GF 10 RWA_ApplyReloadSpeed();
		PKSG EEDDCCBBAA 1 A_WeaponOffset(2, -4, WOF_ADD | WOF_INTERPOLATE);
		Goto Ready;
	Flash:
		SHTF A 2 Bright {
			RWA_ApplyRateOfFireToFlash();
			A_Light1();
		}
		SHTF B 2 Bright {
			RWA_ApplyRateOfFireToFlash();
			A_Light2();
		}
		SHTF C 1 Bright {
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
		stats.recoil = 2.0;
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
