class RwMonsterSuffix : Affix {
    override void InitAndApplyEffectToItem(Inventory item, int quality) {
        initAndApplyEffectToRwMonsterAffixator(RwMonsterAffixator(item), quality);
    }
    protected virtual void initAndApplyEffectToRwMonsterAffixator(RwMonsterAffixator affixator, int quality) {
        debug.panicUnimplemented(self);
    }
    override bool isSuffix() {
        return true;
    }
    override int getAlignment() {
        return 1;
    }
    override string getDescription() {
        return "";
    }
    override bool IsCompatibleWithItem(Inventory item) {
        return (RwMonsterAffixator(item) != null);
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return !(a2 is 'RwMonsterSuffix'); // There may be only one suffix on an item
    }
}

class MSuffRegen : RwMonsterSuffix {
    override string getName() {
        return "Fear-feeding";
    }
    override void initAndApplyEffectToRwMonsterAffixator(RwMonsterAffixator affixator, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, 10);
    }
    override string getDescription() {
        return "Regen "..modifierLevel;
    }
    override void onDoEffect(Actor owner) {
        if (owner.GetAge() % TICRATE == 0) {
            owner.GiveBody(modifierLevel);
        }
    }
}

class MSuffThorns : RwMonsterSuffix {
    override string getName() {
        return "Untouchable";
    }
    override void initAndApplyEffectToRwMonsterAffixator(RwMonsterAffixator affixator, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, 10);
    }
    override string getDescription() {
        return "Thorns "..modifierLevel;
    }
    override void onModifyDamageToOwner(int damage, Name damageType, out int newdamage, Actor inflictor, Actor source, int flags) {
        if (source) {
            source.damageMobj(null, null, modifierLevel, 'Normal');
        }
    }
}
