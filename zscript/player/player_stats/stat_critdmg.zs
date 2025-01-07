extend class RwPlayerStats {

    const CritDmgFactorPromilleCost = 1;
    const maxBaseCritDmgFactorPromille = 5000; // Promille

    int baseCritDmgFactorPromille;

    bool canIncreaseBaseCritDmgFactorPromille() {
        return statPointsAvailable >= CritDmgFactorPromilleCost && baseCritDmgFactorPromille < maxBaseCritDmgFactorPromille;
    }

    void doIncreaseBaseCritDmgFactorPromille() {
        statPointsAvailable -= CritDmgFactorPromilleCost;
        baseCritDmgFactorPromille += 5;
    }

    string getCritDmgFactorPromilleButtonName() {
        return String.Format("Crit damage: %.1f%%", double(baseCritDmgFactorPromille)/10);
    }

    string getCritDmgFactorPromilleButtonDescription() {
        return "Critical hit damage determines how much percent of damage your critical hits will deal."
                .." It is a base stat, which can be further modified by items.";
    }
}