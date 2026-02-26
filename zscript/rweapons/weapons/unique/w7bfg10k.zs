class RwuBFG10K : RwUniqueWeaponBase
{
	Default {
		Radius 20;
		Height 20;
        Weapon.SlotNumber 7;
		Weapon.SelectionOrder 2500;
		Weapon.AmmoType "Cell";
		Tag "$TAG_BFG10K";
		Inventory.PickupMessage "$GOT_BFG10K";
		RwWeapon.Weight 10;
		+WEAPON.NOAUTOFIRE;
	}
	States {
		Spawn:
			BFG2 A -1;
			Stop;
		Ready:
			BG2G A 0 A_StartSound("Weapons/BFG10KIdle");
			BG2G AAABBBCCCDDD 1 A_WeaponReady();
			Loop;
		Deselect:
			BG2G E 1 A_Lower;
			Loop;
		Select:
			TNT1 A 0 A_WeaponOffset(0, 0, WOF_KEEPY | WOF_INTERPOLATE); // Reset the X-offset which may be off because of reload
			BG2G E 1 A_Raise;
			Loop;
		Fire:
			BG2G E 5 {
				RWA_ApplyRateOfFire();
				A_StartSound("Weapons/BFG10KF", CHAN_WEAPON);
			}
			BG2G FGHIJ 4 RWA_ApplyRateOfFire;
			BG2G EFGHIJ 3 RWA_ApplyRateOfFire;
			BG2G EFGHIJ 2 RWA_ApplyRateOfFire;
			BG2G EFGHIJ 1 RWA_ApplyRateOfFire;
			Goto Hold;
		Hold:
			BG2G K 2 Bright A_GunFlash;
			BG2G L 2 Bright RWA_DoFire;
			BG2G M 2 Bright RWA_ApplyRateOfFire;
			BG2G N 5 Bright RWA_ApplyRateOfFire;
			BG2G O 35 {
				A_StartSound("Weapons/BFG10KCool");
				RWA_ApplyRateOfFire();
			}
			Goto Ready;
		Flash:
			TNT1 A 2 Bright A_Light1();
			TNT1 A 3 bright;
			Goto LightDone;
	}

	// Scale rays damage too
	override void prepareForGeneration() {
		super.prepareForGeneration();
        stats.RayDmgMin = PlayerStatsScaler.ScaleIntValueByLevelRandomized(stats.RayDmgMin, generatedQuality);
        stats.RayDmgMax = PlayerStatsScaler.ScaleIntValueByLevelRandomized(stats.RayDmgMax, generatedQuality);
		appliedAffixes.push(RwFluffAffix.Create("Bitterman's favorite."));
		appliedAffixes.push(RwFluffAffix.Create("It worked on Strogg. Should work on demons as well."));
    }

	override void setBaseStats() {
		stats = RWStatsClass.NewWeaponStats(
			500, 750,
			1,
			100,
			0.0,
			0.0
		);
		stats.fireType = stats.FTProjectile;

		stats.recoil = 1.5;
		stats.ShooterKickback = 5.0;
		stats.clipSize = 0;
		stats.projClass = 'RwBFG10KBall';
		rwBaseName = "BFG10K";

		// Those are damage PER SECOND.
		stats.RayDmgMin = 125;
		stats.RayDmgMax = 150;
    }
}
