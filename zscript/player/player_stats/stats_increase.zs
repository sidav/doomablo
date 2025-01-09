extend class RwPlayerStats {
    bool canStatBeIncreased(int id) {
        if (statPointsAvailable < 1) return false;
        switch (id) {
            case StatVitality: 
                return baseStats[id] < 250;
            case StatCritChance: 
                return baseStats[id] < 100;
            case StatCritDmg: 
                return baseStats[id] < 100;
            case StatMeleeDmg: 
                return baseStats[id] < 100;
            case StatRareFind:
                return baseStats[id] < 100;
        }
        debug.print("Unknown stat to increase: "..id);
        return false;
    }

    void doIncreaseStat(int id) {
        statPointsAvailable--;
        baseStats[id]++;
        statsChanged = true;
    }
}