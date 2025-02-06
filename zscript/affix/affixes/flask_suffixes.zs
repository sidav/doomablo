class RwFlaskSuffix : Affix {
    override void InitAndApplyEffectToItem(Inventory item, int quality) {
        initAndapplyEffectToRFlask(RWFlask(item), quality);
    }
    protected virtual void initAndapplyEffectToRFlask(RWFlask fsk, int quality) {
        debug.panicUnimplemented(self);
    }
    override bool IsCompatibleWithItem(Inventory item) {
        return (RWFlask(item) != null);
    }
    override bool isSuffix() {
        return true;
    }
    override int getAlignment() {
        return 1;
    }
    override int minRequiredRarity() {
        return 3; // Most suffixes require at least "rare"
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return !(a2 is 'RwFlaskSuffix'); // There may be only one suffix on an item
    }
}

class FSuffInstantHeal : RwFlaskSuffix {
    override string getName() {
        return "Emergency";
    }
    override string getDescription() {
        return "Instantly heals "..modifierLevel.." HP on use";
    }
    override int getAlignment() {
        return 1;
    }
    override void initAndapplyEffectToRFlask(RWFlask fsk, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, 25) + 5;
    }
}
