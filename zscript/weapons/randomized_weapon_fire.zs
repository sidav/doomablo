extend class RandomizedWeapon {

    action void RWA_DoFire() {
        Thrust(-invoker.stats.ShooterKickback);
        if (invoker.stats.firesProjectiles) {
            RWA_FireProjectile();
            return;
        }
        RWA_FireBullets();
    }

    private action void RWA_FireBullets() {
        if (!invoker.depleteAmmo(false, true, invoker.stats.ammoUsage, true)) {
            return;
        }

        for (let pellet = 0; pellet < invoker.stats.Pellets; pellet++) {
			int dmg = invoker.stats.rollDamage();
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

        for (let pellet = 0; pellet < invoker.stats.Pellets; pellet++) {
            Actor actuallyFired, msl;
            // TODO: understand why "if (!invoker.depleteAmmo()..." is not required here
            [actuallyFired, msl] = A_FireProjectile(invoker.stats.projClass);

            RwProjectile(msl).applyWeaponStats(RandomizedWeapon(invoker).stats);

            if (!actuallyFired) { // See comment on pointBlank() to understand what's happening here
                RwProjectile(msl).pointBlank();
            }
        }
    }
}