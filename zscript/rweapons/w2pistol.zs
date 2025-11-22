class rwPistol : RwWeapon
{
	Default
	{
		Weapon.SlotNumber 2;

		Weapon.SelectionOrder 1900;
		// Weapon.AmmoGive 0;
		Weapon.AmmoType "Clip";
		Obituary "$OB_MPPISTOL";
		Inventory.PickupMessage "$GOTPISTOL";
		Tag "$TAG_PISTOL";
		RwWeapon.Weight 25;
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
		TNT1 A 0 A_WeaponOffset(0, 0, WOF_KEEPY | WOF_INTERPOLATE); // Reset the X-offset which may be off because of reload
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
		PISG CCCCCCCCCC 1 A_WeaponOffset(-2, 4, WOF_ADD | WOF_INTERPOLATE);
		PISG C 15 RWA_ApplyReloadSpeed();
		PISG A 15 {
			RWA_ApplyReloadSpeed();
            A_StartSound("misc/w_pkup"); // plays Doom's "weapon pickup" sound
            A_MagazineReload(); //do the reload
		}
		PISG AAAAAAAAAA 1 A_WeaponOffset(2, -4, WOF_ADD | WOF_INTERPOLATE);
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
			5, 13,
			1,
			1,
			2.0,
			0.5
		);
		stats.clipSize = 8;
		rwBaseName = "Pistol";
    }

	override string GetRandomFluffName() {
        static const string specialNames[] =
        {
			"Agent",
			"Beretta",
            "Bullseye",
			"Judge",
			"Law",
            "Repeater"
        };
        return specialNames[rnd.randn(specialNames.Size())];
    }
}
