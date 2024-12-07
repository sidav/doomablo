class RWStatsClass {
    int minDamage;
    int maxDamage;
    int additionalDamagePromille; // 153 means "+15.3% damage". Made as a separate stat so that damage values like 4.1 are properly accounted
    int Pellets;
    float HorizSpread;
    float VertSpread;
    int rofModifier; // Currently it's percentage modifier. 25 means the weapon fires 25% faster (75% base speed), -25 means 125% base speed.
    int TargetKnockback; // Called "Kickback" in Doom
    double ShooterKickback; // Dunno if it is in Doom
    float Recoil; // In degrees.

    // Melee-specific
    bool isMelee;
    int attackRange; // currently used for melee only

    // Projectile-specific
    bool firesProjectiles;
    class <Actor> projClass;
    int projSpeedPercModifier;
    int ExplosionRadius;
    int BaseExplosionRadius; // Should be set and not modified; it's used for explosion sprite scaling calculation.
    bool noDamageToOwner;

    // Ammo specific
    int clipSize; // 0 means no clip (equals to infinite)
    int reloadSpeedModifier; // percentage, like rofModifier
    int ammoUsage;
    int freeShotChance; // Percentage chance that a shot will be free. Better for auto-shot weapons, may be useful for RL.

    // BFG-specific. I didn't want to put it here (not reusable), but it doesn't work otherwise :(
    int NumberOfRays;
	double RaysConeAngle;
	int RayDmgMin, RayDmgMax;
	bool raysWillOriginateFromMissile; // false means rays from shooter, like in vanilla Doom.

    static RWStatsClass NewWeaponStats(int minDmg, int maxDmg, int pell, int ammousg, float hSpr, float vSpr) {
        let rws = New('RwStatsClass');
        rws.minDamage = minDmg;
        rws.maxDamage = maxDmg;
        rws.Pellets = pell;
        rws.ammoUsage = ammousg;
        rws.HorizSpread = hSpr;
        rws.VertSpread = vSpr;
        rws.TargetKnockback = 128; // Default "Kickback" value from Doom is 100

        // TODO: Maybe remove those from here?..
        rws.ShooterKickback = 0.1; 
        rws.Recoil = 0.5;

        return rws;
    }

    void modifyDamageRange(int minMod, int maxMod) {
        minDamage += minMod;
        maxDamage += maxMod;
        if (minDamage > maxDamage) {
            let t = maxDamage;
            maxDamage = minDamage;
            minDamage = t;
        }
    }

    void increaseMinDamagePushingMax(int minMod) {
        minDamage += minMod;
        if (minDamage > maxDamage) {
            maxDamage = minDamage;
        }
    }

    bool reloadable() {
        return clipSize > 0;
    }

    float GetExplosionSpriteScale() {
        if (ExplosionRadius > 0 && BaseExplosionRadius == 0) {
            debug.panic("Unset BaseExplosionRadius setting!");
        }
        if (BaseExplosionRadius == 0) {
            return 1.0;
        }
        return float(ExplosionRadius)/float(BaseExplosionRadius);
    }

    float getProjSpeedFactor() {
        return float(100+projSpeedPercModifier)/100.0;
    }

    int getDamageSpread() {
        return maxDamage - minDamage;
    }
}