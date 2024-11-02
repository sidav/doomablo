class RWPoisonToken : RwStatusEffectToken {

    Default {
        Inventory.Amount 10;
    }

    const DamageEach = TICRATE * 2;

    override string GetStatusName() {
        return "POISON";
    }

    override Color GetColorForUi() {
        return Font.CR_GREEN;
    }

    override void doEffectOnRwPlayer() {
        if (amount > 30) {
            amount = 30;
        }
        if (GetAge() % DamageEach == 0) {
            // debug.print("Damaging: amount "..amount..", damage "..damage());
            owner.damageMobj(null, null, 1, 'Normal', DMG_NO_ARMOR);
        }
    }

    override void doEffectOnMonster() {
        if (GetAge() % DamageEach == 0) {
            // debug.print("Damaging: amount "..amount..", damage "..damage());
            owner.damageMobj(null, null, (amount/3 + 1), 'Normal', DMG_NO_PROTECT);
        }
    }

    const particleColor = 0x22CC00;
    override void doAlways() {
        if (GetAge() % TICRATE == 0) {
            amount--;
        }

        if (GetAge() % 4 == 0) {
            owner.A_SpawnParticle(
                particleColor,
                flags: SPF_FULLBRIGHT | SPF_REPLACE,
                lifetime: rnd.rand(DamageEach, DamageEach * 2),
                size: 4.5,
                angle: 0,
                xoff: rnd.randf(-owner.radius, owner.radius), yoff: rnd.randf(-owner.radius, owner.radius), zoff: rnd.randf(0, owner.height * 0.7),
                velx: 0.0, vely: 0.0, velz: rnd.randf(0.5, 1.5)
                // double accelx = 0, double accely = 0, double accelz = 0, double startalphaf = 1, double fadestepf = -1, double sizestep = 0
            );
        }
    }
}