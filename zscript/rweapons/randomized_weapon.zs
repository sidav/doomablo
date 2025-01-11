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
        let initialMaxDamage = stats.maxDamage;
        stats.minDamage = StatsScaler.ScaleIntValueByLevelRandomized(stats.minDamage, generatedQuality);
        stats.maxDamage = StatsScaler.ScaleIntValueByLevelRandomized(stats.maxDamage, generatedQuality);

        // First, compensate for the damage scaling (the target knockback is damage-dependent in DOOM).
        stats.TargetKnockback = max((initialMaxDamage * stats.TargetKnockback + stats.maxDamage/2) / stats.maxDamage, 1);
        // It is a TARGET kickback. It uses weapon's default mechanism for kickback... Maybe its needed to rewrite that
        Kickback = stats.TargetKnockback;
        // Set it for projectiles too.
        ProjectileKickback = stats.TargetKnockback;
    }

    // Needs to be called after generation
    private void finalizeAfterGeneration() {
        currentClipAmmo = stats.clipSize;
    }

    override void BeginPlay() {
        RW_Reset();
    }

    virtual string GetRandomFluffName() {
        return "AS/MD "..rnd.Rand(10, 100).."-"..rnd.Rand(10, 100);
    }

    override void ModifyDamage(int damage, Name damageType, out int newdamage, bool passive, Actor inflictor, Actor source, int flags) {
        // super.ModifyDamage(damage, damageType, newdamage, passive, inflictor, source, flags);

        // Un-scaling self damage from higher level splash:
        if (inflictor == null || inflictor.GetClass() != stats.projClass) {
            return;
        }
        if (owner == source && !passive) {
            newdamage = StatsScaler.UnscaleIntValueByLevel(damage, generatedQuality);
        }
    }

}