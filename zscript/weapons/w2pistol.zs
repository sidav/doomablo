class rwPistol : RandomizedWeapon
{
	Default
	{
		Weapon.WeaponScaleX 1.3;
		Weapon.WeaponScaleY 1;
		Weapon.SlotNumber 2;

		Weapon.SelectionOrder 1900;
		Weapon.AmmoGive 0;
		Weapon.AmmoType "Clip";
		Obituary "$OB_MPPISTOL";
		+WEAPON.WIMPY_WEAPON
		Inventory.PickupMessage "$GOTPISTOL";
		Tag "$TAG_PISTOL";
	}
	States
	{
	Ready:
		TNT1 A 0 RWA_ReloadOrSwitchIfEmpty;
		PISG A 1 RWA_WeaponReadyReload;
		Loop;
	Deselect:
		PISG A 1 A_Lower;
		Loop;
	Select:
		PISG A 1 A_Raise;
		Loop;
	Fire:
		PISG A 4 RWA_ApplyRateOfFire();
		PISG B 6 {
			RWA_ApplyRateOfFire();
			RWA_DoFire();
			A_StartSound("weapons/pistol", CHAN_WEAPON);
			A_GunFlash();
		}
		PISG C 4 RWA_ApplyRateOfFire();
		PISG B 5 {
			RWA_Refire();
			RWA_ApplyRateOfFire();
		}
		Goto Ready;
	Reload:
		PISG CCCCCCCCCC 1 A_WeaponOffset(-2, 4, WOF_ADD);
		PISG C 15 RWA_ApplyReloadSpeed();
		PISG A 15 {
			RWA_ApplyReloadSpeed();
            A_StartSound("misc/w_pkup"); // plays Doom's "weapon pickup" sound
            A_MagazineReload(); //do the reload
		}
		PISG AAAAAAAAAA 1 A_WeaponOffset(2, -4, WOF_ADD);
		Goto Ready;
	Flash:
		PISF A 7 Bright {
			RWA_ApplyRateOfFireToFlash();
			A_Light1();
		}
		Goto LightDone;
		PISF A 7 Bright {
			RWA_ApplyRateOfFireToFlash();
			A_Light1();
		}
		Goto LightDone;
 	Spawn:
		PIST A -1;
		Stop;
	}

	override void setBaseStats() {
		stats = RWStatsClass.NewWeaponStats(
			4, 6,
			1,
			1,
			2.0,
			0.5
		);
		stats.clipSize = 6;
		rwBaseName = "Pistol";
    }

	override string GetRandomFluffName() {
        static const string specialNames[] =
        {
			"Agent",
			"Beretta",
            "Bullseye",
			"Gunslinger",
			"Judge",
			"Law",
            "Repeater"
        };
        return specialNames[rnd.randn(specialNames.Size())];
    }
}
