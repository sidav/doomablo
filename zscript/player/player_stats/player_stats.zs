class RwPlayerStats {
    int statPointsAvailable;

    // True if stats need to be re-applied to Player
    bool statsChanged;

    static RwPlayerStats Create() {
        let newStats = new('RwPlayerStats');
        newStats.currentExpLevel = 1;
        newStats.currentExperience = 0;
        newStats.statPointsAvailable = 0;
        newStats.baseVitality = 100;
        newStats.baseCritChancePromille = 0;
        newStats.baseCritDmgFactorPromille = 1250;
        newStats.baseMeleeDamageLevel = 1;
        newStats.baseRareFindChance = 0;
        newStats.statsChanged = true;
        return newStats;
    }

    int rollAndModifyDamageForCrit(int initialDamage) {
        // Roll for crit chance itself first
        if (Random(0, 1000) < baseCritChancePromille) {
            return (initialDamage * baseCritDmgFactorPromille + 500) / 1000;
        }
        return initialDamage;
    }
}

// (re)application of the stats
extend class RwPlayer {
    void reapplyPlayerStats() {
        if (stats == null) {
            stats = RwPlayerStats.Create();
        }
        if (!stats.statsChanged) return;
        stats.statsChanged = false;

        // Apply max health
        let initialMaxHp = MaxHealth;
        MaxHealth = stats.GetMaxHealth();
        GiveBody(MaxHealth - initialMaxHp, MaxHealth);
    }
}
