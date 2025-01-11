extend class RwPlayerStats {
    int currentExpLevel;
    double currentExperience;

    void AddExperience(double amount) {
        currentExperience += amount;
        let required = getRequiredXPForNextLevel();
        while(currentExperience > 0 && currentExperience >= required) {
            currentExperience -= required;
            required = getRequiredXPForNextLevel();
            currentExpLevel++;
            statPointsAvailable++;
        }
    }

    ui int getCurrentExpLevel() {
        return currentExpLevel;
    }

    clearscope double getRequiredXPForNextLevel() {
        return getRequiredXPForLevel(currentExpLevel+1);
    }

    clearscope double getXPPercentageForNextLevel() {
        return (100. * currentExperience) / getRequiredXPForNextLevel();
    }

    clearscope string GetFullXpString() {
        return String.Format("EXP: %.0f/%.0f (%.1f%%)", 
            (currentExperience, getRequiredXPForNextLevel(), getXPPercentageForNextLevel())
        );
    }

    const expExponentBase = 1.275; // That means "each 'multipliesEachLevels' of levels the value will be multiplied by exponentRateBase
    const ExpMultipliesEachLevels = 6.; // Each this many levels the value will be multiplied by exponentBase
    const baseAmount = 500.;
    clearscope static double getRequiredXPForLevel(int level) {
        level -= 2;
        if (level < 0) {
            return 1;
        }
        double addition = double(level)*200.;
        return int((baseAmount + addition) * (expExponentBase ** (double(level) / ExpMultipliesEachLevels)));
    }

    // Old formula:
    // const M = 500.; // Scaling of XP values.
    // const K = 2.5; // The progression speed.
    // clearscope static int getRequiredXPForLevel(int level) {
    //     return M * ((double(level)/K) ** 2);
    // }
}