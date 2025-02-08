class RWPainToken : RwStatusEffectToken {

    Default {
        Inventory.Amount 5;
        Inventory.MaxAmount 30;
        RwStatusEffectToken.ReductionPeriodTicks TICRATE;
    }

    const EffectEach = TICRATE / 7;

    override int GetAlignment() {
        return -1;
    }

    override string GetStatusName() {
        return "TORMENT";
    }

    override Color GetColorForUi() {
        return Font.CR_PURPLE;
    }

    override void doEffectOnRwPlayer() {
        if (owner.player.DamageCount > 10) {
            owner.angle += rnd.randf(-1.2, 1.2);
            owner.pitch += rnd.randf(-0.5, 0.5);
        }
        if ((GetAge() % EffectEach == 0) && rnd.PercentChance(25)) {
            if (rnd.PercentChance(50)) {
                owner.damageMobj(self, null, 1, 'Normal', DMG_NO_ARMOR);
            }
            owner.A_ScaleVelocity(0.25);
            owner.player.DamageCount = 50;
        }
    }

    override void doEffectOnMonster() {
        if ((GetAge() % EffectEach == 0) && rnd.PercentChance(50)) {
            let painState = owner.ResolveState('Pain');
            if (painState) {
                owner.SetState(painState);
            }
        }
    }
}