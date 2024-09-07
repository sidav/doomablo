class RWStatsClass {
    Dice DamageDice;
    int Pellets;
    float HorizSpread;
    float VertSpread;
    int rofModifier; // Currently it's percentage modifier. 25 means the weapon fires 25% faster (75% base speed), -25 means 125% base speed.

    // Projectile-specific
    bool firesProjectiles;
    int projSpeedPercModifier;
    int ExplosionRadius;

    int BaseExplosionRadius; // Should be set and not modified; it's used for explosion sprite scaling calculation.

    int minDamage() {
        return DamageDice.MinRollPossible();
    }

    int maxDamage() {
        return DamageDice.MaxRollPossible();
    }

    int rollDamage() {
        return DamageDice.Roll();
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
}