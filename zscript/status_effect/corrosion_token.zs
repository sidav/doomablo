class RWCorrosionToken : RwStatusEffectToken {

    Default {
        Inventory.Amount 10;
        RwStatusEffectToken.ReductionPeriodTicks TICRATE;
    }

    const DamageEach = TICRATE / 2;

    override int GetAlignment() {
        return -1;
    }

    override string GetStatusName() {
        return "CORROSION";
    }

    override Color GetColorForUi() {
        return Font.CR_BRICK;
    }

    override void doEffectOnRwPlayer() {
        if (GetAge() % DamageEach == 0) {
            if (RwPlayer(owner).CurrentEquippedArmor) {
                RwPlayer(owner).CurrentEquippedArmor.DoDamageToArmor(1);
            }
        }
    }

    override void doEffectOnMonster() {}

    const particleColor = 0x22CC00;
    override void doAlways() {
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