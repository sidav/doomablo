extend class RwPlayerStats {
    bool canStatBeIncreased(int id) {
        if (statPointsAvailable < 1) return false;
        switch (id) {
            case StatVitality: 
                return GetMaxHealth() < 500;
            case StatCritChance: 
                return getCritChancePromille() < 1000;
            case StatCritDmg: 
                return getCritDmgPromille() < 5000;
            case StatMeleeDmg: 
                return baseStats[id] < 100;
            case StatRareFind:
                return baseStats[id] < 100;
        }
        debug.print("Unknown stat to increase: "..id);
        return false;
    }

    // This should be called by player level-up routines
    void doIncreaseBaseStat(int id) {
        statPointsAvailable--;
        baseStats[id]++;
        currentStats[id]++;
        baseStatsChanged = true;
    }

    // This should be called by stat-altering items
    void modifyCurrentStat(int id, int amount) {
        currentStats[id] += amount;
        // currentStats[id] = max(0, currentStats[id]);
    }
}