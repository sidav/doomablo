class RWHealingToken : RwStatusEffectToken {

    int healPerTickX1000;

    Default {
        Inventory.Amount 10;
        RwStatusEffectToken.ReductionPeriodTicks 1;
    }

    override string GetStatusName() {
        return "HEALING";
    }

    override string GetStatusNumber() {
        return StringsHelper.FormatFloat(float(Amount)/TICRATE, 10.);
    }

    override Color GetColorForUi() {
        return Font.CR_CYAN;
    }

    static void ApplyToActor(Actor target, int totalHeal, int durationTicks) {
        target.GiveInventory('RWHealingToken', durationTicks);
        let token = target.FindInventory('RWHealingToken');
        if (token) {
            token.Amount = durationTicks;
            RWHealingToken(token).healPerTickX1000 = (totalHeal * 1000 + durationTicks/2) / durationTicks;
        }
    }

    int healAccum;
    override void doEffectOnRwPlayer() {
        if (Amount > 0) {
            let healed = math.AccumulatedFixedPointAdd(0, healPerTickX1000, 1000, healAccum);
            if (healed > 0) {
                owner.GiveBody(healed, RwPlayer(owner).GetMaxHealth());
            }
        }
    }

    override void doEffectOnMonster() {} // Unimplemented (unneeded?)
    override void doAlways() {}
}