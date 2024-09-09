class rwShotgun : RandomizedWeapon
{
	Default
	{
		Weapon.WeaponScaleX 1.5;
        Weapon.SlotNumber 3;

		Weapon.SelectionOrder 1300;
		Weapon.AmmoGive 8;
		Weapon.AmmoType "Shell";
		Inventory.PickupMessage "$GOTSHOTGUN";
		Obituary "$OB_MPSHOTGUN";
		Tag "$TAG_SHOTGUN";
	}
	States
	{
	Ready:
		SHTG A 1 A_WeaponReady;
		Loop;
	Deselect:
		SHTG A 1 A_Lower;
		Loop;
	Select:
		SHTG A 1 A_Raise;
		Loop;
	Fire:
		SHTG A 3 RWA_ApplyRateOfFire();
		SHTG A 7 {
			RWA_ApplyRateOfFire();
			RWA_FireBullets();
			A_StartSound("weapons/shotgf", CHAN_WEAPON);
			A_GunFlash();
		}
		SHTG BC 5 RWA_ApplyRateOfFire();
		SHTG D 4 RWA_ApplyRateOfFire();
		SHTG CB 5 RWA_ApplyRateOfFire();
		SHTG A 3 RWA_ApplyRateOfFire();
		SHTG A 7 {
			A_ReFire();
			// RWA_ApplyRateOfFire();
		}
		Goto Ready;
	Flash:
		SHTF A 4 Bright {
			RWA_ApplyRateOfFireToFlash();
			A_Light1();
		}
		SHTF B 3 Bright {
			RWA_ApplyRateOfFireToFlash();
			A_Light2();
		}
		Goto LightDone;
	Spawn:
		SHOT A -1;
		Stop;
	}

	override void setBaseStats() {
		stats = RWStatsClass.NewWeaponStats(
			1, 5,
			7,
			1,
			12.5,
			3.0
		);
        rwBaseName = "Shotgun";
    }
}
