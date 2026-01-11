class rwAutoShotgun : RwWeapon
{
	Default
	{
        Weapon.SlotNumber 3;

		Weapon.SelectionOrder 400;
		// Weapon.AmmoGive 8;
		Weapon.AmmoType "Shell";
		Inventory.PickupMessage "$GOTAUTOSHOTGUN";
		Obituary "$OB_MPAUTOSHOTGUN";
		Tag "$TAG_AUTOSHOTGUN";
		RwWeapon.Weight 12;
	}
	States
	{
	Ready:
		TNT1 A 0 RWA_ReloadOrSwitchIfEmpty;
		SMAG A 1 RWA_WeaponReadyReload;
		Loop;
	Deselect:
		SMAG A 1 A_Lower;
		Loop;
	Select:
		TNT1 A 0 A_WeaponOffset(0, 0, WOF_KEEPY | WOF_INTERPOLATE); // Reset the X-offset which may be off because of reload
		SMAG A 1 A_Raise;
		Loop;
	Fire:
		SMAG A 1 RWA_ApplyRateOfFire();
		SMAG B 2 {
			RWA_ApplyRateOfFire();
			RWA_DoFire();
			A_StartSound("Smasher/Smshfire", CHAN_WEAPON);
			A_GunFlash();
		}
		// SMAG B 0 bright {
			// A_SetPitch (pitch-0.9);
		// }
		SMAG CE 2 Bright {
			RWA_ApplyRateOfFire();
		}
		SMAG FH 2 {
			RWA_ApplyRateOfFire();
			// A_SetPitch (pitch+0.3);
		}
		SMAG A 2 {
			RWA_ApplyRateOfFire();
			RWA_ReFire();
		}
		Goto Ready;
	Reload:
		SMAG AAAAAAAAAAAA 1 A_WeaponOffset(-3, 1, WOF_ADD | WOF_INTERPOLATE);
		SMAG A 15 {
			RWA_ApplyReloadSpeed();
			A_WeaponOffset(-6, 0, WOF_ADD | WOF_INTERPOLATE);
		}
		SMAG A 15 {
			RWA_ApplyReloadSpeed();
			A_WeaponOffset(0, 5, WOF_ADD | WOF_INTERPOLATE);
		}
		SMAG A 15 {
			RWA_ApplyReloadSpeed();
			A_WeaponOffset(12, 3, WOF_ADD | WOF_INTERPOLATE);
		}
		SMAG A 5;
		SMAG A 10 {
			RWA_ApplyReloadSpeed();
			A_WeaponOffset(-12, -3, WOF_ADD | WOF_INTERPOLATE);
		}
		SMAG A 5;
		SMAG A 15 {
			RWA_ApplyReloadSpeed();
			A_WeaponOffset(12, 3, WOF_ADD | WOF_INTERPOLATE);
		}
		SMAG A 10 {
			RWA_ApplyReloadSpeed();
			A_StartSound("misc/w_pkup");
            A_MagazineReload(); //do the reload
			A_WeaponOffset(-12, -3, WOF_ADD | WOF_INTERPOLATE);
		}
		SMAG A 10 {
			RWA_ApplyReloadSpeed();
			A_WeaponOffset(6, -5, WOF_ADD | WOF_INTERPOLATE);
		}
		SMAG AAAAAAAAAAAA 1 A_WeaponOffset(3, -1, WOF_ADD | WOF_INTERPOLATE);
		SMAG A 5;
		Goto Ready;
	Flash:
		TNT1 A 4 Bright {
			RWA_ApplyRateOfFireToFlash();
			A_Light1();
		}
		TNT1 A 3 Bright {
			RWA_ApplyRateOfFireToFlash();
			A_Light2();
		}
		Goto LightDone;
	Spawn:
		SMAP A -1;
		Stop;
	}

	override void setBaseStats() {
		stats = RWStatsClass.NewWeaponStats(
			minDmg: 5, maxDmg: 9,
			pell: 6,
			ammousg: 1,
			hSpr: 12.5,
			vSpr: 3.5
		);
		stats.recoil = 2.5;
		stats.clipSize = 20;
		stats.ShooterKickback = 0.3;
        rwBaseName = "Auto-Shotgun";
    }

	override string GetRandomFluffName() {
        static const string specialNames[] =
        {
			"Trouble Bringer",
			"Overwhelmer",
			"Smasher",
			"UAC Jackhammer"
        };
        return specialNames[rnd.randn(specialNames.Size())];
    }
}
