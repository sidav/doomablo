class RWSpecialDamageHandler : EventHandler
{
    override void WorldThingDamaged(WorldEvent e) {
        let target = e.thing;
        let inflictor = e.damageSource; // or try e.thing.target. yup, it's that strange

        if (inflictor is 'MyPlayer') {
            // debug.print("Dealt "..e.damage.." damage");
            handleDamageFromPlayer(MyPlayer(inflictor), target, e.damage);
        }

    }

    static void handleDamageFromPlayer(MyPlayer plr, Actor target, int damage) {
        let wpn = RandomizedWeapon(plr.Player.ReadyWeapon);
        if (!wpn) return;

        // target.GiveInventory('RWPoisonToken', 10);

        Affix current;
        foreach (current : wpn.appliedAffixes) {
            if (current.GetClass() == 'WSuffVampiric') {
                if (rnd.PercentChance(current.modifierLevel)) {
                    plr.Player.bonusCount += 3;
                    plr.GiveBody(1, 200);
                }
                continue;
            }

            if (current.GetClass() == 'WSuffPoison') {
                if (rnd.PercentChance(current.modifierLevel)) {
                    target.GiveInventory('RWPoisonToken', 10);
                }
                continue;
            }
        }
    }
    
}