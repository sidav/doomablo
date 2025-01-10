extend class RwPlayerStats {
    bool canStatBeIncreased(int id) {
        if (statPointsAvailable < 1) return false;
        switch (id) {
            case StatVitality: 
                return GetMaxHealth() < 300;
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

    void doIncreaseStat(int id) {
        statPointsAvailable--;
        baseStats[id]++;
        statsChanged = true;
    }
}