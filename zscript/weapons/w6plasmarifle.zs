class RwPlasmaRifle : RandomizedWeapon
{
	Default
	{
		Weapon.SlotNumber 6;

		Weapon.SelectionOrder 100;
		Weapon.AmmoGive 40;
		Weapon.AmmoType "Cell";
		Inventory.PickupMessage "$GOTPLASMA";
		Tag "$TAG_PLASMARIFLE";
	}
	States
	{
	Ready:
		TNT1 A 0 RWA_ReloadOrSwitchIfEmpty;
		PLSG A 1 RWA_WeaponReadyReload;
		Loop;
	Deselect:
		PLSG A 1 A_Lower;
		Loop;
	Select:
		PLSG A 1 A_Raise;
		Loop;
	Fire:
		PLSG A 3 {
			RWA_ApplyRateOfFire();
			Fire();
		}
		PLSG B 20 RWA_ReFire;
		Goto Ready;
	Reload:
		PLSG BBBBBBBBBB 1 A_WeaponOffset(-3, 2, WOF_ADD);
		PLSG B 15 {
			RWA_ApplyReloadSpeed();
			A_WeaponOffset(-6, 0, WOF_ADD);
		}
		PLSG B 15 {
			RWA_ApplyReloadSpeed();
			A_WeaponOffset(0, 5, WOF_ADD);
		}
		PLSG B 10 {
			RWA_ApplyReloadSpeed();
			A_StartSound("misc/w_pkup");
            A_MagazineReload(); //do the reload
			A_WeaponOffset(6, -5, WOF_ADD);
		}
		PLSG BBBBBBBBBB 1 A_WeaponOffset(3, -2, WOF_ADD);
		PLSG B 5;
		Goto Ready;
	Flash:
		PLSF A 4 Bright {
			RWA_ApplyRateOfFireToFlash();
			A_Light1();
		}
		Goto LightDone;
		PLSF B 4 Bright {
			RWA_ApplyRateOfFireToFlash();
			A_Light1();
		}
		Goto LightDone;
	Spawn:
		PLAS A -1;
		Stop;
	}

    override void setBaseStats() {
		stats = RWStatsClass.NewWeaponStats(
			5, 30,
			1,
			1,
			5.0,
			1.0
		);
		stats.clipSize = 20;
		stats.firesProjectiles = true;
		stats.projClass = 'RwPlasmaBall';
		rwBaseName = "Plasma rifle";
    }

    action void Fire() {
		State flash = invoker.FindState('Flash');
		if (flash != null) {
			player.SetSafeFlash(invoker, flash, random[FirePlasma](0, 1));
		}

		RWA_DoFire();
	}
}

class RwPlasmaBall : RwProjectile
{
	Default
	{
		Radius 13;
		Height 8;
		Speed 25;
		Projectile;
		+RANDOMIZE
		+ZDOOMTRANS
		RenderStyle "Add";
		Alpha 0.75;
		SeeSound "weapons/plasmaf";
		DeathSound "weapons/plasmax";
		Obituary "$OB_MPPLASMARIFLE";
	}
	States
	{
	Spawn:
		PLSS AB 6 Bright;
		Loop;
	Death:
		PLSE ABCDE 4 Bright;
		Stop;
	}
}
