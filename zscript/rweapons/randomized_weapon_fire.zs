extend class RandomizedWeapon {

    action int RWA_RollDamage() {
        let dmg = random(invoker.stats.minDamage, invoker.stats.maxDamage);
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
    private action void RWA_ApplyRecoil() {
        if (pitch - invoker.stats.recoil < 85.0) {
            pitch -= invoker.stats.recoil;
        }
        angle += rnd.randf(-invoker.stats.recoil/2, invoker.stats.recoil/2);
    }
}