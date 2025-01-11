class RWRadiationToken : RwStatusEffectToken {

    Default {
        Inventory.Amount 3;
        RwStatusEffectToken.ReductionPeriodTicks TICRATE;
    }

    const particleColor = 0xffff11;
    const DamageEach = TICRATE;
    const RadiationDamageRadiusFactor = 4;

    override string GetStatusName() {
        return "IRRADIATED";
    }

    override Color GetColorForUi() {
        return Font.CR_ORANGE;
    }

    static void ApplyToActor(Actor target, int durationSeconds) {
        target.GiveInventory('RWRadiationToken', durationSeconds);
    }

    override void doEffectOnRwPlayer() {
        if (GetAge() % TICRATE == 0) {
            owner.damageMobj(self, owner, 1, 'Normal', DMG_NO_PROTECT);
        }
    }

    override void doAlways() {
        if (GetAge() % DamageEach == 0) {
            // Damage all actors in an area surrounding the irradiated actor
            let ti = ThinkerIterator.Create('Actor');
            Actor mo;
            while (mo = Actor(ti.next())) {
                let reqDistance = owner.radius * RadiationDamageRadiusFactor;
                if (mo && owner != mo && owner.Distance2D(mo) <= reqDistance) {
                    // "Source" of the damage is this actor. This causes infighting (on purpose, hehe). Maybe this makes this affix too OP.
                    let moLvl = RwMonsterAffixator.GetMonsterLevel(mo);
                    let minDmg = StatsScaler.ScaleIntValueByLevel(1, moLvl);
                    let maxDmg = StatsScaler.ScaleIntValueByLevel(5, moLvl);
                    mo.damageMobj(self, owner, Random(minDmg, maxDmg), 'Normal', DMG_NO_PROTECT);
                }
            }
        }

        if (GetAge() % 4 == 0) {
            let pspeed = 2 * owner.Radius * RadiationDamageRadiusFactor;
            let pVect = AngleToVector(rnd.Randf(0.0, 360.0), pspeed/double(TICRATE));
            owner.A_SpawnParticle(
                particleColor,
                flags: SPF_FULLBRIGHT | SPF_REPLACE,
                lifetime: TICRATE,
                size: 4.0,
                angle: 0,
                xoff: 0.0, yoff: 0.0, zoff: 2*owner.height/3,
                velx: pVect.X, vely: pVect.Y, velz: rnd.randf(-0.5, 0.5)
                // double accelx = 0, double accely = 0, double accelz = 0, double startalphaf = 1, double fadestepf = -1, double sizestep = 0
            );
        }
    }

}