extend class RwPlayerStats {

    const vitCost = 1;
    const maxBaseVitality = 250;

    int baseVitality;

    bool canIncreaseBaseVitality() {
        return statPointsAvailable >= vitCost;
    }

    void doIncreaseBaseVitality() {
        statPointsAvailable -= vitCost;
        baseVitality += 1;
        statsChanged = true;
    }

    // Stat effect itself
    int GetMaxHealth() {
        return baseVitality;
    }

    string getVitButtonName() {
        return String.Format("Vitality:   %d", baseVitality);
    }

    string getVitButtonDescription() {
        return String.Format("Each point of Vitality increases your maximum HP amount by 1.\nMax value: %d", (maxBaseVitality));
    }
}