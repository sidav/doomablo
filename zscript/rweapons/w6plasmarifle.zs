class RwPlasmaRifle : RwWeapon
{
	Default
	{
		Weapon.SlotNumber 6;

		Weapon.SelectionOrder 100;
		// Weapon.AmmoGive 40;
		Weapon.AmmoType "Cell";
		Inventory.PickupMessage "$GOTPLASMA";
		Tag "$TAG_PLASMARIFLE";
		RwWeapon.Weight 10;
	}
	States
	{
	Ready:
		TNT1 A 0 RWA_ReloadOrSwitchIfEmpty;
		PKPL A 1 RWA_WeaponReadyReload;
		Loop;
	Deselect:
		PKPL A 1 A_Lower;
		Loop;
	Select:
		TNT1 A 0 A_WeaponOffset(0, 0, WOF_KEEPY | WOF_INTERPOLATE); // Reset the X-offset which may be off because of reload
		PKPL A 1 A_Raise;
		Loop;
	Fire:
		TNT0 A 0 A_Jump(128, 2, 3, 4); // Select random frame to jump to.
		PLSF D 1 Bright {
			RWA_ApplyRateOfFire();
			Fire();
		}
		goto FireFrame2;
		PLSF C 1 Bright {
			RWA_ApplyRateOfFire();
			Fire();
		}
		goto FireFrame2;
		PLSF E 1 Bright {
			RWA_ApplyRateOfFire();
			Fire();
		}
		goto FireFrame2;
		PLSF F 1 Bright {
			RWA_ApplyRateOfFire();
			Fire();
		}
		goto FireFrame2;
	FireFrame2:
		TNT0 A 0 A_Jump(128, 2, 3, 4); // Select random frame to jump to.
		PLSF C 2 Bright RWA_ApplyRateOfFire();
		goto FireFrame3;
		PLSF D 2 Bright RWA_ApplyRateOfFire();
		goto FireFrame3;
		PLSF E 2 Bright RWA_ApplyRateOfFire();
		goto FireFrame3;
		PLSF F 2 Bright RWA_ApplyRateOfFire();
		goto FireFrame3;
	FireFrame3:
		TNT0 A 0 A_Jump(192, 2, 3, 4); // Select random frame to jump to.
		PLSF C 1 Bright RWA_ApplyRateOfFire();
		goto Cooling;
		PLSF D 1 Bright RWA_ApplyRateOfFire();
		goto Cooling;
		PLSF E 1 Bright RWA_ApplyRateOfFire();
		goto Cooling;
		PLSF F 1 Bright RWA_ApplyRateOfFire();
		goto Cooling;
	Cooling:
		PLSF C 4 RWA_ReFire;
		PKPL B 1 RWA_ApplyRateOfFire;
		PKPL C 2 RWA_ApplyRateOfFire;
		PKPL D 2 RWA_ApplyRateOfFire;
		PKPL E 14 RWA_ApplyRateOfFire;
		PKPL D 2 RWA_ApplyRateOfFire;
		PKPL C 2 RWA_ApplyRateOfFire;
		PKPL B 1 RWA_ApplyRateOfFire;
		Goto Ready;
	Reload:
		PKPL BCDE 4 A_WeaponOffset(-3, 2, WOF_ADD | WOF_INTERPOLATE);
		PKPL F 12 {
			RWA_ApplyReloadSpeed();
			A_WeaponOffset(-6, 0, WOF_ADD | WOF_INTERPOLATE);
		}
		PKPL G 15 {
			RWA_ApplyReloadSpeed();
			A_WeaponOffset(0, 5, WOF_ADD | WOF_INTERPOLATE);
		}
		PKPL F 12 {
			RWA_ApplyReloadSpeed();
			A_StartSound("misc/w_pkup");
            A_MagazineReload(); //do the reload
			A_WeaponOffset(6, -5, WOF_ADD | WOF_INTERPOLATE);
		}
		PKPL EDCB 3 A_WeaponOffset(3, -2, WOF_ADD | WOF_INTERPOLATE);
		PKPL A 5;
		Goto Ready;
	Flash:
		TNT0 A 3 Bright {
			RWA_ApplyRateOfFireToFlash();
			A_Light1();
		}
		Goto LightDone;
		TNT0 A 3 Bright {
			RWA_ApplyRateOfFireToFlash();
			A_Light2();
		}
		Goto LightDone;
	Spawn:
		PLAS A -1;
		Stop;
	}

	// action State SelectFireVariant() {
	// 	state fireVarState;
	// 	let fireVariant = random[FirePlasma](0, 3);
	// 	switch (fireVariant) {
	// 		case 0: return invoker.ResolveState('FireVariant0'); break;
	// 		case 1: return invoker.ResolveState('FireVariant1'); break;
	// 		case 2: return invoker.ResolveState('FireVariant2'); break;
	// 		case 3: return invoker.ResolveState('FireVariant3'); break;
	// 	}
	// 	return ResolveState('FireVariant0');
	// }

	action void Fire() {
		State flash = invoker.FindState('Flash');
		if (flash != null) {
			player.SetSafeFlash(invoker, flash, random[FirePlasma](0, 1));
		}

		RWA_DoFire();
	}

    override void setBaseStats() {
		stats = RWStatsClass.NewWeaponStats(
			10, 40,
			1,
			1,
			4.5,
			1.0
		);
		stats.fireType = stats.FTProjectile;
		stats.recoil = 0.1;
		stats.clipSize = 50;
		stats.projClass = 'RwPlasmaBall';
		rwBaseName = "Plasma rifle";
    }

	override string GetRandomFluffName() {
        static const string specialNames[] =
        {
			"Blaster",
            "Energizer",
            "Overloader",
            "Overcharger",
			"Plasmer",
			"Shocker",
			"Silencer",
			"Teaser"
        };
        return specialNames[rnd.randn(specialNames.Size())];
    }
}
