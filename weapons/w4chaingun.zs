class RwChaingun : RandomizedWeapon
{
	Default
	{
        Weapon.SlotNumber 4;

		Weapon.SelectionOrder 700;
		Weapon.AmmoUse 1;
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
            Fire();
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
			A_Light1();
		}
		Goto LightDone;
	Spawn:
		MGUN A -1;
		Stop;
	}

    override void setBaseStats() {
		stats = New('RWStatsClass');
		stats.HorizSpread = 7.0;
		stats.VertSpread = 2.0;
		stats.Pellets = 1;
		stats.DamageDice = Dice.CreateNew(1, 6, 0);
		rwBaseName = "Chaingun";
    }

    action void Fire()
	{
		if (player == null)
		{
			return;
		}

		Weapon weap = player.ReadyWeapon;
		if (weap != null && invoker == weap && stateinfo != null && stateinfo.mStateType == STATE_Psprite)
		{
			int dmg = invoker.stats.rollDamage();
			A_FireBullets(
				invoker.stats.HorizSpread, invoker.stats.VertSpread, 
				invoker.stats.Pellets,
				dmg,
				'BulletPuff',
				1, // Flags
				0, // Range,
				null // Missile (e.g. 'PlasmaBall')
				// double Spawnheight
				// double Spawnofs_xy
			);
            A_StartSound ("weapons/chngun", CHAN_WEAPON);
			// if (!weap.DepleteAmmo (weap.bAltFire, true))
			// 	return;

			A_StartSound ("weapons/chngun", CHAN_WEAPON);

			State flash = weap.FindState('Flash');
			if (flash != null)
			{
				State atk = weap.FindState('Fire');
				let psp = player.GetPSprite(PSP_WEAPON);
				if (psp) 
				{
					State cur = psp.CurState;
					int theflash = atk == cur? 0:1;
					player.SetSafeFlash(weap, flash, theflash);
				}
			}
		}
		player.mo.PlayAttacking2 ();
	}
}
