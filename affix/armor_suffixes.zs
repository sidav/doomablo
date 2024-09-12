class RwArmorSuffix : Affix {
    override bool isSuffix() {
        return true;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return !(a2 is 'RwArmorSuffix'); // There may be only one suffix on an item
    }
    override bool IsCompatibleWithItem(Inventory item) {
        return RandomizedArmor(item) != null;
    }
}

// Universal ones

class ASuffSelfrepair : RwArmorSuffix {
    override string getName() {
        return "UAC Nanotech";
    }
    override string getDescription() {
        return "Repairs itself each "..modifierLevel.." seconds";
    }
    override void initAndapplyEffectToRArmor(RandomizedArmor arm) {
        modifierLevel = rnd.linearWeightedRand(1, 10, 1, 10);
    }
}

class ASuffHealing : RwArmorSuffix {
    override string getName() {
        return "UAC Auto-Med";
    }
    override string getDescription() {
        return "Each "..modifierLevel.." seconds tranfers 1 durability to your health";
    }
    override void initAndapplyEffectToRArmor(RandomizedArmor arm) {
        modifierLevel = rnd.linearWeightedRand(1, 10, 1, 10);
    }
}
