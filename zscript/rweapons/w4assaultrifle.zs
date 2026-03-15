class RwAssaultRifle : RwWeapon
{
	Default
	{
        Weapon.SlotNumber 4;

		Weapon.SelectionOrder 700;
		// Weapon.AmmoGive 20;
		Weapon.AmmoType "Clip";
		Inventory.PickupMessage "$GOT_ASSAULT_RIFLE";
		Obituary "$OB_MPAR";
		Tag "$TAG_ASSAULT_RIFLE";
		RwWeapon.Weight 20;
	}
	States
	{
	Ready:
		TNT1 A 0 RWA_ReloadOrSwitchIfEmpty;
		UACR A 1 RWA_WeaponReadyReload;
		Loop;
	Deselect:
		UACR A 1 A_Lower;
		Loop;
	Select:
		TNT1 A 0 A_WeaponOffset(0, 0, WOF_KEEPY | WOF_INTERPOLATE); // Reset the X-offset which may be off because of reload
		UACR A 1 A_Raise;
		Loop;
	Fire:
		UACR A 2 {
			// RWA_ApplyRateOfFire();
			if (invoker.currentClipAmmo >= invoker.stats.ammoUsage) {
				A_WeaponOffset(0, 3, WOF_ADD | WOF_INTERPOLATE);
				RWA_ApplyRateOfFire();
				RWA_DoFire();
				A_StartSound("AssaultRifle/fire", CHAN_WEAPON);
				A_GunFlash();
			}
        }
		UACR B 2 {
			RWA_ApplyRateOfFire();
		}
		UACR A 1 {
			A_WeaponOffset(0, -3, WOF_ADD | WOF_INTERPOLATE);
			RWA_ApplyRateOfFire();
		}
		UACR A 1 RWA_ReFire;
		Goto Ready;
	Reload:
		// Hand moves
		UACR F 2 RWA_ApplyReloadSpeed;
		UACR G 2 RWA_ApplyReloadSpeed;
		UACR H 2 RWA_ApplyReloadSpeed;
		UACR I 2 RWA_ApplyReloadSpeed;
		UACR P 2 RWA_ApplyReloadSpeed;
		// Extracting the clip
		UACR O 5 RWA_ApplyReloadSpeed;
		UACR N 2 RWA_ApplyReloadSpeed;
		UACR M 2 {
			A_StartSound("AssaultRifle/clipout");
			RWA_ApplyReloadSpeed();
		}
		UACR L 2 RWA_ApplyReloadSpeed;
		UACR K 2 RWA_ApplyReloadSpeed;
		// Clip out
		UACR J 12 RWA_ApplyReloadSpeed;
		// Putting a new clip
		UACR K 2 RWA_ApplyReloadSpeed;
		UACR L 2 RWA_ApplyReloadSpeed;
		UACR M 2 RWA_ApplyReloadSpeed;
		UACR N 6 RWA_ApplyReloadSpeed;
		UACR O 5 {
			A_StartSound("AssaultRifle/clipin");
			A_MagazineReload(); //do the reload
			RWA_ApplyReloadSpeed();
		}
		// Hand moves
		UACR P 2 RWA_ApplyReloadSpeed;
		UACR G 2 RWA_ApplyReloadSpeed;
		UACR F 2 RWA_ApplyReloadSpeed;
		UACR A 2 RWA_ApplyReloadSpeed;
		Goto Ready;
	Flash:
		UACR D 2 Bright {
			RWA_ApplyRateOfFireToFlash();
			A_Light1();
		}
		UACR E 1 Bright {
			RWA_ApplyRateOfFireToFlash();
		}
		Goto LightDone;
	Spawn:
		UACR C -1;
		Stop;
	}

    override void setBaseStats() {
		stats = RWStatsClass.NewWeaponStats(
			6, 10,
			1,
			1,
			7.0,
			2.0
		);
		stats.clipSize = 30;
		rwBaseName = "UAC Assault Rifle";
    }

	override string GetRandomFluffName() {
        static const string specialNames[] =
        {
			"Compact AR",
			"Stinger AR",
			"Scorpion AR",
			"Storm AR"
        };
        return specialNames[rnd.randn(specialNames.Size())];
    }
}
