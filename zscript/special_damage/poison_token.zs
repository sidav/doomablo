class RWPoisonToken : RWSpecialDamageToken {

    Default {
        Inventory.Amount 10;
    }

    const DamageEach = TICRATE * 2;

    override void Tick() {
        super.Tick();
        if (!owner || owner.health <= 0 || amount <= 0) {
            Destroy();
            return;
        }
        if (owner && (GetAge() % DamageEach == 0)) {
            debug.print("Damaging: amount "..amount..", damage "..damage());
            owner.damageMobj(null, null, damage(), 'Normal', DMG_NO_PROTECT);
        }

        if (GetAge() % TICRATE == 0) {
            amount--;
        }

        if (GetAge() % 5 == 0) {
            owner.A_SpawnParticle(
                0x00ff00,
                flags: SPF_FULLBRIGHT | SPF_REPLACE,
                lifetime: rnd.rand(DamageEach, DamageEach * 2),
                size: 4.0,
                angle: 0,
                xoff: rnd.randf(-owner.radius, owner.radius), yoff: rnd.randf(-owner.radius, owner.radius), zoff: rnd.randf(0, owner.height * 0.7),
                velx: 0.0, vely: 0.0, velz: rnd.randf(0.5, 1.5)
                // double accelx = 0, double accely = 0, double accelz = 0, double startalphaf = 1, double fadestepf = -1, double sizestep = 0
            );
        }
    }

    private int damage() {
        return (amount/4 + 1);
    }

}