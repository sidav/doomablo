class RwSmg : RandomizedWeapon
{
	Default
	{
        Weapon.SlotNumber 4;

		Weapon.SelectionOrder 700;
		// Weapon.AmmoGive 20;
		Weapon.AmmoType "Clip";
		Inventory.PickupMessage "$GOTCHAINGUN";
		Obituary "$OB_MPCHAINGUN";
		Tag "$TAG_CHAINGUN";
	}
	States
	{
	Ready:
		TNT1 A 0 RWA_ReloadOrSwitchIfEmpty;
		SMGG A 1 RWA_WeaponReadyReload;
		Loop;
	Deselect:
		SMGG A 1 A_Lower;
		Loop;
	Select:
		SMGG A 1 A_Raise;
		Loop;
	Fire:
		SMGG A 4 {
			RWA_ApplyRateOfFire();
			if (invoker.currentClipAmmo >= invoker.stats.ammoUsage) {
				A_WeaponOffset(0, 3, WOF_ADD);
				RWA_ApplyRateOfFire();
				RWA_DoFire();
				A_StartSound("weapons/pistol", CHAN_WEAPON);
				A_GunFlash();
			}
        }
		SMGG A 1 {
			A_WeaponOffset(0, -3, WOF_ADD);
        }
		SMGG A 1 RWA_ReFire;
		Goto Ready;
	Reload:
		SMGG AAAAAAAAAA 1 A_WeaponOffset(-3, 2, WOF_ADD);
		SMGG A 15 {
			RWA_ApplyReloadSpeed();
			A_WeaponOffset(-6, 0, WOF_ADD);
		}
		SMGG A 15 {
			RWA_ApplyReloadSpeed();
			A_WeaponOffset(0, 5, WOF_ADD);
		}
		SMGG A 10 {
			RWA_ApplyReloadSpeed();
			A_StartSound("misc/w_pkup");
            A_MagazineReload(); //do the reload
			A_WeaponOffset(6, -5, WOF_ADD);
		}
		SMGG AAAAAAAAAA 1 A_WeaponOffset(3, -2, WOF_ADD);
		SMGG A 5;
		Goto Ready;
	Flash:
		SMGF A 1 Bright {
			RWA_ApplyRateOfFireToFlash();
			A_Light1();
		}
		SMGF B 1 Bright {
			RWA_ApplyRateOfFireToFlash();
			A_Light1();
		}
		Goto LightDone;
	Spawn:
		SMGL A -1;
		Stop;
	}

    override void setBaseStats() {
		stats = RWStatsClass.NewWeaponStats(
			5, 8,
			1,
			1,
			7.0,
			2.0
		);
		stats.clipSize = 30;
		rwBaseName = "SMG";
    }

	override string GetRandomFluffName() {
        static const string specialNames[] =
        {
			"Compact MG",
			"Stinger",
			"Scorpion",
			"Storm"
        };
        return specialNames[rnd.randn(specialNames.Size())];
    }
}