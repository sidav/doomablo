class rwRevolver : RwWeapon
{
	Default
	{
		Weapon.SlotNumber 2;

		Weapon.SelectionOrder 1950;
		// Weapon.AmmoGive 0;
		Weapon.AmmoType "Clip";
		Obituary "$OB_MPPISTOL";
		Inventory.PickupMessage "$GOTREVOLVER";
		Tag "$TAG_REVOLVER";
		RwWeapon.Weight 10;
	}
	States
	{
	Ready:
		TNT1 A 0 RWA_ReloadOrSwitchIfEmpty;
		COLT B 1 RWA_WeaponReadyReload;
		Loop;
	Deselect:
		COLT B 1 A_Lower;
		Loop;
	Select:
		TNT1 A 0 A_WeaponOffset(0, 0, WOF_KEEPY | WOF_INTERPOLATE); // Reset the X-offset which may be off because of reload
		COLT B 1 A_Raise;
		Loop;
	Fire:
		COLT B 2 RWA_ApplyRateOfFire();
		COLT A 4 {
			A_StartSound("Revolver/Coltclac", CHAN_WEAPON);
			RWA_ApplyRateOfFire();
		}
		COLT B 3 {
			RWA_ApplyRateOfFire();
			RWA_DoFire();
			A_StartSound("Revolver/Coltplow", CHAN_WEAPON);
			A_GunFlash();
		}
		COLT D 1;
		COLT E 10 {
			RWA_ApplyRateOfFire();
			A_WeaponOffset(0, 10, WOF_ADD | WOF_INTERPOLATE);
		}
		COLT E 5 {
			RWA_ApplyRateOfFire();
			A_WeaponOffset(0, -5, WOF_ADD | WOF_INTERPOLATE);
		}
		COLT D 5 {
			RWA_ApplyRateOfFire();
			A_WeaponOffset(0, -5, WOF_ADD | WOF_INTERPOLATE);
		}
		COLT B 5 {
			RWA_ApplyRateOfFire();
			A_WeaponOffset(0, WEAPONTOP, WOF_INTERPOLATE); // Reset offset
		}
		COLT B 1 {
			RWA_Refire();
			RWA_ApplyRateOfFire();
		}
		Goto Ready;
	Reload:
		COLT F 6 RWA_ApplyReloadSpeed();
		COLT G 4 {
			RWA_ApplyReloadSpeed();
			A_StartSound("Revolver/Coltopen", CHAN_WEAPON);
		}
		COLT H 6 RWA_ApplyReloadSpeed();
		COLT IJK 4 RWA_ApplyReloadSpeed();
		COLT L 4 {
			RWA_ApplyReloadSpeed();
			A_StartSound("Revolver/Coltejec", CHAN_WEAPON);
		}
		COLT M 16 RWA_ApplyReloadSpeed();
		COLT LK 4 RWA_ApplyReloadSpeed();
		COLT J 7 {
			RWA_ApplyReloadSpeed();
            A_StartSound("Revolver/Coltinsr", CHAN_WEAPON);
            A_MagazineReload(); //do the reload
		}
		COLT I 4 RWA_ApplyReloadSpeed();
		COLT H 6 RWA_ApplyReloadSpeed();
		COLT G 4 RWA_ApplyReloadSpeed();
		COLT F 6 {
			RWA_ApplyReloadSpeed();
			A_StartSound("Revolver/Coltclos", CHAN_WEAPON);
		}
		Goto Ready;
	Flash:
		COLT C 3 BRIGHT {
			RWA_ApplyRateOfFireToFlash();
			A_Light1();
		}
		TNT1 A 1 {
			RWA_ApplyRateOfFireToFlash();
			A_Light1();
		}
		Goto LightDone;
 	Spawn:
		COLP A -1;
		Stop;
	}

	override void setBaseStats() {
		stats = RWStatsClass.NewWeaponStats(
			minDmg: 10, maxDmg: 20,
			pell: 1,
			ammousg: 1,
			hSpr: 1.5,
			vSpr: 0.7
		);
		stats.clipSize = 5;
		rwBaseName = "Revolver";
    }

	override string GetRandomFluffName() {
        static const string specialNames[] =
        {
			"Cowboy",
			"Gunslinger",
			"Bounty hunter",
			"Ranger"
        };
        return specialNames[rnd.randn(specialNames.Size())];
    }
}
