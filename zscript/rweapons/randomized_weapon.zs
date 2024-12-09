class RandomizedWeapon : DoomWeapon {

    mixin Affixable;

    string rwbaseName;
    RWStatsClass stats;

    Default {
        Weapon.AmmoUse 1; // We use custom ammo usage routine anyway
        Weapon.AmmoGive 0; // Ammo is dropped separately so that the player doesn't have to "press use to pick it up"
    }

    virtual void setBaseStats() {
        // Should be overridden
        debug.panicUnimplemented(self);
    }

    // Needed if a weapon should be re-generated
    private void RW_Reset() {
        appliedAffixes.Clear();
        setBaseStats();
        nameWithAppliedAffixes = rwBaseName;
        // Currently buggy if clipSize is changed after the spawn. TODO: fix
        // if (stats.reloadable()) {
        //     currentClipAmmo = stats.clipSize;
        // }
    }

    // Needs to be called before generation
    virtual void prepareForGeneration() {
        stats.minDamage = StatsScaler.ScaleIntValueByLevelRandomized(stats.minDamage, generatedQuality);
        stats.maxDamage = StatsScaler.ScaleIntValueByLevelRandomized(stats.maxDamage, generatedQuality);
    }

    // Needs to be called after generation
    private void finalizeAfterGeneration() {
        currentClipAmmo = stats.clipSize;
        Kickback = stats.TargetKnockback; // TARGET kickback. It uses weapon's default mechanism for kickback... Maybe its needed to rewrite that
    }

    override void BeginPlay() {
        RW_Reset();
    }

    virtual string GetRandomFluffName() {
        return "AS/MD "..rnd.Rand(10, 100).."-"..rnd.Rand(10, 100);
    }

}