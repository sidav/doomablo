class RwSuperShotgun : RandomizedWeapon
{
	Default
	{
		Weapon.SlotNumber 3;

		Weapon.SelectionOrder 400;
		// Weapon.AmmoGive 8;
		Weapon.AmmoType "Shell";
		Inventory.PickupMessage "$GOTSHOTGUN2";
		Obituary "$OB_MPSSHOTGUN";
		Tag "$TAG_SUPERSHOTGUN";
		RandomizedWeapon.Weight 15;
	}
	States
	{
	Ready:
		SHT2 A 1 A_WeaponReady;
		Loop;
	Deselect:
		SHT2 A 1 A_Lower;
		Loop;
	Select:
		TNT1 A 0 A_WeaponOffset(0, 0, WOF_KEEPY | WOF_INTERPOLATE); // Reset the X-offset which may be off because of reload
		SHT2 A 1 A_Raise;
		Loop;
	Fire:
		SHT2 A 3 RWA_ApplyRateOfFire;
		SHT2 A 7 {
			RWA_ApplyRateOfFire();
			RWA_DoFire();
			A_StartSound("weapons/sshotf", CHAN_WEAPON);
			A_GunFlash();
		}
		SHT2 B 7 RWA_ApplyRateOfFire;
		SHT2 C 7 {
			RWA_ApplyRateOfFire();
			A_CheckReload();
		}
		SHT2 D 7 {
			RWA_ApplyRateOfFire();
			A_StartSound("weapons/sshoto", CHAN_WEAPON);
		}
		SHT2 E 7 RWA_ApplyRateOfFire;
		SHT2 F 7 {
			RWA_ApplyRateOfFire();
			A_StartSound("weapons/sshotl", CHAN_WEAPON); 
		}
		SHT2 G 6 RWA_ApplyRateOfFire;
		SHT2 H 6 {
			RWA_ApplyRateOfFire();
			A_StartSound("weapons/sshotc", CHAN_WEAPON);
			// A_Refire();
		}
		SHT2 A 5 {
			RWA_ApplyRateOfFire();
			A_ReFire();
		}
		Goto Ready;
	Flash:
		SHT2 I 4 Bright {
			RWA_ApplyRateOfFireToFlash();
			A_Light1();
		}
		SHT2 J 3 Bright {
			RWA_ApplyRateOfFireToFlash();
			A_Light2();
		}
		Goto LightDone;
	Spawn:
		SGN2 A -1;
		Stop;
	}

	// That was the original method implementation:

	// action void Fire()
	// {
	// 	if (player == null)
	// 	{
	// 		return;
	// 	}

	// 	A_StartSound ("weapons/sshotf", CHAN_WEAPON);
	// 	Weapon weap = player.ReadyWeapon;
	// 	if (weap != null && invoker == weap && stateinfo != null && stateinfo.mStateType == STATE_Psprite)
	// 	{
	// 		if (!weap.DepleteAmmo (weap.bAltFire, true))
	// 			return;
			
	// 		player.SetPsprite(PSP_FLASH, weap.FindState('Flash'), true);
	// 	}
	// 	player.mo.PlayAttacking2 ();

	// 	double pitch = BulletSlope ();
			
	// 	for (int i = 0 ; i < invoker.stats.Pellets; i++) {
	// 		int damage = invoker.stats.rollDamage();
	// 		double ang = angle + rnd.Rand(-invoker.stats.HorizSpread, invoker.stats.HorizSpread);
	// 		LineAttack(ang, PLAYERMISSILERANGE, pitch + rnd.Rand(-invoker.stats.VertSpread, invoker.stats.VertSpread), damage, 'Hitscan', "BulletPuff");
	// 	}
	// }

	override void setBaseStats() {
		stats = RWStatsClass.NewWeaponStats(
			5, 10,
			18,
			2,
			15.0,
			4.0
		);
		stats.recoil = 1.5;
		stats.TargetKnockback = 192;
		stats.ShooterKickback = 0.5;
        rwBaseName = "Super Shotgun";
    }

	override string GetRandomFluffName() {
        static const string specialNames[] =
        {
			"Boomstick",
			"Double Trouble",
			"Howitzer",
            "Lead delivery",
			"Smasher",
			"Sprayer",
            "Terrifier"
        };
        return specialNames[rnd.randn(specialNames.Size())];
    }
}
