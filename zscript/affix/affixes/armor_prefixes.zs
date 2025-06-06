class RwArmorPrefix : Affix abstract {
    override void InitAndApplyEffectToItem(Inventory item, int quality) {
        initAndapplyEffectToRArmor(RandomizedArmor(item), quality);
    }
    protected virtual void initAndapplyEffectToRArmor(RandomizedArmor armor, int quality) {
        debug.panicUnimplemented(self);
    }
    override bool IsCompatibleWithItem(Inventory item) {
        return (RandomizedArmor(item) != null) && IsCompatibleWithRArmor(RandomizedArmor(item));
    }
    // Override this, and not IsCompatibleWithItem() in descendants. Stop excessive super.IsCompatibleWithItem() calls!
    private virtual bool IsCompatibleWithRArmor(RandomizedArmor arm) {
        return true;
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
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, arm.stats.maxDurability/5, 0.05) + remapQualityToRange(quality, 0, arm.stats.maxDurability/5);

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
        if (arm.stats.IsEnergyArmor()) {
            modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, arm.stats.maxDurability, 0.05) + remapQualityToRange(quality, 0, arm.stats.maxDurability/2);
        } else {
            modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, arm.stats.maxDurability, 0.05) + remapQualityToRange(quality, 0, arm.stats.maxDurability);
        }

        arm.stats.maxDurability += modifierLevel;
    }
}

class APrefWorseAbsorption : RwArmorPrefix {
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
        return a2.GetClass() != 'APrefBetterAbsorption';
    }
    override void initAndapplyEffectToRArmor(RandomizedArmor arm, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, arm.stats.AbsorbsPercentage/5, 0.05) + remapQualityToRange(quality, 0, arm.stats.AbsorbsPercentage/5);
        arm.stats.AbsorbsPercentage -= modifierLevel;
    }
}


class APrefBetterAbsorption : RwArmorPrefix {
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
        return a2.GetClass() != 'APrefWorseAbsorption';
    }
    override void initAndapplyEffectToRArmor(RandomizedArmor arm, int quality) {
        if (arm.stats.IsEnergyArmor()) {
            let remainingToMax = 95 - arm.stats.AbsorbsPercentage;
            modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, remainingToMax/2, 0.05) + remapQualityToRange(quality, 0, remainingToMax/2);
        } else {
            let remainingToMax = 100 - arm.stats.AbsorbsPercentage;
            modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, remainingToMax/2, 0.05) + remapQualityToRange(quality, 0, remainingToMax/2);
        }

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
    override bool IsCompatibleWithRArmor(RandomizedArmor arm) {
        return !(arm.stats.IsEnergyArmor());
    }
    override void initAndapplyEffectToRArmor(RandomizedArmor arm, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, arm.stats.BonusRepair-1);

        arm.stats.BonusRepair -= modifierLevel;
    }
}


class APrefBetterRepair : RwArmorPrefix {
    override string getName() {
        return "Modular";
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
    override bool IsCompatibleWithRArmor(RandomizedArmor arm) {
        return !(arm.stats.IsEnergyArmor());
    }
    override void initAndapplyEffectToRArmor(RandomizedArmor arm, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, 4, 0.1) + remapQualityToRange(quality, 0, 2);

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
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, 6, 0.1) + remapQualityToRange(quality, 0, 4);
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
        if (arm.stats.IsEnergyArmor()) {
            modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, 4, 0.05) + remapQualityToRange(quality, 0, 2);
        } else {
            modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, 6, 0.05) + remapQualityToRange(quality, 0, 3);
        }

        arm.stats.DamageReduction += modifierLevel;
    }
}

// Energy armor-only prefixes

class APrefELongerDelay : RwArmorPrefix {
    override string getName() {
        return "Non-tuned";
    }
    override int getAlignment() {
        return -1;
    }
    override string getDescription() {
        return String.format("Recharge delay +%d%%", (modifierLevel) );
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'APrefEShorterDelay';
    }
    override bool IsCompatibleWithRArmor(RandomizedArmor arm) {
        return arm.stats.IsEnergyArmor();
    }
    override void initAndapplyEffectToRArmor(RandomizedArmor arm, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(max(5, quality/10), 50, 0.1);
        arm.stats.delayUntilRecharge = math.getIntPercentage(arm.stats.delayUntilRecharge, 100 + modifierLevel);
    }
}

class APrefEShorterDelay : RwArmorPrefix {
    override string getName() {
        return "Fine-tuned";
    }
    override int getAlignment() {
        return 1;
    }
    override string getDescription() {
        return String.format("Recharge delay -%d%%", (modifierLevel) );
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'APrefELongerDelay';
    }
    override bool IsCompatibleWithRArmor(RandomizedArmor arm) {
        return arm.stats.IsEnergyArmor();
    }
    override void initAndapplyEffectToRArmor(RandomizedArmor arm, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(5, 60, 0.05) + remapQualityToRange(quality, 0, 10);
        arm.stats.delayUntilRecharge = math.getIntPercentage(arm.stats.delayUntilRecharge, 100 - modifierLevel);
    }
}

class APrefELongerRecharge : RwArmorPrefix {
    override string getName() {
        return "Overheating";
    }
    override int getAlignment() {
        return -1;
    }
    override string getDescription() {
        return String.Format("%d%% slower recharge", modifierLevel);
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'APrefEFasterRecharge';
    }
    override bool IsCompatibleWithRArmor(RandomizedArmor arm) {
        return arm.stats.IsEnergyArmor();
    }
    override void initAndapplyEffectToRArmor(RandomizedArmor arm, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(max(5, quality/10), 50, 0.1);
        arm.stats.energyRestoreSpeedX1000 = math.getIntPercentage(arm.stats.energyRestoreSpeedX1000, 100-modifierLevel);
    }
}

class APrefEFasterRecharge : RwArmorPrefix {
    override string getName() {
        return "Ventilated";
    }
    override int getAlignment() {
        return 1;
    }
    override string getDescription() {
        return String.Format("%d%% faster recharge", modifierLevel);
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'APrefELongerRecharge';
    }
    override bool IsCompatibleWithRArmor(RandomizedArmor arm) {
        return arm.stats.IsEnergyArmor();
    }
    override void initAndapplyEffectToRArmor(RandomizedArmor arm, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(5, 250, 0.05) + remapQualityToRange(quality, 0, 50);
        arm.stats.energyRestoreSpeedX1000 = math.getIntPercentage(arm.stats.energyRestoreSpeedX1000, 100+modifierLevel);
    }
}
