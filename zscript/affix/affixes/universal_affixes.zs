// Those are the affixes which can be applied to any (or almost any) player artifact regardless of its type.
class RwUniversalAffix : Affix abstract {
    override bool isSuffix() {
        return false;
    }
    override bool IsCompatibleWithItem(Inventory item) {
        return !(item is 'RwMonsterAffixator');
    }
    override int getAlignment() {
        return 1;
    }
    override int selectionProbabilityPercentage() {
        return 55;
    }
}

/////////////////////////////////
/////////////////////////////////
// STAT-ALTERING AFFIXES

class UPrefVitalityDecrease : RwUniversalAffix {
    override string getName() {
        return "Withering";
    }
    override string getDescription() {
        return "Vitality stat -"..modifierLevel;
    }
    override int getAlignment() {
        return -1;
    }
    override void InitAndApplyEffectToItem(Inventory item, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, 5, 0.1) + remapQualityToRange(quality, 1, 5);
    }
    override bool TryUnapplyingSelfFrom(Inventory item) {
        return true;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'UPrefVitalityIncrease';
    }
    override void onPlayerStatsRecalc(RwPlayer owner) {
        owner.stats.modifyCurrentStat(RwPlayerStats.StatVitality, -modifierLevel);
    }
}

class UPrefVitalityIncrease : RwUniversalAffix {
    override string getName() {
        return "Vitalizing";
    }
    override string getDescription() {
        return "Vitality stat +"..modifierLevel;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'UPrefVitalityDecrease';
    }
    override void InitAndApplyEffectToItem(Inventory item, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, 15, 0.05) + remapQualityToRange(quality, 1, 15);
    }
    override void onPlayerStatsRecalc(RwPlayer owner) {
        owner.stats.modifyCurrentStat(RwPlayerStats.StatVitality, modifierLevel);
    }
}

class UPrefCritChanceDecrease : RwUniversalAffix {
    override string getName() {
        return "Clumsy";
    }
    override string getDescription() {
        return "Crit chance stat -"..modifierLevel;
    }
    override int getAlignment() {
        return -1;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'UPrefCritChanceIncrease';
    }
    override void InitAndApplyEffectToItem(Inventory item, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, 5, 0.1) + remapQualityToRange(quality, 1, 5);
    }
    override bool TryUnapplyingSelfFrom(Inventory item) {
        return true;
    }
    override void onPlayerStatsRecalc(RwPlayer owner) {
        owner.stats.modifyCurrentStat(RwPlayerStats.StatCritChance, -modifierLevel);
    }
}

class UPrefCritChanceIncrease : RwUniversalAffix {
    override string getName() {
        return "Dexter";
    }
    override string getDescription() {
        return "Crit chance stat +"..modifierLevel;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'UPrefCritChanceDecrease';
    }
    override void InitAndApplyEffectToItem(Inventory item, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, 5, 0.05) + remapQualityToRange(quality, 1, 10);
    }
    override void onPlayerStatsRecalc(RwPlayer owner) {
        owner.stats.modifyCurrentStat(RwPlayerStats.StatCritChance, modifierLevel);
    }
}

class UPrefCritDmgDecrease : RwUniversalAffix {
    override string getName() {
        return "Uncritical";
    }
    override string getDescription() {
        return "Crit damage stat -"..modifierLevel;
    }
    override int getAlignment() {
        return -1;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'UPrefCritDmgIncrease';
    }
    override void InitAndApplyEffectToItem(Inventory item, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, 5, 0.1) + remapQualityToRange(quality, 1, 5);
    }
    override bool TryUnapplyingSelfFrom(Inventory item) {
        return true;
    }
    override void onPlayerStatsRecalc(RwPlayer owner) {
        owner.stats.modifyCurrentStat(RwPlayerStats.StatCritDmg, -modifierLevel);
    }
}

class UPrefCritDmgIncrease : RwUniversalAffix {
    override string getName() {
        return "Critical";
    }
    override string getDescription() {
        return "Crit damage stat +"..modifierLevel;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'UPrefCritChanceDecrease';
    }
    override void InitAndApplyEffectToItem(Inventory item, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, 5, 0.05) + remapQualityToRange(quality, 1, 10);
    }
    override void onPlayerStatsRecalc(RwPlayer owner) {
        owner.stats.modifyCurrentStat(RwPlayerStats.StatCritDmg, modifierLevel);
    }
}

class UPrefMeleeDmgDecrease : RwUniversalAffix {
    override string getName() {
        return "Weakening";
    }
    override string getDescription() {
        return "Fist dmg stat -"..modifierLevel;
    }
    override int getAlignment() {
        return -1;
    }
    override bool IsCompatibleWithItem(Inventory item) {
        return !(item is 'RwMonsterAffixator' || item is 'RandomizedWeapon');
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'UPrefMeleeDmgIncrease';
    }
    override void InitAndApplyEffectToItem(Inventory item, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, 5, 0.1) + remapQualityToRange(quality, 1, 5);
    }
    override bool TryUnapplyingSelfFrom(Inventory item) {
        return true;
    }
    override void onPlayerStatsRecalc(RwPlayer owner) {
        owner.stats.modifyCurrentStat(RwPlayerStats.StatMeleeDmg, -modifierLevel);
    }
}

class UPrefMeleeDmgIncrease : RwUniversalAffix {
    override string getName() {
        return "Enraging";
    }
    override string getDescription() {
        return "Fist dmg stat +"..modifierLevel;
    }
    override bool IsCompatibleWithItem(Inventory item) {
        return !(item is 'RwMonsterAffixator' || item is 'RandomizedWeapon');
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'UPrefMeleeDmgDecrease';
    }
    override void InitAndApplyEffectToItem(Inventory item, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, 5, 0.05) + remapQualityToRange(quality, 1, 10);
    }
    override void onPlayerStatsRecalc(RwPlayer owner) {
        owner.stats.modifyCurrentStat(RwPlayerStats.StatMeleeDmg, modifierLevel);
    }
}

class UPrefRareFindDecrease : RwUniversalAffix {
    override string getName() {
        return "Boring";
    }
    override string getDescription() {
        return "Rare find stat -"..modifierLevel;
    }
    override int getAlignment() {
        return -1;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'UPrefRareFindIncrease';
    }
    override void InitAndApplyEffectToItem(Inventory item, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, 5, 0.1) + remapQualityToRange(quality, 1, 5);
    }
    override bool TryUnapplyingSelfFrom(Inventory item) {
        return true;
    }
    override void onPlayerStatsRecalc(RwPlayer owner) {
        owner.stats.modifyCurrentStat(RwPlayerStats.StatRareFind, -modifierLevel);
    }
}

class UPrefRareFindIncrease : RwUniversalAffix {
    override string getName() {
        return "Lucky";
    }
    override string getDescription() {
        return "Rare find stat +"..modifierLevel;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'UPrefRareFindDecrease';
    }
    override void InitAndApplyEffectToItem(Inventory item, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, 5, 0.05) + remapQualityToRange(quality, 1, 10);
    }
    override void onPlayerStatsRecalc(RwPlayer owner) {
        owner.stats.modifyCurrentStat(RwPlayerStats.StatRareFind, modifierLevel);
    }
}
