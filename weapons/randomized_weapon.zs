class RandomizedWeapon : DoomWeapon {

    mixin Affixable;

    string rwbaseName;
    RWStatsClass stats;
    int shotsSinceLastFreeShot;

    // Default {
    //     Weapon.AmmoUse 1; // We use custom ammo usage routine anyway
    // }

    virtual void setBaseStats() {
        // Should be overridden
    }

    // Needed if a weapon should be re-generated
    private void RW_Reset() {
        appliedAffixes.Resize(0);
        setBaseStats();
        if (stats.reloadable()) {
            currentClipAmmo = stats.clipSize;
        }
    }

    override void BeginPlay() {
        RW_Reset();
        Generate();
    }

    virtual string GetRandomFluffName() {
        static const string specialNames[] =
        {
            "Hell's Bane",
            "Destructor",
            "Terminator"
        };
        if (rnd.OneChanceFrom(5)) {
            return "AS/MD "..rnd.Rand(500, 800);
        }
        return specialNames[rnd.Rand(0, specialNames.Size()-1)];
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