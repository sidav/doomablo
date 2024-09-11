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
		CHGG A 1 A_WeaponReady;
		Loop;
	Deselect:
		CHGG A 1 A_Lower;
		Loop;
	Select:
		CHGG A 1 A_Raise;
		Loop;
	Fire:
		CHGG AB 4 {
			RWA_ApplyRateOfFire();
            RWA_FireBullets();
			RWA_ChaingunFlash();
        }
		CHGG B 0 A_ReFire;
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
		rwBaseName = "Chaingun";
    }
}
