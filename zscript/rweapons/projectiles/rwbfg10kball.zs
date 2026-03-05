class RwBFG10KBall : RwProjectile
{
	Default
	{
		Radius 13;
		Height 32;
		Speed 10;
		Projectile;
		+RANDOMIZE
		+ZDOOMTRANS
		RenderStyle "Add";
		Alpha 0.75;
		DeathSound "weapons/bfgx";
		Obituary "$OB_MPBFG_BOOM";
	}
	States
	{
	Spawn:
		BFS1 AAABBB 1 Bright {
			RWA_SeekerMissile();
			FireBFG10kRays();
		}
		Loop;
	Death:
		BFE1 AB 8 Bright {
			if (rwExplosionRadius > 0) {
				rwExplode();
			}
		}
		BFE1 CDEF 8 Bright;
		Stop;
	}

	int RayDmgMin, RayDmgMax, additionalBfgRayDamagePromille;
	int rayDamageFractionAccumulator; // needed so that damage values like 4.1 are properly accounted
	IntFraction dmgFrac;

	override void applyWeaponStats(RwWeapon wpn) {
		super.applyWeaponStats(wpn);

		RayDmgMin = wpn.stats.RayDmgMin;
		RayDmgMax = wpn.stats.RayDmgMax;
		additionalBfgRayDamagePromille = wpn.stats.additionalBfgRayDamagePromille;

		dmgFrac = IntFraction.create(1000);
	}

	const ZAP_RANGE = 2048;
	action void FireBFG10kRays() {
		let beamstart = ArcSplitController.GetBeamAttachPos(invoker, 0, 0);
        let ti = ThinkerIterator.Create('Actor');
        Actor mo;
        while (mo = Actor(ti.next())) {
            if (
                (mo.bISMONSTER || mo is 'ExplosiveBarrel') &&
                mo.Health > 0 &&
                mo.player == null &&
                invoker.Distance2D(mo) <= ZAP_RANGE &&
                invoker.CheckSight(mo)
            ) {
				let dmg = Random[bfgray](invoker.RayDmgMin, invoker.RayDmgMax);
				dmg = invoker.dmgFrac.multiply(dmg, (1000+invoker.additionalBfgRayDamagePromille)/TICRATE);
                mo.damageMobj(null, null, dmg, 'Extreme');
                ArcSplitController.DrawLightning(beamstart, ArcSplitController.GetBeamAttachPos(mo), spawnSpark: false, color: 0x0000FF11);
            }
        }
	}
}
