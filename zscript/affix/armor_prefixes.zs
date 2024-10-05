class RwArmorPrefix : Affix {
    override bool IsCompatibleWithItem(Inventory item) {
        return RandomizedArmor(item) != null;
    }
}

// Universal ones

class APrefFragile : RwArmorPrefix {
    override string getName() {
        return "fragile";
    }
    override int getAlignment() {
        return -1;
    }
    override string getDescription() {
        return "Max durability -"..modifierLevel;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'APrefSturdy';
    }
    override void initAndapplyEffectToRArmor(RandomizedArmor arm, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, arm.stats.maxDurability/2); // 5*rnd.linearWeightedRand(1, arm.stats.maxDurability/10, 5, 1);

        arm.stats.maxDurability -= modifierLevel;
    }
}


class APrefSturdy : RwArmorPrefix {
    override string getName() {
        return "sturdy";
    }
    override int getAlignment() {
        return 1;
    }
    override string getDescription() {
        return "Max durability +"..modifierLevel;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'APrefFragile';
    }
    override void initAndapplyEffectToRArmor(RandomizedArmor arm, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, arm.stats.maxDurability); // 5*rnd.linearWeightedRand(1, 10, 10, 1);

        arm.stats.maxDurability += modifierLevel;
    }
}

class APrefSoft : RwArmorPrefix {
    override string getName() {
        return "soft";
    }
    override int getAlignment() {
        return -1;
    }
    override string getDescription() {
        return "Absorbs -"..modifierLevel.."% damage";
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'APrefHard';
    }
    override void initAndapplyEffectToRArmor(RandomizedArmor arm, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, 2*arm.stats.AbsorbsPercentage/3);

        arm.stats.AbsorbsPercentage -= modifierLevel;
    }
}


class APrefHard : RwArmorPrefix {
    override string getName() {
        return "Hard";
    }
    override int getAlignment() {
        return 1;
    }
    override string getDescription() {
        return "Absorbs +"..modifierLevel.."% damage";
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'APrefSoft';
    }
    override void initAndapplyEffectToRArmor(RandomizedArmor arm, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, 2*(100-arm.stats.AbsorbsPercentage)/3);

        arm.stats.AbsorbsPercentage += modifierLevel;
    }
}

class APrefWorseRepair : RwArmorPrefix {
    override string getName() {
        return "Nondismantable";
    }
    override int getAlignment() {
        return -1;
    }
    override string getDescription() {
        return "Gets -"..modifierLevel.." armor from repairs";
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'APrefBetterRepair';
    }
    override void initAndapplyEffectToRArmor(RandomizedArmor arm, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, arm.stats.BonusRepair-1);

        arm.stats.BonusRepair -= modifierLevel;
    }
}


class APrefBetterRepair : RwArmorPrefix {
    override string getName() {
        return "modular";
    }
    override int getAlignment() {
        return 1;
    }
    override string getDescription() {
        return "Gets +"..modifierLevel.." armor from repairs";
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'APrefWorseRepair';
    }
    override void initAndapplyEffectToRArmor(RandomizedArmor arm, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, arm.stats.BonusRepair*2);

        arm.stats.BonusRepair += modifierLevel;
    }
}

class APrefDamageIncrease : RwArmorPrefix {
    override string getName() {
        return "Unfit";
    }
    override int getAlignment() {
        return -1;
    }
    override string getDescription() {
        return "Increases incoming damage by "..modifierLevel;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'APrefDamageReduction';
    }
    override void initAndapplyEffectToRArmor(RandomizedArmor arm, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, 10);

        arm.stats.DamageReduction -= modifierLevel;
    }
}

class APrefDamageReduction : RwArmorPrefix {
    override string getName() {
        return "Reactive";
    }
    override int getAlignment() {
        return 1;
    }
    override string getDescription() {
        return "Reduces incoming damage by "..modifierLevel;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'APrefDamageIncrease';
    }
    override void initAndapplyEffectToRArmor(RandomizedArmor arm, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, 10);

        arm.stats.DamageReduction += modifierLevel;
    }
}
