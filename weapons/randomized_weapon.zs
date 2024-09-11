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

    // All the arguments are there just because it's an override (so they're partially unused and it's on purpose)
    override bool checkAmmo(int fireMode, bool autoSwitch, bool requireAmmo, int ammocount)
	{
		let count1 = (Ammo1 != null) ? Ammo1.Amount : 0;
		let count2 = (Ammo2 != null) ? Ammo2.Amount : 0;
        if (count1 >= stats.ammoUsage) {
            return true;
        } else {
            if (autoSwitch) {
                MyPlayer(Owner).PickNewWeapon(null);
            }
            return false;
        }
	}

    // All the arguments are there just because it's an override (so they're partially unused and it's on purpose)
    override bool depleteAmmo(bool altFire, bool checkEnough, int ammouse, bool forceammouse) {
        if (stats.freeShotPeriod > 0) {
            shotsSinceLastFreeShot++;
        }
        if (stats.freeShotPeriod > 0 && shotsSinceLastFreeShot % stats.freeShotPeriod == 0) {
            shotsSinceLastFreeShot = 0; // and don't consume ammo!
            return true;
        } else {
            if (checkAmmo(0, true, true, stats.ammoUsage)) {
                Ammo1.Amount -= stats.ammoUsage;
                return true;
            } else {
                return false;
            }
        }
    }

    action void RWA_FireBullets() {
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

}