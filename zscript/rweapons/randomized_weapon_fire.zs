extend class RwWeapon {

    int damageFractionAccumulator; // needed so that damage values like 4.1 are properly accounted
    action int RWA_RollDamage() {

        let dmg = Random[weaponDamageRoll](invoker.stats.minDamage, invoker.stats.maxDamage);
        // Fixed-point damage calculation with promille modifier:
        dmg *= (1000 + invoker.stats.additionalDamagePromille); // We're working with promille here, so multiply
        invoker.damageFractionAccumulator += dmg;
        dmg = invoker.damageFractionAccumulator / 1000;
        invoker.damageFractionAccumulator = invoker.damageFractionAccumulator % 1000; // Store only the fraction in the accumulator

        // debug.print("Rolled "..dmg.." damage");
        let plr = RwPlayer(invoker.owner);
        for (int i = 0; i < invoker.appliedAffixes.Size(); i++) {
            dmg = invoker.appliedAffixes[i].modifyRolledDamage(dmg, plr);
        }
        // debug.print("Modified to "..dmg.." damage");

        // Crit chance logic
        dmg = plr.stats.rollAndModifyDamageForCrit(dmg, invoker.stats.additionalCritDamagePromille);

        return dmg;
    }

    action void RWA_DoFire() {
        Thrust(-invoker.stats.ShooterKickback);
        switch (invoker.stats.fireType) {
            case RWStatsClass.FTHitscan: RWA_FireBullets(); break;
            case RWStatsClass.FTProjectile: RWA_FireProjectile(); break;
            case RwStatsClass.FTArcingProjectile: RWA_FireProjectile(); break;
            default: debug.print("REPORT THIS: unknown fire type for this weapon");
        }
        RWA_ApplyRecoil();
    }

    private action void RWA_FireBullets() {
        if (!invoker.depleteAmmo(false, true, invoker.stats.ammoUsage, true)) {
            return;
        }

        for (let pellet = 0; pellet < invoker.stats.Pellets; pellet++) {
			int dmg = RWA_RollDamage();
			A_FireBullets(
				invoker.stats.HorizSpread, invoker.stats.VertSpread, 
				-1, // Number of pellets -1 fires one bullet, but the spread is always applied, even if it's the first bullet. 
				dmg,
				'BulletPuff',
				FBF_NORANDOM, // FBF_NORANDOM is required to inhibit default randomization logic. FBF_USEAMMO is disabled on purpose.
				0, // Range,
				null // Missile (e.g. 'PlasmaBall')
				// double Spawnheight
				// double Spawnofs_xy
			);
		}
    }

    private action void RWA_FireProjectile() {
        if (player == null) {
			return;
		}

        if (!invoker.depleteAmmo(false, true, invoker.stats.ammoUsage, true)) {
            return;
        }

        int flags = FPF_NOAUTOAIM;
        if (invoker.stats.levelOfSeekerProjectile > 0) {
            flags = FPF_AIMATANGLE; // Disable NOAUTOAIM so that projectiles will acquire a target on being fired.
            // FPF_AIMATANGLE is an alternate targeting method, should be helpful as well
        }
        for (let pellet = 0; pellet < invoker.stats.Pellets; pellet++) {
            Actor actuallyFired, msl;

            let rndPitch = rnd.randf(-invoker.stats.VertSpread, invoker.stats.VertSpread);
            if (invoker.stats.fireType == RwStatsClass.FTArcingProjectile) {
                rndPitch -= 6.0; // Arc-firing projectiles always shoot this many degrees up from center
            }

            [actuallyFired, msl] = A_FireProjectile(
                invoker.stats.projClass,
                angle: rnd.randf(-invoker.stats.HorizSpread, invoker.stats.HorizSpread),
                useammo: false,
                flags: flags,
                pitch: rndPitch
            );

            RwProjectile(msl).applyWeaponStats(invoker);
            foreach (aff : invoker.appliedAffixes) {
                aff.onProjectileSpawnedByPlayer(RwProjectile(msl), RwPlayer(invoker.owner));
            }

            if (!actuallyFired) { // See comment on pointBlank() to understand what's happening here
                RwProjectile(msl).pointBlank();
            }
        }
    }

    // TODO: call it from weapon's states?
    // TODO: Return to normal (from weapon's states too)?
    action void RWA_ApplyRecoil(bool randomPitchDirection = false) {
        double pitchChange = invoker.stats.recoil;
        if (randomPitchDirection && rnd.OneChanceFrom(2)) {
            pitchChange = -pitchChange;
        }
        if (pitch - pitchChange < 85.0) {
            pitch -= pitchChange;
        }
        angle += rnd.randf(-invoker.stats.recoil/2, invoker.stats.recoil/2);
    }
}