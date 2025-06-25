class RWPoisonToken : RwStatusEffectToken {

    int damage;

    Default {
        Inventory.Amount 10;
        RwStatusEffectToken.ReductionPeriodTicks TICRATE;
    }

    override int GetAlignment() {
        return -1;
    }

    override string GetStatusName() {
        return "POISON";
    }

    override Color GetColorForUi() {
        return Font.CR_GREEN;
    }

    static void ApplyToActor(Actor target, int dmg, int durationSeconds) {
        target.GiveInventory('RWPoisonToken', durationSeconds);
        let token = target.FindInventory('RWPoisonToken');
        if (token) {
            RWPoisonToken(token).damage = dmg;
        }
    }

    override void doEffectOnRwPlayer() {
        if (amount > 30) {
            amount = 30;
        }
        if (GetAge() % TICRATE == 0) {
            // debug.print("Damaging: amount "..amount..", damage "..damage());
            owner.damageMobj(self, null, 1, 'Normal', DMG_NO_ARMOR);
        }
    }

    int dmgFractionAccum;
    override void doEffectOnMonster() {
        int dmg = math.AccumulatedFixedPointAdd(0, 1000 * damage / TICRATE, 1000, dmgFractionAccum);
        if (dmg > 0) {
            // debug.print("Damaging: amount "..amount..", damage "..damage());
            owner.damageMobj(null, null, dmg, 'Normal', DMG_NO_PROTECT|DMG_NO_ARMOR|DMG_NO_PAIN);
        }
    }

    const particleColor = 0x22CC00;
    override void doAlways() {
        if (GetAge() % 4 == 0) {
            owner.A_SpawnParticle(
                particleColor,
                flags: SPF_FULLBRIGHT | SPF_REPLACE,
                lifetime: rnd.rand(TICRATE, TICRATE * 2),
                size: 4.5,
                angle: 0,
                xoff: rnd.randf(-owner.radius, owner.radius), yoff: rnd.randf(-owner.radius, owner.radius), zoff: rnd.randf(0, owner.height * 0.7),
                velx: 0.0, vely: 0.0, velz: rnd.randf(0.5, 1.5)
                // double accelx = 0, double accely = 0, double accelz = 0, double startalphaf = 1, double fadestepf = -1, double sizestep = 0
            );
        }
    }
}