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