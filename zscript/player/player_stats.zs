class RwPlayerStats {
    int statPointsAvailable;

    // Base stats, i.e. before being modified by items
    int baseVitality;
    int baseCritChancePromille;
    int baseCritDmgFactorPromille;
    int baseRareFindModifier;

    // True if stats need to be re-applied to Player
    bool statsChanged;

    static RwPlayerStats Create() {
        let newStats = new('RwPlayerStats');
        newStats.statPointsAvailable = 0;
        newStats.baseVitality = 100;
        newStats.baseCritChancePromille = 0;
        newStats.baseCritDmgFactorPromille = 1250;
        newStats.baseRareFindModifier = 0;
        newStats.statsChanged = true;
        return newStats;
    }

    int GetMaxHealth() {
        return baseVitality;
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
