class RwRocketLauncher : RandomizedWeapon
{
	Default
	{
		Weapon.SlotNumber 5;

		Weapon.SelectionOrder 2500;
		Weapon.AmmoGive 100; // DEBUG: default was 2
		Weapon.AmmoType "RocketAmmo";
		+WEAPON.NOAUTOFIRE
		Inventory.PickupMessage "$GOTLAUNCHER";
		Tag "$TAG_ROCKETLAUNCHER";
	}
	States
	{
	Ready:
		TNT1 A 0 RWA_ReloadOrSwitchIfEmpty;
		MISG A 1 RWA_WeaponReadyReload;
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
			RWA_DoFire();
		}
		MISG B 0 RWA_ReFire;
		Goto Ready;
	Reload:
		MISG BBBBBBBBBB 1 A_WeaponOffset(-3, 1, WOF_ADD);
		MISG B 15 {
			RWA_ApplyReloadSpeed();
			A_WeaponOffset(-6, 0, WOF_ADD);
		}
		MISG B 15 {
			RWA_ApplyReloadSpeed();
			A_WeaponOffset(0, 5, WOF_ADD);
		}
		MISG B 15 {
			RWA_ApplyReloadSpeed();
			A_WeaponOffset(12, 3, WOF_ADD);
		}
		MISG A 10 {
			RWA_ApplyReloadSpeed();
			A_StartSound("misc/w_pkup");
            A_MagazineReload(); //do the reload
			A_WeaponOffset(-12, -3, WOF_ADD);
		}
		MISG A 10 {
			RWA_ApplyReloadSpeed();
			A_WeaponOffset(6, -5, WOF_ADD);
		}
		MISG AAAAAAAAAA 1 A_WeaponOffset(3, -1, WOF_ADD);
		MISG A 5;
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

	override void setBaseStats() {
		stats = RWStatsClass.NewWeaponStats(
			96, 128,
			1,
			1,
			2.0,
			0.5
		);

		stats.clipSize = 3;
		stats.firesProjectiles = true;
		stats.projClass = 'RwRocket';
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
