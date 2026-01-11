class RwTurretItemStats : RwActiveSlotItemStats {
    int turretHealth;
    int turretLifeSeconds;
    int minDmg, maxDmg;
    int additionalDamagePromille; // 153 means "+15.3% damage". Made as a separate stat so that damage values like 4.1 are properly accounted

    clearscope float, float getFloatFinalDamageRange() {
        return
            float(minDmg * (1000 + additionalDamagePromille)) / 1000.,
            float(maxDmg * (1000 + additionalDamagePromille)) / 1000.;
    }
}