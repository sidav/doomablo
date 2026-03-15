class RwuTheReason : RwUniqueWeaponBase
{
	Default
	{
        Weapon.SlotNumber 6;

		Weapon.SelectionOrder 1500;
		Weapon.AmmoType "Cell";
		Tag "$TAG_THEREASON";
		Inventory.PickupMessage "$GOT_THEREASON";
		Obituary "$OB_THEREASON";
		RwWeapon.Weight 10;
	}
	States
	{
	Ready:
		TNT1 A 0 RWA_ReloadOrSwitchIfEmpty;
		REPG A 1 RWA_WeaponReadyReload;
		Loop;
	Deselect:
		REPG A 1 A_Lower;
		Loop;
	Select:
		TNT1 A 0 A_WeaponOffset(0, 0, WOF_KEEPY | WOF_INTERPOLATE); // Reset the X-offset which may be off because of reload
		REPG A 1 A_Raise;
		Loop;
	Fire: // Spin-up
		REPG B 6 {
			A_StartSound("Repeater/Spinup", CHAN_WEAPON);
			RWA_ApplyRateOfFire();
		}
		REPG C 6 RWA_ApplyRateOfFire;
		REPG D 5 RWA_ApplyRateOfFire;
		REPG A 5 RWA_ApplyRateOfFire;
		REPG B 5 RWA_ApplyRateOfFire;
		REPG C 4 RWA_ApplyRateOfFire;
		REPG D 4 RWA_ApplyRateOfFire;
		REPG A 4 RWA_ApplyRateOfFire;
		TNT0 A 0 RWA_ReFire;
		Goto SpinDown;
	// Tapping the button now goes straight to spindown from initial burst.
	// Hold is much shorter and thus more responsive (you don't lose as much ammo after letting go of the trigger).
	// - dbrz
	Hold: // Skip there on ReFire
		REPG F 2 ShootAndApplyROF;
		REPG C 1 RWA_ApplyRateOfFire;
		REPG D 1 RWA_ApplyRateOfFire;
		REPG E 2 ShootAndApplyROF;
		REPG B 1 RWA_ApplyRateOfFire;
		REPG C 1 RWA_ApplyRateOfFire;
		REPG H 2 ShootAndApplyROF;
		REPG A 1 RWA_ApplyRateOfFire;
		REPG B 1 RWA_ApplyRateOfFire;
		REPG G 2 ShootAndApplyROF;
		REPG D 1 RWA_ApplyRateOfFire;
		REPG A 1 RWA_ApplyRateOfFire;
		TNT0 A 0 RWA_ReFire;
	// "Spin down" begins here
	SpinDown:
		REPG A 3 {
			A_StartSound("Repeater/Spindown", CHAN_WEAPON);
			RWA_ApplyRateOfFire();
		}
		REPG B 3 RWA_ApplyRateOfFire;
		REPG C 4 RWA_ApplyRateOfFire;
		REPG D 4 RWA_ApplyRateOfFire;
		REPG A 4 RWA_ApplyRateOfFire;
		REPG B 5 RWA_ApplyRateOfFire;
		REPG C 5 RWA_ApplyRateOfFire;
		REPG D 6 RWA_ApplyRateOfFire;
		Goto Ready;
	Reload:
		REPG AAAAAAAAAA 1 A_WeaponOffset(-3, 2, WOF_ADD | WOF_INTERPOLATE);
		REPG A 15 {
			RWA_ApplyReloadSpeed();
			A_WeaponOffset(-6, 0, WOF_ADD | WOF_INTERPOLATE);
		}
		REPG ABCDABC 5 RWA_ApplyReloadSpeed;
		REPG D 15 {
			RWA_ApplyReloadSpeed();
			A_WeaponOffset(0, 5, WOF_ADD | WOF_INTERPOLATE);
		}
		REPG A 10 {
			RWA_ApplyReloadSpeed();
			A_StartSound("misc/w_pkup");
            A_MagazineReload(); //do the reload
			A_WeaponOffset(6, -5, WOF_ADD | WOF_INTERPOLATE);
		}
		REPG AAAAAAAAAA 1 A_WeaponOffset(3, -2, WOF_ADD | WOF_INTERPOLATE);
		REPG A 5;
		Goto Ready;
	Flash:
		Goto LightDone;
	Spawn:
		REPG I -1;
		Stop;
	}

	action void ShootAndApplyROF() {
		RWA_ApplyRateOfFire();
		if (invoker.currentClipAmmo < invoker.stats.ammoUsage) {
            return;
        }
		invoker.depleteAmmo(false, true, invoker.stats.ammoUsage, true);
		A_Light1();
		A_StartSound("Repeater/Fire", CHAN_WEAPON);
        for (let pellet = 0; pellet < invoker.stats.Pellets; pellet++) {
			int dmg = RWA_RollDamage();
			A_RailAttack(
				dmg,
				spawnofs_xy: 0,
				useammo: false,
				color1: 0xAA0000,
				color2: 0xAAAA00,
				flags: RGF_FULLBRIGHT | RGF_SILENT,
				maxdiff: 0.5,
				pufftype: "BulletPuff",
				spread_xy: invoker.stats.HorizSpread,
				spread_z: invoker.stats.VertSpread,
				range: 0,
				duration: 15,
				sparsity: 1.5,
				driftspeed: 0.6,
				spawnofs_z: 5.0,
				spiraloffset: 270,
				limit: 0 // Max number of "piercable" actors. 0 is infinite. TODO: use this in affixes.
			);
		}
		Thrust(-invoker.stats.ShooterKickback);
        RWA_ApplyRecoil();
	}

	override void prepareForGeneration() {
		super.prepareForGeneration();
		appliedAffixes.push(RwFluffAffix.Create("I assure you... They will listen to the Reason."));
		appliedAffixes.push(RwFluffAffix.Create("UAC PROTOTYPE: NOT FOR TESTING IN POPULATED AREAS"));
	}

	override void setBaseStats() {
		stats = RWStatsClass.NewWeaponStats(
			minDmg: 50, 
			maxDmg: 75,
			pell: 1,
			ammousg: 5,
			hSpr: 0.5,
			vSpr: 0.3
		);
		stats.fireType = stats.FTRailgun;
		stats.clipSize = stats.ammoUsage * 50;

		stats.recoil = 1.0;
		stats.additionalCritDamagePromille = 250;
		stats.ShooterKickback = 2.0;
		stats.TargetKnockback = 0;
		rwBaseName = "The Reason";
    }
}
