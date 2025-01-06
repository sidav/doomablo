extend class RwPlayer {

    int currentExperience;
    int currentExpLevel;
    int statPointsAvailable;

    void ReceiveExperience(int amount) {
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

    clearscope int getRequiredXPForNextLevel() {
        return getRequiredXPForLevel(currentExpLevel);
    }

    clearscope int getXPPercentageForNextLevel() {
        return math.getIntFractionInPercent(currentExperience, max(getRequiredXPForNextLevel(), 1));
    }

    const expExponentBase = 1.5; // That means "each 'multipliesEachLevels' of levels the value will be multiplied by exponentRateBase
    const ExpMultipliesEachLevels = 4.; // Each this many levels the value will be multiplied by exponentBase
    const baseAmount = 250.;
    clearscope static int getRequiredXPForLevel(int level) {
        if (level < 3) {
            return baseAmount;
        }
        return int(baseAmount * (expExponentBase ** (double(level) / ExpMultipliesEachLevels)));
    }

    // Old formula:
    // const M = 500.; // Scaling of XP values.
    // const K = 2.5; // The progression speed.
    // clearscope static int getRequiredXPForLevel(int level) {
    //     return M * ((double(level)/K) ** 2);
    // }
}

class ExperienceHandler : EventHandler
{
    override void WorldThingDied(WorldEvent e) {
        // Don't give XP from barrels or from enemies which aren't counted as kills
        if (e.Thing is 'ExplosiveBarrel' || !e.Thing.bCOUNTKILL) {
            return;
        }
        RwPlayer(Players[0].mo).ReceiveExperience(e.Thing.GetMaxHealth());
    }
}
