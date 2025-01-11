class RwPlayerStats {
    enum StatType {
		StatVitality,
		StatCritChance,
		StatCritDmg,
		StatMeleeDmg,
        StatRareFind
	}
    const totalStatsCount = 5;
    int baseStats[totalStatsCount];

    int statPointsAvailable;
    bool statsChanged; // True if stats need to be re-applied to Player

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
        newStats.statsChanged = true;
        return newStats;
    }

    // Full crit logic in a single func (maybe it's slow?)
    int rollAndModifyDamageForCrit(int initialDamage) {
        // Roll for crit chance itself first
        if (rollCritChance()) {
            return getCritDamageFor(initialDamage);
        }
        return initialDamage;
    }
}
