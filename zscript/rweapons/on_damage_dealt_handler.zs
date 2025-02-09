// This handler fires onDamageDealtByPlayer and onFatalDamageDealtByPlayer callbacks.
// It WON'T fire the callbacks if damage 'inflictor' is null to prevent endless callback loop
class RWOnWeaponDamageDealtHandler : EventHandler
{
    override void WorldThingDamaged(WorldEvent e) {
        let target = e.thing;
        let whoDidDamage = e.damageSource; // or try e.thing.target. e.Inflictor is NOT who did the damage. Yup, it's that strange

        // debug.print("Target: "..target.GetClassName());
        // debug.print(" got "..e.damage.." damage");
        // debug.print(" who did: "..whoDidDamage.GetClassName());
        // if (e.Inflictor) {
        //     debug.print(" Inflictor: "..e.Inflictor.GetClassName());
        // }

        if (whoDidDamage is 'RwPlayer' && 
            !(e.inflictor == null || e.Inflictor is 'RwStatusEffectToken' 
                || target is 'ExplosiveBarrel' || e.Inflictor is 'ExplosiveBarrel')) {
            // debug.print("Dealt "..e.damage.." damage");
            handleDamageFromPlayer(RwPlayer(whoDidDamage), target, e.damage);
        }

    }

    static void handleDamageFromPlayer(RwPlayer plr, Actor target, int damage) {
        let wpn = RandomizedWeapon(plr.Player.ReadyWeapon);
        if (!wpn) return;

        Affix current;
        foreach (current : wpn.appliedAffixes) {
            current.onDamageDealtByPlayer(damage, target, plr);

            if (target.health <= 0) {
                current.onFatalDamageDealtByPlayer(damage, target, plr);
            }
        }

        if (target.health <= 0) {
            // Refill flask charge
            if (plr.CurrentEquippedFlask) {
                static const int refillAmount[] = {1, 3, 5, 10, 20, 50};
                let rar = RwMonsterAffixator.GetMonsterRarity(target);
                plr.CurrentEquippedFlask.Refill(refillAmount[rar]);
            }
        }
    }
    
}