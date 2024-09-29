class RwChaingun : RandomizedWeapon
{
	Default
	{
        Weapon.SlotNumber 4;

		Weapon.SelectionOrder 700;
		Weapon.AmmoGive 20;
		Weapon.AmmoType "Clip";
		Inventory.PickupMessage "$GOTCHAINGUN";
		Obituary "$OB_MPCHAINGUN";
		Tag "$TAG_CHAINGUN";
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
		CHGG A 1 A_Raise;
		Loop;
	Fire:
		CHGG AB 4 {
			RWA_ReloadOrSwitchIfEmpty(); // Need to call that because the chaingun fires two bullets at once
			RWA_ApplyRateOfFire();
            RWA_DoFire();
			RWA_ChaingunFlash();
        }
		CHGG B 0 RWA_ReFire;
		Goto Ready;
	Reload:
		CHGG AAAABBBBAAAABBBBAAAA 1 A_WeaponOffset(-1, 1, WOF_ADD);
		CHGG BAB 10 RWA_ApplyReloadSpeed();
		CHGG A 15 {
			RWA_ApplyReloadSpeed();
            A_StartSound("misc/w_pkup"); // plays Doom's "weapon pickup" sound
            A_MagazineReload(); //do the reload
		}
		CHGG BBBBAAAABBBBAAAABBBB 1 A_WeaponOffset(1, -1, WOF_ADD);
		Goto Ready;
	Flash:
		CHGF A 5 Bright {
			RWA_ApplyRateOfFireToFlash();
			A_Light1();
		}
		Goto LightDone;
		CHGF B 5 Bright {
			RWA_ApplyRateOfFireToFlash();
			A_Light2();
		}
		Goto LightDone;
	Spawn:
		MGUN A -1;
		Stop;
	}

	action void RWA_ChaingunFlash() {
		if (player == null)
			return;

		Weapon weap = player.ReadyWeapon;
		if (weap != null && invoker == weap && stateinfo != null && stateinfo.mStateType == STATE_Psprite) {
			A_StartSound ("weapons/chngun", CHAN_WEAPON);
			State flash = weap.FindState('Flash');
			if (flash != null) {
				// Removed most of the mess that was here in the C++ code because SetSafeFlash already does some thorough validation.
				State atk = weap.FindState('Fire');
				let psp = player.GetPSprite(PSP_WEAPON);
				if (psp) {
					State cur = psp.CurState;
					int theflash = atk == cur? 0:1;
					player.SetSafeFlash(weap, flash, theflash);
				}
			}
		}
	}

    override void setBaseStats() {
		stats = RWStatsClass.NewWeaponStats(
			1, 6,
			1,
			1,
			7.0,
			2.0
		);
		stats.clipSize = 40;
		rwBaseName = "Chaingun";
    }
}
