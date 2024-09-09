class rwPistol : RandomizedWeapon
{
	Default
	{
		Weapon.WeaponScaleX 1.5;
		Weapon.WeaponScaleY 1;
		Weapon.SlotNumber 2;

		Weapon.SelectionOrder 1900;
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
			RWA_FireBullets();
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
			1,
			2.0,
			0.5
		);
		rwBaseName = "Pistol";
    }
}
