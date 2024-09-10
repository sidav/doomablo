class RandomizedWeapon : DoomWeapon {

    mixin Affixable;

    string rwFullName; // Needed for HUD
    string rwbaseName;
    RWStatsClass stats;
    int shotsSinceLastFreeShot;

    // Default {
    //     Weapon.AmmoUse 1; // We use custom ammo usage routine anyway
    // }

    virtual void setBaseStats() {
        // Should be overridden
    }

    override void BeginPlay() {
        setBaseStats();
        Generate();
        SetDescriptionString();
    }

    action void RWA_FireBullets() {
        if (invoker.stats.freeShotPeriod > 0) {
            invoker.shotsSinceLastFreeShot++;
        }
        if (invoker.stats.freeShotPeriod > 0 && invoker.shotsSinceLastFreeShot % invoker.stats.freeShotPeriod == 0) {
            invoker.shotsSinceLastFreeShot = 0; // and don't consume ammo!
        } else if (!invoker.DepleteAmmo(invoker.bAltFire, true, invoker.stats.ammoUsage, true)) {
            MyPlayer(invoker.Owner).PickNewWeapon(null);
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

}