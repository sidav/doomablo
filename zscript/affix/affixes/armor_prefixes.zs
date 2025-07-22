class RwArmorPrefix : Affix abstract {
    override void InitAndApplyEffectToItem(Inventory item, int quality) {
        initAndapplyEffectToRArmor(RwArmor(item), quality);
    }
    protected virtual void initAndapplyEffectToRArmor(RwArmor armor, int quality) {
        debug.panicUnimplemented(self);
    }
    override bool IsCompatibleWithItem(Inventory item) {
        return (RwArmor(item) != null) && IsCompatibleWithRArmor(RwArmor(item));
    }
    // Override this, and not IsCompatibleWithItem() in descendants. Stop excessive super.IsCompatibleWithItem() calls!
    private virtual bool IsCompatibleWithRArmor(RwArmor arm) {
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
    override void initAndapplyEffectToRArmor(RwArmor arm, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, arm.stats.maxDurability/6, 0.05) + remapQualityToRange(quality, 0, arm.stats.maxDurability/6);

        arm.stats.maxDurability -= modifierLevel;
    }
    override bool TryUnapplyingSelfFrom(Inventory item) {
        RwArmor(item).stats.maxDurability += modifierLevel;
        return true;
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
    override void initAndapplyEffectToRArmor(RwArmor arm, int quality) {
        if (arm.stats.IsEnergyArmor()) {
            modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, arm.stats.maxDurability, 0.05) + remapQualityToRange(quality, 0, arm.stats.maxDurability/2);
        } else {
            modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, arm.stats.maxDurability/2, 0.05) + remapQualityToRange(quality, 0, 3*arm.stats.maxDurability/2);
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
    override void initAndapplyEffectToRArmor(RwArmor arm, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, arm.stats.AbsorbsPercentage/6, 0.05) + remapQualityToRange(quality, 0, arm.stats.AbsorbsPercentage/6);
        arm.stats.AbsorbsPercentage -= modifierLevel;
    }
    override bool TryUnapplyingSelfFrom(Inventory item) {
        RwArmor(item).stats.AbsorbsPercentage += modifierLevel;
        return true;
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
    override void initAndapplyEffectToRArmor(RwArmor arm, int quality) {
        if (arm.stats.IsEnergyArmor()) {
            let remainingToMax = 95 - arm.stats.AbsorbsPercentage;
            modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, remainingToMax/2, 0.05) + remapQualityToRange(quality, 0, remainingToMax/2);
        } else {
            let remainingToMax = 100 - arm.stats.AbsorbsPercentage;
            modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, remainingToMax/3, 0.05) + remapQualityToRange(quality, 0, 2*remainingToMax/3);
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
        return "Gets -"..StringsHelper.FixedPointIntAsString(modifierLevel, 1000).." armor from repairs";
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'APrefBetterRepair';
    }
    override bool IsCompatibleWithRArmor(RwArmor arm) {
        return !(arm.stats.IsEnergyArmor());
    }
    override void initAndapplyEffectToRArmor(RwArmor arm, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(200, arm.stats.RepairFromBonusx1000/2, 0.05) + remapQualityToRange(quality, 100, arm.stats.RepairFromBonusx1000/2);
        arm.stats.RepairFromBonusx1000 -= modifierLevel;
    }
    override bool TryUnapplyingSelfFrom(Inventory item) {
        RwArmor(item).stats.RepairFromBonusx1000 += modifierLevel;
        return true;
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
        return "Gets +"..StringsHelper.FixedPointIntAsString(modifierLevel, 1000).." armor from repairs";
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'APrefWorseRepair';
    }
    override bool IsCompatibleWithRArmor(RwArmor arm) {
        return !(arm.stats.IsEnergyArmor());
    }
    override void initAndapplyEffectToRArmor(RwArmor arm, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(300, 3000, 0.1) + remapQualityToRange(quality, 0, 2000);
        arm.stats.RepairFromBonusx1000 += modifierLevel;
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
        return "Increases incoming damage by "..StringsHelper.FixedPointIntAsString(modifierLevel, 10);
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'APrefDamageReduction';
    }
    override void initAndapplyEffectToRArmor(RwArmor arm, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(3, 20, 0.1) + remapQualityToRange(quality, 0, 10);
    }
    override bool TryUnapplyingSelfFrom(Inventory item) {
        return true;
    }
    int fractionAccum;
    override void onAbsorbDamage(int damage, Name damageType, out int newdamage, Actor inflictor, Actor source, Actor armorOwner, int flags) {
        if (damage > 0) {
            newdamage = math.AccumulatedFixedPointAdd(damage, modifierLevel, 10, fractionAccum);
        }
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
        return "Reduces incoming damage by "..StringsHelper.FixedPointIntAsString(modifierLevel, 10);
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'APrefDamageIncrease';
    }
    override void initAndapplyEffectToRArmor(RwArmor arm, int quality) {
        if (arm.stats.IsEnergyArmor()) {
            modifierLevel = rnd.multipliedWeightedRandByEndWeight(5, 20, 0.05) + remapQualityToRange(quality, 0, 15);
        } else {
            modifierLevel = rnd.multipliedWeightedRandByEndWeight(5, 30, 0.05) + remapQualityToRange(quality, 0, 30);
        }
    }
    int fractionAccum;
    override void onAbsorbDamage(int damage, Name damageType, out int newdamage, Actor inflictor, Actor source, Actor armorOwner, int flags) {
        if (damage > 0) {
            let reduction = math.AccumulatedFixedPointAdd(0, modifierLevel, 10, fractionAccum);
            if (reduction > damage) reduction = damage - 1; // Don't reduce to 0
            newdamage = damage - reduction;
        }
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
    override bool IsCompatibleWithRArmor(RwArmor arm) {
        return arm.stats.IsEnergyArmor();
    }
    override void initAndapplyEffectToRArmor(RwArmor arm, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(max(5, quality/10), 50, 0.1);
        arm.stats.delayUntilRecharge = math.getIntPercentage(arm.stats.delayUntilRecharge, 100 + modifierLevel);
    }
    override bool TryUnapplyingSelfFrom(Inventory item) {
        RwArmor(item).stats.delayUntilRecharge = math.getWholeByPartPercentage(RwArmor(item).stats.delayUntilRecharge, 100 + modifierLevel);
        return true;
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
    override bool IsCompatibleWithRArmor(RwArmor arm) {
        return arm.stats.IsEnergyArmor();
    }
    override void initAndapplyEffectToRArmor(RwArmor arm, int quality) {
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
    override bool IsCompatibleWithRArmor(RwArmor arm) {
        return arm.stats.IsEnergyArmor();
    }
    override void initAndapplyEffectToRArmor(RwArmor arm, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(max(5, quality/10), 50, 0.1);
        arm.stats.energyRestoreSpeedX1000 = math.getIntPercentage(arm.stats.energyRestoreSpeedX1000, 100-modifierLevel);
    }
    override bool TryUnapplyingSelfFrom(Inventory item) {
        RwArmor(item).stats.energyRestoreSpeedX1000 = math.getWholeByPartPercentage(RwArmor(item).stats.energyRestoreSpeedX1000, 100-modifierLevel);
        return true;
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
    override bool IsCompatibleWithRArmor(RwArmor arm) {
        return arm.stats.IsEnergyArmor();
    }
    override void initAndapplyEffectToRArmor(RwArmor arm, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(5, 250, 0.05) + remapQualityToRange(quality, 0, 50);
        arm.stats.energyRestoreSpeedX1000 = math.getIntPercentage(arm.stats.energyRestoreSpeedX1000, 100+modifierLevel);
    }
}
