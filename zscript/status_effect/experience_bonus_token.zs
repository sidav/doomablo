class RWExperienceBonusToken : RwStatusEffectToken {

    double bonusPercentage;
    double previousTickExperience;

    Default {
        Inventory.Amount 10;
        RwStatusEffectToken.ReductionPeriodTicks TICRATE;
    }

    override int GetAlignment() {
        return 1;
    }

    override string GetStatusName() {
        return String.Format("EXPERIENCE +%.0f%%", (bonusPercentage));
    }

    override Color GetColorForUi() {
        return Font.CR_GOLD;
    }

    static void ApplyToActor(Actor target, int bonusPercentage, int durationSeconds) {
        target.GiveInventory('RWExperienceBonusToken', durationSeconds);
        let token = target.FindInventory('RWExperienceBonusToken');
        let plr = RwPlayer(target);
        if (token && plr) {
            RWExperienceBonusToken(token).bonusPercentage = bonusPercentage;
            RWExperienceBonusToken(token).previousTickExperience = plr.stats.currentExperience;
        }
    }

    override void doEffectOnRwPlayer() {
        let plr = RwPlayer(owner);
        if (plr) {
            double diff = plr.stats.currentExperience - previousTickExperience;
            if (diff > 0) {
                plr.stats.AddExperience(diff * bonusPercentage / 100.);
            }
            previousTickExperience = plr.stats.currentExperience;
        }
    }

    override void doEffectOnMonster() {} // Unneeded
    override void doAlways() {}
}