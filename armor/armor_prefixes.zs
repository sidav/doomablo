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
    override string getDescription() {
        return "Max durability -"..modifierLevel;
    }
    override void Init() {
        modifierLevel = 5*rnd.Rand(2, 10);
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'APrefSturdy';
    }
    override void applyEffectToArmor(RandomizedArmor arm) {
        arm.stats.MaxAmount -= modifierLevel;
        arm.stats.CurrentAmount -= modifierLevel;
    }
}


class APrefSturdy : RwArmorPrefix {
    override string getName() {
        return "sturdy";
    }
    override string getDescription() {
        return "Max amount +"..modifierLevel;
    }
    override void Init() {
        modifierLevel = 5*rnd.Rand(2, 10);
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'APrefFragile';
    }
    override void applyEffectToArmor(RandomizedArmor arm) {
        arm.stats.MaxAmount += modifierLevel;
        arm.stats.CurrentAmount += modifierLevel;
    }
}

class APrefSoft : RwArmorPrefix {
    override string getName() {
        return "soft";
    }
    override string getDescription() {
        return "Absorbs -"..modifierLevel.."% damage";
    }
    override void Init() {
        modifierLevel = rnd.Rand(1, 25);
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'APrefHard';
    }
    override void applyEffectToArmor(RandomizedArmor arm) {
        arm.stats.AbsorbsPercentage -= modifierLevel;
    }
}


class APrefHard : RwArmorPrefix {
    override string getName() {
        return "Hard";
    }
    override string getDescription() {
        return "Absorbs +"..modifierLevel.."% damage";
    }
    override void Init() {
        modifierLevel = rnd.Rand(1, 25);
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'APrefSoft';
    }
    override void applyEffectToArmor(RandomizedArmor arm) {
        arm.stats.AbsorbsPercentage += modifierLevel;
    }
}

class APrefWorseRepair : RwArmorPrefix {
    override string getName() {
        return "Nondismantable";
    }
    override string getDescription() {
        return "Gets -"..modifierLevel.." armor from repars";
    }
    override void Init() {
        modifierLevel = rnd.Rand(1, 3);
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'APrefBetterRepair';
    }
    override void applyEffectToArmor(RandomizedArmor arm) {
        arm.stats.BonusRepair -= modifierLevel;
    }
}


class APrefBetterRepair : RwArmorPrefix {
    override string getName() {
        return "modular";
    }
    override string getDescription() {
        return "Gets +"..modifierLevel.." armor from repars";
    }
    override void Init() {
        modifierLevel = rnd.Rand(1, 3);
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'APrefWorseRepair';
    }
    override void applyEffectToArmor(RandomizedArmor arm) {
        arm.stats.BonusRepair += modifierLevel;
    }
}

