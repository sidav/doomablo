class RWRadiationToken : RWSpecialDamageToken {

    Default {
        Inventory.Amount 1;
    }

    const particleColor = 0x11ff11;
    const DamageEach = TICRATE;
    const RadiationDamageRadiusFactor = 4;

    override void Tick() {
        super.Tick();
        if (!owner || owner.health <= 0 || amount <= 0) {
            Destroy();
            return;
        }
        if (owner && (GetAge() % DamageEach == 0)) {
            // Damage all actors in an area surrounding the irradiated actor
            let ti = ThinkerIterator.Create('Actor');
            Actor mo;
            while (mo = Actor(ti.next())) {
                let reqDistance = owner.radius * RadiationDamageRadiusFactor;
                if (mo && owner != mo && owner.Distance2D(mo) <= reqDistance) {
                    // "Source" of the damage is this actor. This causes infighting (on purpose, hehe). Maybe this makes this affix too OP.
                    mo.damageMobj(null, owner, damage(), 'Normal', DMG_NO_PROTECT);
                }
            }
        }

        if (GetAge() % 4 == 0) {
            let pspeed = owner.Radius * RadiationDamageRadiusFactor;
            let pVect = AngleToVector(rnd.Randf(0.0, 360.0), pspeed/double(TICRATE));
            owner.A_SpawnParticle(
                particleColor,
                flags: SPF_FULLBRIGHT | SPF_REPLACE,
                lifetime: TICRATE,
                size: 4.0,
                angle: 0,
                xoff: 0.0, yoff: 0.0, zoff: rnd.randf(0, owner.height * 0.7),
                velx: pVect.X, vely: pVect.Y, velz: 0.0
                // double accelx = 0, double accely = 0, double accelz = 0, double startalphaf = 1, double fadestepf = -1, double sizestep = 0
            );
        }
    }

    private int damage() {
        return amount * 2;
    }

}