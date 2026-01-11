class RwBackpackPrefix : Affix abstract {
    override void InitAndApplyEffectToItem(Inventory item, int quality) {
        initAndapplyEffectToRBackpack(RWBackpack(item), quality);
    }
    protected virtual void initAndapplyEffectToRBackpack(RWBackpack bpk, int quality) {
        debug.panicUnimplemented(self);
    }
    override bool IsCompatibleWithItem(Inventory item) {
        return (RWBackpack(item) != null);
    }
    // TODO: remove
    override bool isCompatibleWithAffClass(Affix a2) {
        return true;
    }
}

class BPrefLessBull : RwBackpackPrefix {
    override string getName() {
        return "Lite";
    }
    override int getAlignment() {
        return -1;
    }
    override string getDescription() {
        return String.format("-%d%% max bullets", (modifierLevel) );
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'BPrefMoreBull';
    }
    override void initAndapplyEffectToRBackpack(RWBackpack bpk, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(5, 25, 0.1) + modifierLevel/10;
        bpk.stats.maxBull = math.getIntPercentage(bpk.stats.maxBull, 100 - modifierLevel);
    }
    override bool TryUnapplyingSelfFrom(Inventory item) {
        RwBackpack(item).stats.maxBull = math.getWholeByPartPercentage(RwBackpack(item).stats.maxBull, 100 - modifierLevel);
        return true;
    }
}

class BPrefMoreBull : RwBackpackPrefix {
    override string getName() {
        return "Assault";
    }
    override int getAlignment() {
        return 1;
    }
    override string getDescription() {
        return String.format("+%d%% max bullets", (modifierLevel) );
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'BPrefLessBull';
    }
    override void initAndapplyEffectToRBackpack(RWBackpack bpk, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(5, 35, 0.1) + modifierLevel/7;
        bpk.stats.maxBull = math.getIntPercentage(bpk.stats.maxBull, 100 + modifierLevel);
    }
}

class BPrefLessShel : RwBackpackPrefix {
    override string getName() {
        return "Simple";
    }
    override int getAlignment() {
        return -1;
    }
    override string getDescription() {
        return String.format("-%d%% max shells", (modifierLevel) );
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'BPrefMoreShel';
    }
    override void initAndapplyEffectToRBackpack(RWBackpack bpk, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(5, 25, 0.1) + modifierLevel/10;
        bpk.stats.maxShel = math.getIntPercentage(bpk.stats.maxShel, 100 - modifierLevel);
    }
    override bool TryUnapplyingSelfFrom(Inventory item) {
        RwBackpack(item).stats.maxShel = math.getWholeByPartPercentage(RwBackpack(item).stats.maxShel, 100 - modifierLevel);
        return true;
    }
}

class BPrefMoreShel : RwBackpackPrefix {
    override string getName() {
        return "Hunting";
    }
    override int getAlignment() {
        return 1;
    }
    override string getDescription() {
        return String.format("+%d%% max shells", (modifierLevel) );
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'BPrefLessShel';
    }
    override void initAndapplyEffectToRBackpack(RWBackpack bpk, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(5, 35, 0.1) + modifierLevel/7;
        bpk.stats.maxShel = math.getIntPercentage(bpk.stats.maxShel, 100 + modifierLevel);
    }
}

class BPrefLessRckt : RwBackpackPrefix {
    override string getName() {
        return "Lightweight";
    }
    override int getAlignment() {
        return -1;
    }
    override string getDescription() {
        return String.format("-%d%% max rockets", (modifierLevel) );
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'BPrefMoreRckt';
    }
    override void initAndapplyEffectToRBackpack(RWBackpack bpk, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(5, 25, 0.1) + modifierLevel/10;
        bpk.stats.maxRckt = math.getIntPercentage(bpk.stats.maxRckt, 100 - modifierLevel);
    }
    override bool TryUnapplyingSelfFrom(Inventory item) {
        RwBackpack(item).stats.maxRckt = math.getWholeByPartPercentage(RwBackpack(item).stats.maxRckt, 100 - modifierLevel);
        return true;
    }
}

class BPrefMoreRckt : RwBackpackPrefix {
    override string getName() {
        return "Reinforced";
    }
    override int getAlignment() {
        return 1;
    }
    override string getDescription() {
        return String.format("+%d%% max rockets", (modifierLevel) );
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'BPrefLessRckt';
    }
    override void initAndapplyEffectToRBackpack(RWBackpack bpk, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(5, 35, 0.1) + modifierLevel/7;
        bpk.stats.maxRckt = math.getIntPercentage(bpk.stats.maxRckt, 100 + modifierLevel);
    }
}

class BPrefLessCell : RwBackpackPrefix {
    override string getName() {
        return "Thin";
    }
    override int getAlignment() {
        return -1;
    }
    override string getDescription() {
        return String.format("-%d%% max cells", (modifierLevel) );
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'BPrefMoreCell';
    }
    override void initAndapplyEffectToRBackpack(RWBackpack bpk, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(5, 25, 0.1) + modifierLevel/10;
        bpk.stats.maxCell = math.getIntPercentage(bpk.stats.maxCell, 100 - modifierLevel);
    }
    override bool TryUnapplyingSelfFrom(Inventory item) {
        RwBackpack(item).stats.maxCell = math.getWholeByPartPercentage(RwBackpack(item).stats.maxCell, 100 - modifierLevel);
        return true;
    }
}

class BPrefMoreCell : RwBackpackPrefix {
    override string getName() {
        return "Padded";
    }
    override int getAlignment() {
        return 1;
    }
    override string getDescription() {
        return String.format("+%d%% max cells", (modifierLevel) );
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'BPrefLessCell';
    }
    override void initAndapplyEffectToRBackpack(RWBackpack bpk, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(5, 35, 0.1) + modifierLevel/7;
        bpk.stats.maxCell = math.getIntPercentage(bpk.stats.maxCell, 100 + modifierLevel);
    }
}
