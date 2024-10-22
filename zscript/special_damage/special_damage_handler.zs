class RWSpecialDamageHandler : EventHandler
{

    mixin DropSpreadable;

    override void WorldThingDamaged(WorldEvent e) {
        let target = e.thing;
        let whoDidDamage = e.damageSource; // or try e.thing.target. e.Inflictor is NOT who did the damage. Yup, it's that strange

        // debug.print("Target: "..target.GetClassName()
        //     .." got "..e.damage.." damage"
        //     .."; who did: "..whoDidDamage.GetClassName()
        //     .."; Inflictor: "..e.Inflictor.GetClassName());

        if (whoDidDamage is 'RwPlayer' && !(target is 'ExplosiveBarrel') && !(e.Inflictor is 'ExplosiveBarrel')) {
            // debug.print("Dealt "..e.damage.." damage");
            handleDamageFromPlayer(RwPlayer(whoDidDamage), target, e.damage);
        }

    }

    static void handleDamageFromPlayer(RwPlayer plr, Actor target, int damage) {
        let wpn = RandomizedWeapon(plr.Player.ReadyWeapon);
        if (!wpn) return;

        // target.GiveInventory('RWPoisonToken', 10);

        Affix current;
        foreach (current : wpn.appliedAffixes) {
            current.onDamageDealtByPlayer(damage, target, plr);

            if (target.health <= 0) {
                current.onFatalDamageDealtByPlayer(damage, target, plr);
            }
        }
    }
    
}