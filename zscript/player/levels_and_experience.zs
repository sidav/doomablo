extend class RwPlayer {

    int currentExperience;

    void ReceiveExperience(int amount) {
        currentExperience += amount;
    }

    ui int getCurrentExpLevel() {
        return LevelsExpValues.getCurrentExpLevel(currentExperience);
    }

    ui int getRequiredXPForNextLevel() {
        return LevelsExpValues.getRequiredXPForLevel(getCurrentExpLevel() + 1);
    }

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

class LevelsExpValues {
    const M = 200.; // Scaling of XP values.
    const K = 2.; // The progression speed.

    static int getCurrentExpLevel(int currentExperience) {
        return K * sqrt(double(currentExperience) / M) + 1;
    }

    static int getRequiredXPForLevel(int level) {
        return M * ((double(level - 1)/K) ** 2);
    }
}
