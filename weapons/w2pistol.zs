class rwPistol : RandomizedWeapon
{
	Default
	{
		Weapon.WeaponScaleX 1.5;
		Weapon.WeaponScaleY 1;
		Weapon.SlotNumber 2;

		Weapon.SelectionOrder 1900;
		Weapon.AmmoUse 1;
		Weapon.AmmoGive 0;
		Weapon.AmmoType "Clip";
		Obituary "$OB_MPPISTOL";
		+WEAPON.WIMPY_WEAPON
		Inventory.PickupMessage "$GOTPISTOL";
		Tag "$TAG_PISTOL";
	}
	States
	{
	Ready:
		PISG A 1 A_WeaponReady;
		Loop;
	Deselect:
		PISG A 1 A_Lower;
		Loop;
	Select:
		PISG A 1 A_Raise;
		Loop;
	Fire:
		PISG A 4 RWA_ApplyRateOfFire();
		PISG B 6 {
			RWA_ApplyRateOfFire();
			// action void A_FireBullets(double spread_xy, double spread_z, int numbullets, int damageperbullet, class<Actor> pufftype = "BulletPuff", int flags = 1, double range = 0, class<Actor> missile = null, double Spawnheight = 32, double Spawnofs_xy = 0) 
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
			A_StartSound("weapons/pistol", CHAN_WEAPON);
			A_GunFlash();
		}
		PISG C 4 RWA_ApplyRateOfFire();
		PISG B 5 {
			A_ReFire();
			RWA_ApplyRateOfFire();
		}
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
			4, 6,
			1,
			2.0,
			0.5
		);
		rwBaseName = "Pistol";
    }
}
