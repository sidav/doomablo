extend class RandomizedWeapon {

    int damageFractionAccumulator; // needed so that damage values like 4.1 are properly accounted
    // int totalRolls; // Debug; delete this
    action int RWA_RollDamage() {
        // invoker.totalRolls++;
        let dmg = random(invoker.stats.minDamage, invoker.stats.maxDamage);
        dmg *= (1000 + invoker.stats.additionalDamagePromille); // We're working with promille here, so multiply
        invoker.damageFractionAccumulator += dmg;

        // if (invoker.damageFractionAccumulator / 1000 != dmg / 1000) {
        //     debug.print("Rolled damage is "..(dmg / 1000).."; new damage is "
        //         ..(invoker.damageFractionAccumulator / 1000).."; occured after "..invoker.totalRolls.." rolls."
        //         .." Additional damage is "..invoker.stats.additionalDamagePromille
        //     );
        //     invoker.totalRolls = 0;
        // }

        dmg = invoker.damageFractionAccumulator / 1000;
        invoker.damageFractionAccumulator = invoker.damageFractionAccumulator % 1000; // Store only the fraction in the accumulator

        // debug.print("Rolled "..dmg.." damage");
        for (int i = 0; i < invoker.appliedAffixes.Size(); i++) {
            dmg = invoker.appliedAffixes[i].modifyRolledDamage(dmg, RwPlayer(invoker.owner));
        }
        // debug.print("Modified to "..dmg.." damage");
        return dmg;
    }

    action void RWA_DoFire() {
        Thrust(-invoker.stats.ShooterKickback);
        if (invoker.stats.firesProjectiles) {
            RWA_FireProjectile();
        } else {
            RWA_FireBullets();
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

        for (let pellet = 0; pellet < invoker.stats.Pellets; pellet++) {
            Actor actuallyFired, msl;
            [actuallyFired, msl] = A_FireProjectile(
                invoker.stats.projClass,
                angle: rnd.randf(-invoker.stats.HorizSpread, invoker.stats.HorizSpread),
                useammo: false,
                flags: FPF_NOAUTOAIM,
                pitch: rnd.randf(-invoker.stats.VertSpread, invoker.stats.VertSpread)
            );

            RwProjectile(msl).applyWeaponStats(invoker);

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