class RwChaingun : RwWeapon
{

	int currentFireFrame;


	Default
	{
        Weapon.SlotNumber 4;

		Weapon.SelectionOrder 700;
		// Weapon.AmmoGive 20;
		Weapon.AmmoType "Clip";
		Inventory.PickupMessage "$GOTCHAINGUN";
		Obituary "$OB_MPCHAINGUN";
		Tag "$TAG_CHAINGUN";
		Decal "BulletChip";
		RwWeapon.Weight 20;
	}
	States
	{
	Ready:
		TNT1 A 0 RWA_ReloadOrSwitchIfEmpty;
		CHGG A 1 RWA_WeaponReadyReload;
		Loop;
	Deselect:
		CHGG A 1 A_Lower;
		Loop;
	Select:
		TNT1 A 0 A_WeaponOffset(0, 0, WOF_KEEPY | WOF_INTERPOLATE); // Reset the X-offset which may be off because of reload
		CHGG A 1 A_Raise;
		Loop;
	Fire:
		PKCG A 3 ShootAndApplyROF;
		PKCG BCD 3 RWA_ApplyRateOfFire();
		PKCG A 3 ShootAndApplyROF;
		PKCG BCD 2 RWA_ApplyRateOfFire();
		PKCG A 2 ShootAndApplyROF;
		PKCG BCD 1 RWA_ApplyRateOfFire();
		PKCG A 1 ShootAndApplyROF;
		PKCG BCD 1 RWA_ApplyRateOfFire();
		PKCG A 0 RWA_ReFire;
		// "Spin down" begins here
	Spin:
		PKCG ABCD 2 SpinDown;
		PKCG A 2 SpinDown;
		PKCG B 3 SpinDown;
		PKCG C 3 SpinDown;
		PKCG D 3 SpinDown;
		PKCG A 4 SpinDown;
		PKCG B 4 SpinDown;
		PKCG C 4 SpinDown;
		PKCG D 5 SpinDown;
		Goto Ready;
	// Tapping the button now goes straight to spindown from initial burst.
	// Hold is much shorter and thus more responsive (you don't lose as much ammo after letting go of the trigger).
	// - dbrz
	Hold: // Skip there on ReFire
		PKCG A 1 {
			invoker.currentFireFrame = 0;
			ShootAndApplyROF();
			invoker.currentFireFrame++;
        }
		PKCG BC 1 RWA_ApplyRateOfFire;
		PKCG A 1 {
			ShootAndApplyROF();
			invoker.currentFireFrame++;
        }
		PKCG BD 1 RWA_ApplyRateOfFire;
		TNT0 A 0 RWA_ReFire;
	Goto Spin;
	Reload:
		PKCG AABBCCDDAABBCCDDAABB 1 A_WeaponOffset(-1, 1, WOF_ADD | WOF_INTERPOLATE);
		PKCG CDABC 7 RWA_ApplyReloadSpeed();
		PKCG D 15 {
			RWA_ApplyReloadSpeed();
            A_StartSound("misc/w_pkup"); // plays Doom's "weapon pickup" sound
            A_MagazineReload(); //do the reload
		}
		PKCG AABBCCDDAABBCCDDAA 1 A_WeaponOffset(1, -1, WOF_ADD | WOF_INTERPOLATE);
		Goto Ready;
	Flash:
		PKCF A 1 Bright {
			RWA_ApplyRateOfFireToFlash();
			A_Light1();
		}
		PKCF B 1 Bright {
			RWA_ApplyRateOfFireToFlash();
			A_Light2();
		}
		TNT1 A 1 {
			RWA_ApplyRateOfFireToFlash();
			A_Light1();
		}
		Goto LightDone;
		PKCF C 1 Bright {
			RWA_ApplyRateOfFireToFlash();
			A_Light1();
		}
		PKCF D 1 Bright {
			RWA_ApplyRateOfFireToFlash();
			A_Light2();
		}
		TNT1 A 1 {
			RWA_ApplyRateOfFireToFlash();
			A_Light1();
		}
		Goto LightDone;
	Spawn:
		MGUN A -1;
		Stop;
	}

	// Rewritten the method completely, it was quite hard to understand in the source
	action void RWA_ChaingunFlash() {
		if (player == null)
			return;

		Weapon weap = player.ReadyWeapon;
		if (weap != null && invoker == weap && stateinfo != null && stateinfo.mStateType == STATE_Psprite) {
			A_StartSound ("weapons/chngun", CHAN_WEAPON);
			State flash = weap.FindState('Flash');
			if (flash != null) {
				let psp = player.GetPSprite(PSP_WEAPON);
				if (psp) {
					player.SetSafeFlash(weap, flash, 3*(invoker.currentFireFrame % 2));
				}
			}
		}
	}

	// A couple simple wrapper functions to make the animation read a little more cleanly.
	// - dbrz
	action void ShootAndApplyROF() {
		RWA_ApplyRateOfFire();
		if (invoker.currentClipAmmo >= invoker.stats.ammoUsage) {
			RWA_DoFire();
			RWA_ChaingunFlash();
		}
		// The gun now shoots during spinup. This should make the chaingun feel way, way more responsive,
		// since the old behavior meant that swapping to another weapon was basically mandatory if you had a threat to deal with right away.
		// - dbrz
	}

	action void SpinDown() {
		RWA_ApplyRateOfFire();
		RWA_Refire();
		// You can start firing again during spindown, but swapping weapons or reloading requires full spindown.
		// Firing from spindown jumps right to full speed, as long as you're still in spindown when you hit the button again,
		// so you no longer have to wait for the whole spindown and spinup if your finger slips.
		// - dbrz
	}

	override void setBaseStats() {
		stats = RWStatsClass.NewWeaponStats(
			5, 15,
			1,
			1,
			8.5,
			5.0
		);
		stats.clipSize = 100;
		rwBaseName = "Chaingun";
	}

	override string GetRandomFluffName() {
        static const string specialNames[] =
        {
			"Hole puncher",
			"Instigator",
			"Peacekeeper",
			"Perforator",
            "Penetrator",
			"Persuader",
            "Terminator"
        };
        return specialNames[rnd.randn(specialNames.Size())];
    }
}
