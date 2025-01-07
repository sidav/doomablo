extend class RwPlayerStats {

    const baseCritChancePromilleCost = 1;
    const maxBaseCritChancePromille = 1000; // Promille

    int baseCritChancePromille;

    bool canIncreaseBaseCritChancePromille() {
        return statPointsAvailable >= baseCritChancePromilleCost && baseCritChancePromille < maxBaseCritChancePromille;
    }

    void doIncreaseBaseCritChancePromille() {
        statPointsAvailable -= baseCritChancePromilleCost;
        baseCritChancePromille += 4;
    }

    string getCritChancePromilleButtonName() {
        return String.Format("Crit chance: %.1f%%", double(baseCritChancePromille)/10);
    }

    string getCritChancePromilleButtonDescription() {
        return "Critical hit chance determines the probability to deal increased damage with each hit."
                .." It is a base stat, which can be further modified by items.";
    }
}