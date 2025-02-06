class RwFlaskPrefix : Affix {
    override void InitAndApplyEffectToItem(Inventory item, int quality) {
        initAndapplyEffectToRFlask(RWFlask(item), quality);
    }
    protected virtual void initAndapplyEffectToRFlask(RWFlask fsk, int quality) {
        debug.panicUnimplemented(self);
    }
    override bool IsCompatibleWithItem(Inventory item) {
        return (RWFlask(item) != null);
    }
    // TODO: remove
    override bool isCompatibleWithAffClass(Affix a2) {
        return true;
    }
}

class FPrefLessHeal : RwFlaskPrefix {
    override string getName() {
        return "Diluted";
    }
    override int getAlignment() {
        return -1;
    }
    override string getDescription() {
        return String.format("-%d%% heal amount", (modifierLevel) );
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'FPrefMoreHeal';
    }
    override void initAndapplyEffectToRFlask(RWFlask fsk, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(5, 15, 0.1) + modifierLevel/10;
        fsk.stats.healAmount = math.getIntPercentage(fsk.stats.healAmount, 100 - modifierLevel);
    }
}

class FPrefMoreHeal : RwFlaskPrefix {
    override string getName() {
        return "Concentrated";
    }
    override int getAlignment() {
        return 1;
    }
    override string getDescription() {
        return String.format("+%d%% heal amount", (modifierLevel) );
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'FPrefLessHeal';
    }
    override void initAndapplyEffectToRFlask(RWFlask fsk, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(5, 15, 0.1) + modifierLevel/10;
        fsk.stats.healAmount = math.getIntPercentage(fsk.stats.healAmount, 100 + modifierLevel);
    }
}

class FPrefLongerDuration : RwFlaskPrefix {
    override string getName() {
        return "Lasting";
    }
    override int getAlignment() {
        return -1;
    }
    override string getDescription() {
        return String.format("+%d%% heal duration", (modifierLevel) );
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'FPrefShorterDuration';
    }
    override void initAndapplyEffectToRFlask(RWFlask fsk, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(5, 15, 0.1) + modifierLevel/10;
        fsk.stats.healDurationTicks = math.getIntPercentage(fsk.stats.healDurationTicks, 100 - modifierLevel);
    }
}

class FPrefShorterDuration : RwFlaskPrefix {
    override string getName() {
        return "Quick";
    }
    override int getAlignment() {
        return 1;
    }
    override string getDescription() {
        return String.format("-%d%% heal duration", (modifierLevel) );
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'FPrefLongerDuration';
    }
    override void initAndapplyEffectToRFlask(RWFlask fsk, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(5, 15, 0.1) + modifierLevel/10;
        fsk.stats.healDurationTicks = math.getIntPercentage(fsk.stats.healDurationTicks, 100 + modifierLevel);
    }
}

class FPrefLessCharges : RwFlaskPrefix {
    override string getName() {
        return "smaller";
    }
    override int getAlignment() {
        return -1;
    }
    override string getDescription() {
        return String.format("-%d charges", (modifierLevel) );
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'FPrefMoreCharges';
    }
    override void initAndapplyEffectToRFlask(RWFlask fsk, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, fsk.stats.maxCharges - fsk.stats.chargeConsumption, 0.1);
        fsk.stats.maxCharges -= modifierLevel;
    }
}

class FPrefMoreCharges : RwFlaskPrefix {
    override string getName() {
        return "bigger";
    }
    override int getAlignment() {
        return 1;
    }
    override string getDescription() {
        return String.format("+%d charges", (modifierLevel) );
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'FPrefLessCharges';
    }
    override void initAndapplyEffectToRFlask(RWFlask fsk, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, fsk.stats.maxCharges/2, 0.1);
        fsk.stats.maxCharges += modifierLevel;
    }
}

class FPrefLongerCooldown : RwFlaskPrefix {
    override string getName() {
        return "Bitter";
    }
    override int getAlignment() {
        return -1;
    }
    override string getDescription() {
        return String.format("+%d%% usage cooldown", (modifierLevel) );
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'FPrefShorterCooldown';
    }
    override void initAndapplyEffectToRFlask(RWFlask fsk, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(5, 15, 0.1) + modifierLevel/10;
        fsk.stats.usageCooldownTicks = math.getIntPercentage(fsk.stats.usageCooldownTicks, 100 + modifierLevel);
    }
}

class FPrefShorterCooldown : RwFlaskPrefix {
    override string getName() {
        return "Tasty";
    }
    override int getAlignment() {
        return 1;
    }
    override string getDescription() {
        return String.format("-%d%% usage cooldown", (modifierLevel) );
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'FPrefLongerCooldown';
    }
    override void initAndapplyEffectToRFlask(RWFlask fsk, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(5, 15, 0.1) + modifierLevel/10;
        fsk.stats.usageCooldownTicks = math.getIntPercentage(fsk.stats.usageCooldownTicks, 100 - modifierLevel);
    }
}
