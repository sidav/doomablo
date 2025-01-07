class RwPlayerStats {
    int statPointsAvailable;

    int vitality;
    int critChancePromille;
    int critDamageFactorPromille;
    int rareFindModifier;

    bool statsChanged;

    static RwPlayerStats Create() {
        let newStats = new('RwPlayerStats');
        newStats.statPointsAvailable = 0;
        newStats.vitality = 100;
        newStats.critChancePromille = 0;
        newStats.critDamageFactorPromille = 1250;
        newStats.rareFindModifier = 0;
        newStats.statsChanged = true;
        return newStats;
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
        MaxHealth = stats.vitality;
        GiveBody(MaxHealth - initialMaxHp, MaxHealth);
    }
}
