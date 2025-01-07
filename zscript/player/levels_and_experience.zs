extend class RwPlayer {

    int currentExpLevel;
    double currentExperience;
    RwPlayerStats stats;

    void ReceiveExperience(int amount) {
        currentExperience += double(amount);
        let required = getRequiredXPForNextLevel();
        while(currentExperience > 0 && currentExperience >= required) {
            currentExperience -= required;
            required = getRequiredXPForNextLevel();
            currentExpLevel++;
            stats.statPointsAvailable++;
        }
    }

    ui int getCurrentExpLevel() {
        return currentExpLevel;
    }

    clearscope double getRequiredXPForNextLevel() {
        return getRequiredXPForLevel(currentExpLevel);
    }

    clearscope double getXPPercentageForNextLevel() {
        return (100. * currentExperience) / getRequiredXPForNextLevel();
    }

    const expExponentBase = 1.5; // That means "each 'multipliesEachLevels' of levels the value will be multiplied by exponentRateBase
    const ExpMultipliesEachLevels = 4.; // Each this many levels the value will be multiplied by exponentBase
    const baseAmount = 500.;
    clearscope static double getRequiredXPForLevel(int level) {
        level -= 1;
        if (level < 0) {
            return 1;
        }
        double addition = double(level)*50.;
        return int((baseAmount + addition) * (expExponentBase ** (double(level) / ExpMultipliesEachLevels)));
    }

    // Old formula:
    // const M = 500.; // Scaling of XP values.
    // const K = 2.5; // The progression speed.
    // clearscope static int getRequiredXPForLevel(int level) {
    //     return M * ((double(level)/K) ** 2);
    // }
}

class ExperienceHandler : EventHandler {
    override void WorldThingDied(WorldEvent e) {
        // Don't give XP from barrels or from enemies which aren't counted as kills
        if (e.Thing is 'ExplosiveBarrel' || !e.Thing.bCOUNTKILL) {
            return;
        }
        RwPlayer(Players[0].mo).ReceiveExperience(e.Thing.GetMaxHealth());
    }

    // Maybe will be needed to be able to modify the stat values from menus
    // override void NetworkProcess(ConsoleEvent e) {
    //     Array<string> command;
	// 	e.Name.Split (command, ":");
    //     if (command[0] ~== "rwpsu") {
    //         RwPlayer(Players[0].mo).statPointsAvailable--;
    //     }
    // }
}
