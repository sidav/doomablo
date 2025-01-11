class ExperienceGivingHandler : EventHandler {
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
