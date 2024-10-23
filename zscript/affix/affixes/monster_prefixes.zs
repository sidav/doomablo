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
        return "Unholy";
    }
    override int getAlignment() {
        return 1;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return true;
    }
    override void initAndApplyEffectToRwMonsterAffixator(RwMonsterAffixator affixator, int quality) {
        modifierLevel = remapQualityToRange(quality, 125, 300);
    }
    override void onPutIntoMonsterInventory(Actor owner) {
        owner.starthealth = math.getIntPercentage(owner.health, modifierLevel);
        owner.A_SetHealth(owner.starthealth);
    }
}

// Stub for "negative" affix
class MPrefMoreHealth2 : MPrefMoreHealth {
    override int getAlignment() {
        return -1;
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
    override void onModifyDamageDealtByOwner(int damage, Name damageType, out int newdamage, Actor inflictor, Actor source, int flags) {
        newdamage = math.getIntPercentage(damage, modifierLevel);
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
    override void onModifyDamageDealtByOwner(int damage, Name damageType, out int newdamage, Actor inflictor, Actor source, int flags) {
        newdamage = math.getIntPercentage(damage, modifierLevel);
    }
}
