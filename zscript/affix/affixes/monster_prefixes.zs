class RwMonsterPrefix : Affix {
    override void InitAndApplyEffectToItem(Inventory item, int quality) {
        initAndApplyEffectToRwMonsterAffixator(RwMonsterAffixator(item), quality);
    }
    protected virtual void initAndApplyEffectToRwMonsterAffixator(RwMonsterAffixator affixator, int quality) {
        debug.panicUnimplemented(self);
    }
    override string getDescription() {
        return "";
    }
    override bool IsCompatibleWithItem(Inventory item) {
        return (RwMonsterAffixator(item) != null);
    }
}

class MPrefMoreHealth : RwMonsterPrefix {
    override string getName() {
        return "Think of a name for me";
    }
    override int getAlignment() {
        return 1;
    }
    override void initAndApplyEffectToRwMonsterAffixator(RwMonsterAffixator affixator, int quality) {
        modifierLevel = remapQualityToRange(quality, 125, 300);
    }
    override void onPutIntoMonsterInventory(Actor owner) {
        owner.starthealth = math.getIntPercentage(owner.starthealth, modifierLevel);
        owner.A_SetHealth(owner.starthealth);
    }
}

class MPrefLowerDamage : RwMonsterPrefix {
    override string getName() {
        return "weak";
    }
    override int getAlignment() {
        return -1;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'MPrefHigherDamage';
    }
    override void initAndApplyEffectToRwMonsterAffixator(RwMonsterAffixator affixator, int quality) {
        modifierLevel = remapQualityToRange(quality, 85, 75);
    }
}

class MPrefHigherDamage : RwMonsterPrefix {
    override string getName() {
        return "strong";
    }
    override int getAlignment() {
        return 1;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'MPrefLowerDamage';
    }
    override void initAndApplyEffectToRwMonsterAffixator(RwMonsterAffixator affixator, int quality) {
        modifierLevel = remapQualityToRange(quality, 125, 300);
    }
    override void onPutIntoMonsterInventory(Actor owner) {
        
    }
}
