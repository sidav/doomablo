class RwRelicAffix : Affix abstract {
    override bool isSuffix() {
        return false;
    }
    override bool IsCompatibleWithItem(Inventory item) {
        return item is 'RwRelic';
    }
    override int getAlignment() {
        return 1;
    }
    override int selectionProbabilityPercentage(Inventory appliedOn) {
        return 25;
    }
}

class RAffPlusAllStats : RwRelicAffix {
    override bool isSuffix() {
        return true;
    }
    override string getName() {
        return "VIP";
    }
    override string getDescription() {
        return "All stats +"..modifierLevel;
    }
    override void InitAndApplyEffectToItem(Inventory item, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, 15, 0.05) + remapQualityToRange(quality, 1, 10);
    }
    override bool TryUnapplyingSelfFrom(Inventory item) {
        return true;
    }
    override void onPlayerStatsRecalc(RwPlayer owner) {
        owner.stats.modifyCurrentStat(RwPlayerStats.StatVitality, modifierLevel);
        owner.stats.modifyCurrentStat(RwPlayerStats.StatCritChance, modifierLevel);
        owner.stats.modifyCurrentStat(RwPlayerStats.StatCritDmg, modifierLevel);
        owner.stats.modifyCurrentStat(RwPlayerStats.StatStrength, modifierLevel);
        owner.stats.modifyCurrentStat(RwPlayerStats.StatRareFind, modifierLevel);
    }
}

class RAffTest : RwRelicAffix {
    override bool isSuffix() {
        return true;
    }
    override string getName() {
        return "TEST";
    }
    override string getDescription() {
        return "TEST TEST TEST +"..modifierLevel;
    }
    override void InitAndApplyEffectToItem(Inventory item, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, 15, 0.05) + remapQualityToRange(quality, 1, 5);
    }
    override bool TryUnapplyingSelfFrom(Inventory item) {
        return true;
    }
    override void onPlayerStatsRecalc(RwPlayer owner) {

    }
}