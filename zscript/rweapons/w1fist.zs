// Fist is not randomized (yet?) and is there only for damage scaling.
class RwFist : Weapon replaces Fist
{
	Default
	{
        Weapon.SlotNumber 1;
		Weapon.SelectionOrder 3700;
		Weapon.Kickback 100;
		Obituary "$OB_MPFIST";
		Tag "$TAG_FIST";
		+WEAPON.WIMPY_WEAPON
		+WEAPON.MELEEWEAPON
		+WEAPON.NOAUTOSWITCHTO
	}
	States
	{
	Ready:
		PUNG A 1 A_WeaponReady;
		Loop;
	Deselect:
		PUNG A 1 A_Lower;
		Loop;
	Select:
		TNT1 A 0 A_WeaponOffset(0, 0, WOF_KEEPY | WOF_INTERPOLATE); // Reset the X-offset which may be off because of reload
		PUNG A 1 A_Raise;
		Loop;
	Fire:
		PUNG B 4;
		PUNG C 4 RWA_Punch;
		PUNG D 5;
		PUNG C 4;
		PUNG B 5 A_ReFire;
		Goto Ready;
	}

    action void RWA_Punch() {
		FTranslatedLineTarget t;

		if (player != null) {
			Weapon weap = player.ReadyWeapon;
			if (weap != null && !weap.bDehAmmo && invoker == weap && stateinfo != null && stateinfo.mStateType == STATE_Psprite) {
				if (!weap.DepleteAmmo (weap.bAltFire))
					return;
			}
		}

		int damage = StatsScaler.ScaleIntValueByLevelRandomized(Random[punch](2, 20), RwPlayer(invoker.owner).infernoLevel);
		if (FindInventory("PowerStrength")) damage *= 10;

		double ang = angle + Random2[Punch]() * (5.625 / 256);
		double range = MeleeRange + MELEEDELTA;
		double pitch = AimLineAttack (ang, range, null, 0., ALF_CHECK3D);

		LineAttack (ang, range, pitch, damage, 'Melee', "BulletPuff", LAF_ISMELEEATTACK, t);

		// turn to face target
		if (t.linetarget) {
			A_StartSound ("*fist", CHAN_WEAPON);
			angle = t.angleFromSource;
		}
	}
}
