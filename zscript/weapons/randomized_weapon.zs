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
        appliedAffixes.Clear();
        setBaseStats();
        nameWithAppliedAffixes = rwBaseName;
        // Currently buggy if clipSize is changed after the spawn. TODO: fix
        // if (stats.reloadable()) {
        //     currentClipAmmo = stats.clipSize;
        // }
    }

    override void BeginPlay() {
        RW_Reset();
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

}