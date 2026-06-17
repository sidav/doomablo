class rwPistol : RwWeapon
{
	Default
	{
		Weapon.SlotNumber 2;
		Weapon.SelectionOrder 1900;

		Decal "BulletChip";
		// Weapon.AmmoGive 0;
		Weapon.AmmoType "Clip";
		Obituary "$OB_MPPISTOL";
		Inventory.PickupMessage "$GOTPISTOL";
		Tag "$TAG_PISTOL";
		RwWeapon.Weight 25;
		RwWeapon.FreeReload true;
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
		PKPX A 1 {
			RWA_ApplyRateOfFire();
			RWA_DoFire();
			A_StartSound("weapons/pistol", CHAN_WEAPON);
			A_GunFlash();
		}
		PKPX B 2 RWA_ApplyRateOfFire();
		PKPX C 2 RWA_ApplyRateOfFire();
		PKPX DDEEEEDDBB 1 {
			RWA_ApplyRateOfFire();
			return RefireOnFastClick();
		}
		PKPX A 1 {
			RWA_ApplyRateOfFire();
			return RefireOnFastClick();
		}
		Goto Ready;
	// AltFire:
	// 	PKPX A 3 RWA_ApplyRateOfFire();
	// 	// Burst-fire: shot 1
	// 	PKPX B 3 {
	// 		RWA_ApplyRateOfFire();
	// 		RWA_DoFire();
	// 		A_StartSound("weapons/pistol", CHAN_WEAPON);
	// 		A_GunFlash();
	// 		if (invoker.currentClipAmmo < invoker.stats.AmmoUsage) {
	// 			return ResolveState('EndOfAltFire');
	// 		}
	// 		return ResolveState(null);
	// 	}
	// 	PKPX CE 2 RWA_ApplyRateOfFire();
	// 	// Burst-fire: shot 2
	// 	PKPX B 3 {
	// 		RWA_ApplyRateOfFire();
	// 		RWA_DoFire();
	// 		A_StartSound("weapons/pistol", CHAN_WEAPON);
	// 		A_GunFlash();
	// 		if (invoker.currentClipAmmo < invoker.stats.AmmoUsage) {
	// 			return ResolveState('EndOfAltFire');
	// 		}
	// 		return ResolveState(null);
	// 	}
	// 	PKPX CE 2 RWA_ApplyRateOfFire();
	// 	// Burst-fire: shot 3
	// 	PKPX B 3 {
	// 		RWA_ApplyRateOfFire();
	// 		RWA_DoFire();
	// 		A_StartSound("weapons/pistol", CHAN_WEAPON);
	// 		A_GunFlash();
	// 	}
	// 	Goto EndOfAltFire;
	// EndOfAltFire:
	// 	PKPX CDEDC 2 RWA_ApplyRateOfFire();
	// 	PKPX B 4 {
	// 		RWA_Refire();
	// 		RWA_ApplyRateOfFire();
	// 	}
	// 	Goto Ready;
	Reload:
		PKPX CCDDEE 1 A_WeaponOffset(-2, 4, WOF_ADD | WOF_INTERPOLATE);
		PISG GGGHHH 1 A_WeaponOffset(-2, 4, WOF_ADD | WOF_INTERPOLATE);
		PISG H 15 {
			A_WeaponOffset(0, 16, WOF_ADD | WOF_INTERPOLATE);
			RWA_ApplyReloadSpeed();
		}
		PISG H 15 {
			A_WeaponOffset(0, -16, WOF_ADD | WOF_INTERPOLATE);
			RWA_ApplyReloadSpeed();
            A_StartSound("misc/w_pkup"); // plays Doom's "weapon pickup" sound
            A_MagazineReload(); //do the reload
		}
		PISG HHGGF 1 A_WeaponOffset(2, -4, WOF_ADD | WOF_INTERPOLATE);
		PKPX EDDCC 1 A_WeaponOffset(2, -5, WOF_ADD | WOF_INTERPOLATE);
		Goto Ready;
	Flash:
		PKPF A 1 Bright {
			RWA_ApplyRateOfFireToFlash();
			A_Light1();
		}
		PKPF B 2 Bright {
			RWA_ApplyRateOfFireToFlash();
			A_Light1();
		}
		Goto LightDone;
 	Spawn:
		PIST A -1;
		Stop;
	}

	action State RefireOnFastClick() {
		if (player.cmd.buttons & BT_ATTACK && !(player.oldbuttons & BT_ATTACK))
		{
			if (invoker.currentClipAmmo >= invoker.stats.ammoUsage) {
			// If so, go back to Fire:
				return ResolveState("Fire");
			}
		}
		return ResolveState(null);
	}

	override void setBaseStats() {
		stats = RWStatsClass.NewWeaponStats(
			5, 14,
			1,
			1,
			3.5,
			0.5
		);
		stats.clipSize = 12;
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
