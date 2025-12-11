class RwFlaskPrefix : RwBaseActiveSlotItemAffix abstract {
    override void InitAndApplyEffectToItem(Inventory item, int quality) {
        initAndapplyEffectToRFlask(RWFlask(item), quality);
    }
    protected virtual void initAndapplyEffectToRFlask(RWFlask fsk, int quality) {
        debug.panicUnimplemented(self);
    }
    override bool IsCompatibleWithItem(Inventory item) {
        return (RWFlask(item) != null);
    }
}

class FPrefLessMaxHeal : RwFlaskPrefix {
    override string getName() {
        return "Cursed";
    }
    override int getAlignment() {
        return -1;
    }
    override string getDescription() {
        return String.format("Heals only until %d%% of max HP", (modifierLevel) );
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'FPrefMoreMaxHeal';
    }
    override void initAndapplyEffectToRFlask(RWFlask fsk, int quality) {
        modifierLevel = 100 - rnd.multipliedWeightedRandByEndWeight(5, 25, 0.1) - quality/10;
        fsk.stats.healsUntilPercentage = modifierLevel;
    }
    override bool TryUnapplyingSelfFrom(Inventory item) {
        RwFlask(item).stats.healsUntilPercentage = 100;
        return true;
    }
}

class FPrefMoreMaxHeal : RwFlaskPrefix {
    override string getName() {
        return "Blessed";
    }
    override int getAlignment() {
        return 1;
    }
    override string getDescription() {
        return String.format("Heals until %d%% of max HP", (modifierLevel) );
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'FPrefLessMaxHeal';
    }
    override void initAndapplyEffectToRFlask(RWFlask fsk, int quality) {
        modifierLevel = 100 + rnd.multipliedWeightedRandByEndWeight(1, 15, 0.1) + quality/10;
        fsk.stats.healsUntilPercentage = modifierLevel;
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
        let minPerc = math.minimumMeaningIntPercent(fsk.stats.healAmount);
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(minPerc, 15, 0.1) + quality/10;
        fsk.stats.healAmount = math.getIntPercentage(fsk.stats.healAmount, 100 - modifierLevel);
    }
    override bool TryUnapplyingSelfFrom(Inventory item) {
        RwFlask(item).stats.healAmount = math.getWholeByPartPercentage(RwFlask(item).stats.healAmount, 100 - modifierLevel);
        return true;
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
        let minPerc = math.minimumMeaningIntPercent(fsk.stats.healAmount);
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(minPerc, 25, 0.1) + quality/10;
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
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(5, 15, 0.1) + quality/10;
        fsk.stats.healDurationTicks = math.getIntPercentage(fsk.stats.healDurationTicks, 100 + modifierLevel);
    }
    override bool TryUnapplyingSelfFrom(Inventory item) {
        RwFlask(item).stats.healDurationTicks = math.getWholeByPartPercentage(RwFlask(item).stats.healDurationTicks, 100 + modifierLevel);
        return true;
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
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(5, 15, 0.1) + quality/10;
        fsk.stats.healDurationTicks = math.getIntPercentage(fsk.stats.healDurationTicks, 100 - modifierLevel);
    }
}
