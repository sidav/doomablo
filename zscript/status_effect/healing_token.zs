class RWHealingToken : RwStatusEffectToken {

    int healPerTickX1000;
    int healUntilPercentage;

    Default {
        Inventory.Amount 10;
        RwStatusEffectToken.ReductionPeriodTicks 1;
    }

    override int GetAlignment() {
        return 1;
    }

    override string GetStatusName() {
        return String.Format("HEALING %.1f/s", (double(healPerTickX1000) * TICRATE / 1000));
    }

    override string GetStatusNumber() {
        return StringsHelper.FormatFloat(float(Amount)/TICRATE, 10.);
    }

    override Color GetColorForUi() {
        return Font.CR_CYAN;
    }

    static void ApplyToActor(Actor target, int totalHeal, int healUntilPercentage, int durationTicks) {
        target.GiveInventory('RWHealingToken', durationTicks);
        let token = target.FindInventory('RWHealingToken');
        if (token) {
            token.Amount = durationTicks;
            RWHealingToken(token).healPerTickX1000 = (totalHeal * 1000 + durationTicks/2) / durationTicks;
            RWHealingToken(token).healUntilPercentage = healUntilPercentage;
        }
    }

    int healAccum;
    override void doEffectOnRwPlayer() {
        if (Amount > 0) {
            let healed = math.AccumulatedFixedPointAdd(0, healPerTickX1000, 1000, healAccum);
            if (healed > 0) {
                owner.GiveBody(healed, math.GetIntPercentage(RwPlayer(owner).GetMaxHealth(), healUntilPercentage));
            }
        }
    }

    override void doEffectOnMonster() {} // Unimplemented (unneeded?)
    override void doAlways() {}
}