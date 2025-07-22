class RwRailgun : RwWeapon
{
	Default
	{
		Weapon.SlotNumber 6;
		Weapon.SelectionOrder 80;
		Weapon.AmmoType "Cell";
		Inventory.PickupMessage "$GOTRAILGUN";
		Tag "$TAG_RAILGUN";

		RwWeapon.Weight 7;
	}
	States
	{
	Ready:
		TNT1 A 0 RWA_ReloadOrSwitchIfEmpty;
		RLGG A 1 RWA_WeaponReadyReload;
		Loop;
	Deselect:
		RLGG A 1 A_Lower;
		Loop;
	Select:
		TNT1 A 0 A_WeaponOffset(0, 0, WOF_KEEPY | WOF_INTERPOLATE); // Reset the X-offset which may be off because of reload
		RLGG A 1 A_Raise;
		Loop;
	Fire:
		RLGF A 3 RWA_ApplyRateOfFire();
		RLGF B 4 {
			A_StartSound("Railgun/Railin", CHAN_WEAPON);
			RWA_ApplyRateOfFire();
			FireRailgun();
		}
		RLGG B 35 RWA_ApplyRateOfFire();
		Goto Ready;
	Reload:
		RLGG B 5 RWA_ApplyReloadSpeed();
		RLGG C 5 RWA_ApplyReloadSpeed();
		RLGG D 5 {
			A_StartSound("Railgun/Railout", CHAN_WEAPON);
			RWA_ApplyReloadSpeed();
		}
		RLGG E 3 RWA_ApplyReloadSpeed();
		RLGG F 30 RWA_ApplyReloadSpeed();
		RLGG G 5 RWA_ApplyReloadSpeed();
		RLGG H 5 RWA_ApplyReloadSpeed();
		RLGG I 3 RWA_ApplyReloadSpeed();
		RLGG I 14 {
			A_StartSound("Railgun/Railbuzz", CHAN_WEAPON);
			RWA_ApplyReloadSpeed();
			A_MagazineReload();
		}
		RLGG J 3 RWA_ApplyReloadSpeed();
		Goto Ready;
	Flash:
		TNT1 A 1 Bright {
			RWA_ApplyRateOfFireToFlash();
			A_Light1();
		}
		Goto LightDone;
	Spawn:
		RLGP A -1;
		Stop;
	}

	action void FireRailgun() {
		if (!invoker.depleteAmmo(false, true, invoker.stats.ammoUsage, true)) {
            return;
        }

        for (let pellet = 0; pellet < invoker.stats.Pellets; pellet++) {
			int dmg = RWA_RollDamage();
			A_RailAttack(
				dmg,
				spawnofs_xy: 0,
				useammo: false,
				color1: 0x00AAAA,
				color2: 0x0000AA,
				flags: RGF_FULLBRIGHT,
				maxdiff: 0.5,
				pufftype: "BulletPuff",
				spread_xy: invoker.stats.HorizSpread,
				spread_z: invoker.stats.VertSpread,
				range: 0,
				duration: 50,
				sparsity: 0.85,
				driftspeed: 0.6,
				spawnofs_z: 5.0,
				spiraloffset: 270,
				limit: 0 // Max number of "piercable" actors. 0 is infinite. TODO: use this in affixes.
			);
		}
		Thrust(-invoker.stats.ShooterKickback);
        RWA_ApplyRecoil();
	}

    override void setBaseStats() {
		stats = RWStatsClass.NewWeaponStats(
			minDmg: 75, maxDmg: 125,
			pell: 1,
			ammousg: 10,
			hSpr: 0.5,
			vSpr: 0.5
		);
		stats.fireType = stats.FTRailgun;

		stats.recoil = 3.5;
		stats.ShooterKickback = 5.0;
		stats.TargetKnockback = 0;
		stats.clipSize = stats.ammoUsage * 3;
		rwBaseName = "Railgun";
    }

	override string GetRandomFluffName() {
        static const string specialNames[] =
        {
			"ASMD",
			"Coilgun",
            "Gaussgewehr",
			"Hyper-velocity gun",
			"Lorenz force gun",
			"EM field accelerator"
        };
        return specialNames[rnd.randn(specialNames.Size())];
    }
}
