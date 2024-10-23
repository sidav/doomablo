// There is NO "one suffix" restriction for monsters, so monster prefixes and suffixes are just one class
class RwMonsterAffix : Affix {
    override void InitAndApplyEffectToItem(Inventory item, int quality) {
        initAndApplyEffectToRwMonsterAffixator(RwMonsterAffixator(item), quality);
    }
    protected virtual void initAndApplyEffectToRwMonsterAffixator(RwMonsterAffixator affixator, int quality) {
        debug.panicUnimplemented(self);
    }
    override int getAlignment() {
        return 0;
    }
    override string getDescription() {
        return "";
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return true;
    }
    override bool IsCompatibleWithItem(Inventory item) {
        return (RwMonsterAffixator(item) != null);
    }
}

class MPrefMoreHealth : RwMonsterAffix {
    override string getName() {
        return "Unholy";
    }
    override void initAndApplyEffectToRwMonsterAffixator(RwMonsterAffixator affixator, int quality) {
        modifierLevel = remapQualityToRange(quality, 125, 300);
    }
    override void onPutIntoMonsterInventory(Actor owner) {
        owner.starthealth = math.getIntPercentage(owner.health, modifierLevel);
        owner.A_SetHealth(owner.starthealth);
    }
}

class MPrefHigherDamage : RwMonsterAffix {
    override string getName() {
        return "strong";
    }
    override string getDescription() {
        return "DMG +"..modifierLevel.."%";
    }
    override void initAndApplyEffectToRwMonsterAffixator(RwMonsterAffixator affixator, int quality) {
        modifierLevel = remapQualityToRange(quality, 25, 200);
    }
    override void onModifyDamageDealtByOwner(int damage, Name damageType, out int newdamage, Actor inflictor, Actor source, int flags) {
        newdamage = math.getIntPercentage(damage, 100+modifierLevel);
    }
}

class MSuffRegen : RwMonsterAffix {
    override string getName() {
        return "Fear-feeding";
    }
    override string getDescription() {
        return "Regen "..modifierLevel;
    }
    override void initAndApplyEffectToRwMonsterAffixator(RwMonsterAffixator affixator, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, 10);
    }
    override void onDoEffect(Actor owner) {
        if (owner.GetAge() % TICRATE == 0) {
            owner.GiveBody(modifierLevel);
        }
    }
}

class MSuffThorns : RwMonsterAffix {
    override string getName() {
        return "Untouchable";
    }
    override string getDescription() {
        return "Thorns "..modifierLevel;
    }
    override void initAndApplyEffectToRwMonsterAffixator(RwMonsterAffixator affixator, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, 10);
    }
    override void onModifyDamageToOwner(int damage, Name damageType, out int newdamage, Actor inflictor, Actor source, int flags) {
        if (source) {
            source.damageMobj(null, null, modifierLevel, 'Normal');
        }
    }
}
