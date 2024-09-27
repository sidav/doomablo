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
    override void initAndapplyEffectToRArmor(RandomizedArmor arm) {
        modifierLevel = 5*rnd.linearWeightedRand(1, arm.stats.maxDurability/10, 5, 1);

        arm.stats.maxDurability -= modifierLevel;
        arm.stats.currDurability -= modifierLevel;
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
    override void initAndapplyEffectToRArmor(RandomizedArmor arm) {
        modifierLevel = 5*rnd.linearWeightedRand(1, 10, 10, 1);

        arm.stats.maxDurability += modifierLevel;
        arm.stats.currDurability += modifierLevel;
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
    override void initAndapplyEffectToRArmor(RandomizedArmor arm) {
        modifierLevel = rnd.linearWeightedRand(1, 25, 5, 1);

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
    override void initAndapplyEffectToRArmor(RandomizedArmor arm) {
        modifierLevel = rnd.linearWeightedRand(1, 2*(100-arm.stats.AbsorbsPercentage)/3, 5, 1);

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
    override void initAndapplyEffectToRArmor(RandomizedArmor arm) {
        modifierLevel = rnd.Rand(1, arm.stats.BonusRepair-1);

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
    override void initAndapplyEffectToRArmor(RandomizedArmor arm) {
        modifierLevel = rnd.linearWeightedRand(1, 5, 10, 1);

        arm.stats.BonusRepair += modifierLevel;
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
        return true;
    }
    override void initAndapplyEffectToRArmor(RandomizedArmor arm) {
        modifierLevel = rnd.linearWeightedRand(1, 10, 100, 1);

        arm.stats.DamageReduction += modifierLevel;
    }
}
