extend class RwPlayerStats {

    const MeleeDamageLevelCost = 1;
    const maxBaseMeleeDamageLevel = 100; // Promille

    int baseMeleeDamageLevel;

    bool canIncreaseBaseMeleeDamageLevel() {
        return statPointsAvailable >= MeleeDamageLevelCost;
    }

    void doIncreaseBaseMeleeDamageLevel() {
        statPointsAvailable -= MeleeDamageLevelCost;
        baseMeleeDamageLevel += 1;
    }

    ////////////////////////////////////////////////////
    // Stat effect itself
    int RollBaseMeleeDamage() {
        int mindmg;
        int maxdmg;
        [mindmg, maxdmg] = GetMinAndMaxMeleeDamage();
        return Random[fist](mindmg, maxdmg);
    }

    const exponentBase = 2.15; // That means "each 'multipliesEachLevels' of levels the value will be multiplied by exponentRateBase
    const multipliesEachLevels = 20.; // Each this many levels the value will be multiplied by exponentBase
    int, int GetMinAndMaxMeleeDamage() {
        // OG Doom melee damage is 2-20.
        // baseMeleeDamageLevel increases base min damage for 1 each 6 levels
        int minDamage = 2 + baseMeleeDamageLevel/6;
        // baseMeleeDamageLevel also increases base max damage for 1 each 5 levels
        int maxDamage = 20 + baseMeleeDamageLevel/5;
        return 
            int(double(minDamage) * exponentBase ** (double(baseMeleeDamageLevel) / multipliesEachLevels)),
            int(double(maxDamage) * exponentBase ** (double(baseMeleeDamageLevel) / multipliesEachLevels));
    }

    //////////////////////////////////////////
    // UI

    string getMeleeDamageLevelButtonName() {
        return String.Format("Fist damage level: %d", baseMeleeDamageLevel);
    }

    string getMeleeDamageLevelButtonDescription() {
        int mindmg;
        int maxdmg;
        [mindmg, maxdmg] = GetMinAndMaxMeleeDamage();
        return "This stat increases your overall fist damage."
                .."It has exponential grow, so the more points you put there, the bigger damage yield you receive.\n"
                .."Fist damage grows faster with levels than monsters' HP does with Inferno Levels.\n"
                .."Your current melee damage: "..mindmg.."-"..maxdmg;
    }
}