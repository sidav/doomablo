class RwChaingun : RandomizedWeapon
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
		CHGG B 5 RWA_ApplyRateOfFire;
		CHGG A 4 RWA_ApplyRateOfFire;
		CHGG B 4 RWA_ApplyRateOfFire;
		CHGG A 3 RWA_ApplyRateOfFire;
		CHGG B 3 RWA_ApplyRateOfFire;
	Hold: // Skip there on ReFire
		TNT1 A 0 {
			invoker.currentFireFrame = 0;
		}
		CHGG ABABABABABA 3 {
			RWA_ApplyRateOfFire();
			if (invoker.currentClipAmmo >= invoker.stats.ammoUsage) {
				RWA_DoFire();
				RWA_ChaingunFlash();
			}
			invoker.currentFireFrame++;
        }
		CHGG B 0 RWA_ReFire;
		CHGG A 3 RWA_ApplyRateOfFire;
		CHGG B 3 RWA_ApplyRateOfFire;
		CHGG A 4 RWA_ApplyRateOfFire;
		CHGG B 4 RWA_ApplyRateOfFire;
		CHGG A 5 RWA_ApplyRateOfFire;
		CHGG B 5 RWA_ApplyRateOfFire;
		CHGG A 6 RWA_ApplyRateOfFire;
		CHGG B 6 RWA_ApplyRateOfFire;
		Goto Ready;
	Reload:
		CHGG AAAABBBBAAAABBBBAAAA 1 A_WeaponOffset(-1, 1, WOF_ADD);
		CHGG BABAB 7 RWA_ApplyReloadSpeed();
		CHGG A 15 {
			RWA_ApplyReloadSpeed();
            A_StartSound("misc/w_pkup"); // plays Doom's "weapon pickup" sound
            A_MagazineReload(); //do the reload
		}
		CHGG BBBBAAAABBBBAAAABBBB 1 A_WeaponOffset(1, -1, WOF_ADD);
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

    override void setBaseStats() {
		stats = RWStatsClass.NewWeaponStats(
			4, 7,
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
