class RwBackpackPrefix : Affix {
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
        return "Max bullets -"..modifierLevel;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'BPrefMoreBull';
    }
    override void initAndapplyEffectToRBackpack(RWBackpack bpk, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, bpk.stats.maxBull/2);

        bpk.stats.maxBull -= modifierLevel;
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
        return "Max bullets +"..modifierLevel;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'BPrefLessBull';
    }
    override void initAndapplyEffectToRBackpack(RWBackpack bpk, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, bpk.stats.maxBull*2);

        bpk.stats.maxBull += modifierLevel;
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
        return "Max Shells -"..modifierLevel;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'BPrefMoreShel';
    }
    override void initAndapplyEffectToRBackpack(RWBackpack bpk, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, bpk.stats.maxShel/2);

        bpk.stats.maxShel -= modifierLevel;
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
        return "Max Shells +"..modifierLevel;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'BPrefLessShel';
    }
    override void initAndapplyEffectToRBackpack(RWBackpack bpk, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, bpk.stats.maxShel*2);

        bpk.stats.maxShel += modifierLevel;
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
        return "Max Rockets -"..modifierLevel;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'BPrefMoreRckt';
    }
    override void initAndapplyEffectToRBackpack(RWBackpack bpk, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, bpk.stats.maxRckt/2);

        bpk.stats.maxRckt -= modifierLevel;
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
        return "Max Rockets +"..modifierLevel;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'BPrefLessRckt';
    }
    override void initAndapplyEffectToRBackpack(RWBackpack bpk, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, 3*bpk.stats.maxRckt/2);

        bpk.stats.maxRckt += modifierLevel;
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
        return "Max Cells -"..modifierLevel;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'BPrefMoreCell';
    }
    override void initAndapplyEffectToRBackpack(RWBackpack bpk, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, bpk.stats.maxCell/2);

        bpk.stats.maxCell -= modifierLevel;
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
        return "Max Cells +"..modifierLevel;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'BPrefLessCell';
    }
    override void initAndapplyEffectToRBackpack(RWBackpack bpk, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, bpk.stats.maxCell*2);

        bpk.stats.maxCell += modifierLevel;
    }
}
