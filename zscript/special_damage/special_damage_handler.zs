class RWSpecialDamageHandler : EventHandler
{

    mixin DropSpreadable;

    override void WorldThingDamaged(WorldEvent e) {
        let target = e.thing;
        let whoDidDamage = e.damageSource; // or try e.thing.target. e.Inflictor is NOT who did the damage. Yup, it's that strange

        // debug.print("Target: "..target.GetClassName()
        //     .."; who did: "..whoDidDamage.GetClassName()
        //     .."; Inflictor: "..e.Inflictor.GetClassName());

        if (whoDidDamage is 'MyPlayer' && !(target is 'ExplosiveBarrel') && !(e.Inflictor is 'ExplosiveBarrel')) {
            // debug.print("Dealt "..e.damage.." damage");
            handleDamageFromPlayer(MyPlayer(whoDidDamage), target, e.damage);
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

            if (current.GetClass() == 'WSuffRadiation') {
                if (rnd.PercentChance(current.modifierLevel)) {
                    target.GiveInventory('RWRadiationToken', 1);
                }
                continue;
            }

            if (current.GetClass() == 'WSuffPain') {
                if (rnd.PercentChance(current.modifierLevel)) {
                    target.GiveInventory('RWPainToken', 5);
                }
                continue;
            }

            if (current.GetClass() == 'WSuffAmmoDrops') {
                if (target.health <= 0 && rnd.PercentChance(current.modifierLevel)) {
                    let ammoitem = DropsHandler.SpawnRandomAmmoDrop(target);
                    AssignSpreadVelocityTo(ammoitem);
                }
                continue;
            }

            if (current.GetClass() == 'WSuffSpawnBarrelOnKill') {
                if (target.health <= 0 && rnd.PercentChance(current.modifierLevel)) {
                    let brl = Target.Spawn('ExplosiveBarrel', target.Pos);
                    AssignSpreadVelocityTo(brl);
                }
                continue;
            }
        }
    }
    
}