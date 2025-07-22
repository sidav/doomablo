extend class RwPlayerStats {

    ////////////////////////
    // Vitality
    int GetMaxHealth() {
        // 1.75 per level
        return 100 + (175 * (currentStats[StatVitality]) / 100);
    }

    // Shorthand: returns how many health is perc% of max health.
    int GetMaxHealthPercentage(int perc) {
        return math.getIntPercentage(GetMaxHealth(), perc);
    }

    /////////////////
    // Crit chance
    int getCritChancePromille() {
        // 7.5 promille per level
        return (currentStats[StatCritChance] * 75 + 5) / 10;
    }

    bool rollCritChance() {
        return Random[crit](0, 1000) < getCritChancePromille();
    }

    /////////////////
    // Crit damage
    int getCritDmgPromille() {
        // Base is 150%. +2.5% per level
        return 1500 + (currentStats[StatCritDmg] * 250 + 5) / 10;
    }

    int getCritDamageFor(int nonCritDamage) {
        return (nonCritDamage * getCritDmgPromille() + 500) / 1000;
    }

    // Full crit logic in a single func (maybe it's slow?)
    int rollAndModifyDamageForCrit(int initialDamage) {
        // Roll for crit chance itself first
        if (rollCritChance()) {
            return getCritDamageFor(initialDamage);
        }
        return initialDamage;
    }

    ///////////////////
    // Melee damage
    int RollBaseMeleeDamage() {
        int mindmg;
        int maxdmg;
        [mindmg, maxdmg] = GetMinAndMaxMeleeDamage();
        return Random[fist](mindmg, maxdmg);
    }

    const exponentBase = 2.0164; // That means "each 'multipliesEachLevels' of levels the value will be multiplied by exponentRateBase
    const multipliesEachLevels = 20.; // Each this many levels the value will be multiplied by exponentBase
    int, int GetMinAndMaxMeleeDamage() {
        // OG Doom melee damage is 2-20.
        // baseMeleeDamageLevel increases base min damage for 1 each 6 levels
        int minDamage = 2 + (currentStats[StatMeleeDmg]-1)/2;
        // baseMeleeDamageLevel also increases base max damage for 1 each 5 levels
        int maxDamage = 20 + currentStats[StatMeleeDmg]/2;
        return 
            int(double(minDamage) * exponentBase ** (double(currentExpLevel) / multipliesEachLevels)),
            int(double(maxDamage) * exponentBase ** (double(currentExpLevel) / multipliesEachLevels));
    }

    ///////////////////////
    // Rare find
    int getIncreaseRarityChancePromilleFor(int rarity) {
        // 2.05% per stat point
        let promilleForLowestRarity = (currentStats[StatRareFind] * 205 + 5) / 10;
        return min(promilleForLowestRarity / (2 ** rarity), 1000);
    }

    int rollForIncreasedRarity(int initialRarity) {
        let chances = getIncreaseRarityChancePromilleFor(initialRarity);
        if (Random(0, 1000) < chances) {
            initialRarity += 1;
        }
        return min(initialRarity, 5);
    }

}