class RwPlayerStats {
    enum StatType {
		StatVitality,
		StatCritChance,
		StatCritDmg,
		StatMeleeDmg,
        StatRareFind,

        // HIDDEN STATS (not in any menus, given only by items):
        StatReloadSpeedBonus, // percentage
		StatRateOfFireBonus // percentage
	}
    const totalStatsCount = 7;
    int baseStats[totalStatsCount];
    int currentStats[totalStatsCount]; // Those are stats with modifiers

    int statPointsAvailable;
    bool baseStatsChanged; // True if stats need to be re-applied to Player

    static RwPlayerStats Create() {
        let newStats = new('RwPlayerStats');
        newStats.currentExpLevel = 1;
        newStats.currentExperience = 0;
        newStats.statPointsAvailable = 0;
        newStats.baseStats[StatVitality] = 0;
        newStats.baseStats[StatCritChance] = 0;
        newStats.baseStats[StatCritDmg] = 0;
        newStats.baseStats[StatMeleeDmg] = 0;
        newStats.baseStats[StatRareFind] = 0;
        newStats.baseStats[StatReloadSpeedBonus] = 0;
        newStats.baseStats[StatRateOfFireBonus] = 0;
        newStats.ResetCurrentStats();
        newStats.baseStatsChanged = true;
        return newStats;
    }

    void ResetCurrentStats() {
        for (let i = 0; i < baseStats.Size(); i++) {
            currentStats[i] = baseStats[i];
        }
    }

    int GetCurrentStat(int statIndex) {
        return currentStats[statIndex];
    }
}
