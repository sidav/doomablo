// Base for abstract inheritance
class RwBaseActiveSlotItemAffix : Affix abstract {
    override void InitAndApplyEffectToItem(Inventory item, int quality) {
        initAndapplyEffectToASI(RwActiveSlotItem(item), quality);
    }
    protected virtual void initAndapplyEffectToASI(RwActiveSlotItem asi, int quality) {
        debug.panicUnimplemented(self);
    }
    override bool IsCompatibleWithItem(Inventory item) {
        return (RwActiveSlotItem(item) != null);
    }
}

// Non-abstract ASI classes should be inherited from this
class RwAnyActiveSlotItemAffix : RwBaseActiveSlotItemAffix abstract {}

class AsiPrefLessCharges : RwAnyActiveSlotItemAffix {
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
        return a2.GetClass() != 'AsiPrefMoreCharges' && a2.GetClass() != 'AsiPrefBiggerConsumption';
    }
    override void initAndapplyEffectToASI(RwActiveSlotItem asi, int quality) {
        let stats = asi.GetStats();
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, stats.maxCharges - stats.chargeConsumption, 0.1);
        stats.maxCharges -= modifierLevel;
    }
    override bool TryUnapplyingSelfFrom(Inventory item) {
        let stats = RwActiveSlotItem(item).GetStats();
        stats.maxCharges += modifierLevel;
        return true;
    }
}

class AsiPrefMoreCharges : RwAnyActiveSlotItemAffix {
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
        return a2.GetClass() != 'AsiPrefLessCharges';
    }
    override void initAndapplyEffectToASI(RwActiveSlotItem asi, int quality) {
        let stats = asi.GetStats();
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, stats.maxCharges/2, 0.1);
        stats.maxCharges += modifierLevel;
    }
}

class AsiPrefBiggerConsumption : RwAnyActiveSlotItemAffix {
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
        return a2.GetClass() != 'AsiPrefSmallerConsumption' && a2.GetClass() != 'AsiPrefLessCharges';
    }
    override void initAndapplyEffectToASI(RwActiveSlotItem asi, int quality) {
        let stats = asi.GetStats();
        let diff = stats.maxCharges - stats.chargeConsumption;
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, min(diff, 10), 0.1);
        stats.chargeConsumption += modifierLevel;
    }
    override bool TryUnapplyingSelfFrom(Inventory item) {
        let stats = RwActiveSlotItem(item).GetStats();
        stats.chargeConsumption -= modifierLevel;
        return true;
    }
}

class AsiPrefSmallerConsumption : RwAnyActiveSlotItemAffix {
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
        return a2.GetClass() != 'AsiPrefBiggerConsumption';
    }
    override void initAndapplyEffectToASI(RwActiveSlotItem asi, int quality) {
        let stats = asi.GetStats();
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, 6, 0.1);
        stats.chargeConsumption -= modifierLevel;
    }
}

class AsiPrefLongerCooldown : RwAnyActiveSlotItemAffix {
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
        return a2.GetClass() != 'AsiPrefShorterCooldown';
    }
    override void initAndapplyEffectToASI(RwActiveSlotItem asi, int quality) {
        let stats = asi.GetStats();
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(5, 15, 0.1) + quality/10;
        stats.usageCooldownTicks = math.getIntPercentage(stats.usageCooldownTicks, 100 + modifierLevel);
    }
    override bool TryUnapplyingSelfFrom(Inventory item) {
        let stats = RwActiveSlotItem(item).GetStats();
        stats.usageCooldownTicks = math.getWholeByPartPercentage(stats.usageCooldownTicks, 100 + modifierLevel);
        return true;
    }
}

class AsiPrefShorterCooldown : RwAnyActiveSlotItemAffix {
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
        return a2.GetClass() != 'AsiPrefLongerCooldown';
    }
    override void initAndapplyEffectToASI(RwActiveSlotItem asi, int quality) {
        let stats = asi.GetStats();
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(5, 15, 0.1) + quality/10;
        stats.usageCooldownTicks = math.getIntPercentage(stats.usageCooldownTicks, 100 - modifierLevel);
    }
}