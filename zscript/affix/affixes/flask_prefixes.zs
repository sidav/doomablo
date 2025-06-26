class RwFlaskPrefix : Affix abstract {
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
        return a2.GetClass() != 'FPrefMoreCharges' && a2.GetClass() != 'FPrefBiggerConsumption';
    }
    override void initAndapplyEffectToRFlask(RWFlask fsk, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, fsk.stats.maxCharges - fsk.stats.chargeConsumption, 0.1);
        fsk.stats.maxCharges -= modifierLevel;
    }
    override bool TryUnapplyingSelfFrom(Inventory item) {
        RwFlask(item).stats.maxCharges += modifierLevel;
        return true;
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

class FPrefBiggerConsumption : RwFlaskPrefix {
    override string getName() {
        return "Dripping";
    }
    override int getAlignment() {
        return -1;
    }
    override string getDescription() {
        return String.format("+%d consumed charges", (modifierLevel) );
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'FPrefSmallerConsumption' && a2.GetClass() != 'FPrefLessCharges';
    }
    override void initAndapplyEffectToRFlask(RWFlask fsk, int quality) {
        let diff = fsk.stats.maxCharges - fsk.stats.chargeConsumption;
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, min(diff, 10), 0.1);
        fsk.stats.chargeConsumption += modifierLevel;
    }
    override bool TryUnapplyingSelfFrom(Inventory item) {
        RwFlask(item).stats.chargeConsumption -= modifierLevel;
        return true;
    }
}

class FPrefSmallerConsumption : RwFlaskPrefix {
    override string getName() {
        return "Sealed";
    }
    override int getAlignment() {
        return 1;
    }
    override string getDescription() {
        return String.format("-%d consumed charges", (modifierLevel) );
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'FPrefBiggerConsumption';
    }
    override void initAndapplyEffectToRFlask(RWFlask fsk, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, 6, 0.1);
        fsk.stats.chargeConsumption -= modifierLevel;
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
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(5, 15, 0.1) + quality/10;
        fsk.stats.usageCooldownTicks = math.getIntPercentage(fsk.stats.usageCooldownTicks, 100 + modifierLevel);
    }
    override bool TryUnapplyingSelfFrom(Inventory item) {
        RwFlask(item).stats.usageCooldownTicks = math.getWholeByPartPercentage(RwFlask(item).stats.usageCooldownTicks, 100 + modifierLevel);
        return true;
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
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(5, 15, 0.1) + quality/10;
        fsk.stats.usageCooldownTicks = math.getIntPercentage(fsk.stats.usageCooldownTicks, 100 - modifierLevel);
    }
}
