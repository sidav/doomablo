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

    int rollAndModifyDamageForCrit(int initialDamage) {
        // Roll for crit chance itself first
        if (Random(0, 1000) < baseCritChancePromille) {
            return (initialDamage * baseCritDmgFactorPromille + 500) / 1000;
        }
        return initialDamage;
    }

    int rollForIncreasedRarity(int initialRarity) {
        let chances = baseRareFindModifier / (2 ** initialRarity);
        if (Random(0, 1000) < chances) {
            initialRarity += 1;
        }
        return min(initialRarity, 5);
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
