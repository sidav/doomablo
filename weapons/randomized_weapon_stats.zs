class RWStatsClass {
    int minDamage;
    int maxDamage;
    int Pellets;
    float HorizSpread;
    float VertSpread;
    int rofModifier; // Currently it's percentage modifier. 25 means the weapon fires 25% faster (75% base speed), -25 means 125% base speed.

    // Projectile-specific
    bool firesProjectiles;
    int projSpeedPercModifier;
    int ExplosionRadius;

    int BaseExplosionRadius; // Should be set and not modified; it's used for explosion sprite scaling calculation.

    static RWStatsClass NewWeaponStats(int minDmg, int maxDmg, int pell, float hSpr, float vSpr) {
        let rws = New('RwStatsClass');
        rws.minDamage = minDmg;
        rws.maxDamage = maxDmg;
        rws.Pellets = pell;
        rws.HorizSpread = hSpr;
        rws.VertSpread = vSpr;
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

    int rollDamage() {
        return random(minDamage, maxDamage); // DamageDice.Roll();
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