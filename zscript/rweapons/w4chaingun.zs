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
		CHGG B 5 ShootAndApplyROF;
		CHGG A 4 ShootAndApplyROF;
		CHGG B 4 ShootAndApplyROF;
		CHGG A 3 ShootAndApplyROF;
		CHGG B 3 ShootAndApplyROF;
		CHGG B 0 RWA_ReFire;
		// "Spin down" begins here
	Spin:
		CHGG A 3 SpinDown;
		CHGG B 3 SpinDown;
		CHGG A 4 SpinDown;
		CHGG B 4 SpinDown;
		CHGG A 4 SpinDown;
		CHGG B 5 SpinDown;
		CHGG A 5 SpinDown;
		CHGG B 6 SpinDown;
		Goto Ready;
	// Tapping the button now goes straight to spindown from initial burst.
	// Hold is much shorter and thus more responsive (you don't lose as much ammo after letting go of the trigger).
	// - dbrz
	Hold: // Skip there on ReFire
		TNT1 A 0 {
			invoker.currentFireFrame = 0;
		}
		CHGG AB 3 {
			ShootAndApplyROF();
			invoker.currentFireFrame++;
        }
	CHGG B 0 RWA_ReFire;
	Goto Spin;
	Reload:
		CHGG AAAABBBBAAAABBBBAAAA 1 A_WeaponOffset(-1, 1, WOF_ADD | WOF_INTERPOLATE);
		CHGG BABAB 7 RWA_ApplyReloadSpeed();
		CHGG A 15 {
			RWA_ApplyReloadSpeed();
            A_StartSound("misc/w_pkup"); // plays Doom's "weapon pickup" sound
            A_MagazineReload(); //do the reload
		}
		CHGG BBBBAAAABBBBAAAABBBB 1 A_WeaponOffset(1, -1, WOF_ADD | WOF_INTERPOLATE);
		Goto Ready;
	Flash:
		CHGF A 4 Bright {
			RWA_ApplyRateOfFireToFlash();
			A_Light1();
		}
		Goto LightDone;
		CHGF B 4 Bright {
			RWA_ApplyRateOfFireToFlash();
			A_Light2();
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
					player.SetSafeFlash(weap, flash, invoker.currentFireFrame % 2);
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
			4, 8,
			1,
			1,
			12.5,
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
			"Reason",
            "Terminator"
        };
        return specialNames[rnd.randn(specialNames.Size())];
    }
}
