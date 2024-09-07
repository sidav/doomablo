class RwRocketLauncher : RandomizedWeapon
{
	Default
	{
		Weapon.SlotNumber 5;

		Weapon.SelectionOrder 2500;
		Weapon.AmmoUse 1;
		Weapon.AmmoGive 100; // DEBUG: default was 2
		Weapon.AmmoType "RocketAmmo";
		+WEAPON.NOAUTOFIRE
		Inventory.PickupMessage "$GOTLAUNCHER";
		Tag "$TAG_ROCKETLAUNCHER";
	}
	States
	{
	Ready:
		MISG A 1 A_WeaponReady;
		Loop;
	Deselect:
		MISG A 1 A_Lower;
		Loop;
	Select:
		MISG A 1 A_Raise;
		Loop;
	Fire:
		MISG B 8 {
			RWA_ApplyRateOfFire();
			A_GunFlash();
		}
		MISG B 12 {
			RWA_ApplyRateOfFire();
			Fire();
		}
		MISG B 0 A_ReFire;
		Goto Ready;
	Flash:
		MISF A 3 Bright {
			RWA_ApplyRateOfFireToFlash();
			A_Light1();
		}
		MISF B 4 Bright {
			RWA_ApplyRateOfFireToFlash();
		}
		MISF CD 4 Bright {
			RWA_ApplyRateOfFireToFlash();
			A_Light2();
		}
		Goto LightDone;
	Spawn:
		LAUN A -1;
		Stop;
	}

	action void Fire()
	{
		if (player == null)
		{
			return;
		}
		// Weapon weap = player.ReadyWeapon;
		// if (weap != null && invoker == weap && stateinfo != null && stateinfo.mStateType == STATE_Psprite)
		// {
		// 	if (!weap.DepleteAmmo (weap.bAltFire, true))
		// 		return;
		// }
		
		// SpawnPlayerMissile ("RwRocket");
		Actor actuallyFired, msl;
		[actuallyFired, msl] = A_FireProjectile(
			'RwRocket'
		);
		RwProjectile(msl).applyWeaponStats(RandomizedWeapon(invoker).stats);
		if (!actuallyFired) { // See comment on pointBlank() to understand what's happening here
			RwProjectile(msl).pointBlank();
		}
	}

	override void setBaseStats() {
		stats = New('RWStatsClass');
		stats.HorizSpread = 2.0;
		stats.VertSpread = 0.5;
		stats.Pellets = 1;
		stats.DamageDice = Dice.CreateNew(64, 2, 0);
		stats.firesProjectiles = true;

		stats.BaseExplosionRadius = 96;
		stats.ExplosionRadius = 96;

		rwBaseName = "Rocket Launcher";
    }
}

class RwRocket : RwProjectile
{
	Default
	{
		Radius 11;
		Height 8;
		Speed 20;
		Damage 0;
		Projectile;
		+RANDOMIZE
		+DEHEXPLOSION
		+ROCKETTRAIL
		+ZDOOMTRANS
		SeeSound "weapons/rocklf";
		DeathSound "weapons/rocklx";
		Obituary "$OB_MPROCKET";
	}
	States
	{
	Spawn:
		MISL A 1 Bright;
		Loop;
	Death:
		MISL B 8 Bright rwExplode();
		MISL C 6 Bright;
		MISL D 4 Bright;
		Stop;
	BrainExplode:
		MISL BC 10 Bright;
		MISL D 10 A_BrainExplode;
		Stop;
	}
}
