class RwArmorSuffix : Affix {
    override void InitAndApplyEffectToItem(Inventory item, int quality) {
        initAndapplyEffectToRArmor(RandomizedArmor(item), quality);
    }
    protected virtual void initAndapplyEffectToRArmor(RandomizedArmor armor, int quality) {
        debug.panicUnimplemented(self);
    }
    override bool isSuffix() {
        return true;
    }
    override int getAlignment() {
        return 1;
    }
    override int minRequiredRarity() {
        return 3; // Most suffixes require at least "rare"
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return !(a2 is 'RwArmorSuffix'); // There may be only one suffix on an item
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

class ASuffDegrading : RwArmorSuffix {
    override string getName() {
        return "No license";
    }
    override int getAlignment() {
        return -1;
    }
    override int minRequiredRarity() {
        return 2;
    }
    override string getDescription() {
        return "Loses durability each "
            ..
            String.Format("%.1f", (Gametime.TicksToSeconds(modifierLevel)))
            .." seconds";
    }
    override void initAndapplyEffectToRArmor(RandomizedArmor arm, int quality) {
        let secondsx10 = 150 - remapQualityToRange(quality, 50, 100);
        modifierLevel = gametime.secondsToTicks(float(secondsx10)/10);
    }
}

class ASuffSlowHeal : RwArmorSuffix {
    override string getName() {
        return "UAC RegenTech";
    }
    override string getDescription() {
        return "Each "
            ..
            String.Format("%.1f", (Gametime.TicksToSeconds(modifierLevel)))
            ..
            " sec heals you for free";
    }
    override void initAndapplyEffectToRArmor(RandomizedArmor arm, int quality) {
        let secondsx10 = 150 - remapQualityToRange(quality, 0, 140);
        modifierLevel = gametime.secondsToTicks(float(secondsx10)/10);
    }
}

// Non-energy only

class ASuffAbsImprove : RwArmorSuffix {
    override string getName() {
        return "AdapTek";
    }
    override string getDescription() {
        return "Gain +1% ABS (max "..modifierLevel..") for each "..RandomizedArmor.RepairForAbsUpgrade.." repaired";
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return !(a2 is 'RwArmorSuffix' || a2 is 'APrefHard');
    }
    override bool IsCompatibleWithRArmor(RandomizedArmor arm) {
        return !(arm.stats.IsEnergyArmor());
    }
    override void initAndapplyEffectToRArmor(RandomizedArmor arm, int quality) {
        modifierLevel = remapQualityToRange(quality, 5*arm.stats.AbsorbsPercentage/4, min(5*arm.stats.AbsorbsPercentage/2, 100));
    }
}

class ASuffDrbImprove : RwArmorSuffix {
    override string getName() {
        return "Rebuild";
    }
    override string getDescription() {
        return "Gain +1 DRB (max "..modifierLevel..") for each "..RandomizedArmor.RepairForDrbUpgrade.." repaired";
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return !(a2 is 'RwArmorSuffix' || a2 is 'APrefSturdy');
    }
    override bool IsCompatibleWithRArmor(RandomizedArmor arm) {
        return !(arm.stats.IsEnergyArmor());
    }
    override void initAndapplyEffectToRArmor(RandomizedArmor arm, int quality) {
        modifierLevel = remapQualityToRange(quality, 3*arm.stats.maxDurability/2, 2*arm.stats.maxDurability);
    }
}

class ASuffDurabToHealth : RwArmorSuffix {
    override string getName() {
        return "UAC MediTech";
    }
    override string getDescription() {
        return "Each "
            ..
            String.Format("%.1f", (Gametime.TicksToSeconds(modifierLevel)))
            ..
            " sec spends 1 durability to heal you";
    }
    override bool IsCompatibleWithRArmor(RandomizedArmor arm) {
        return !(arm.stats.IsEnergyArmor());
    }
    override void initAndapplyEffectToRArmor(RandomizedArmor arm, int quality) {
        let secondsx10 = 80 - remapQualityToRange(quality, 0, 75);
        modifierLevel = gametime.secondsToTicks(float(secondsx10)/10);
    }
}

class ASuffSelfrepair : RwArmorSuffix {
    override string getName() {
        return "UAC Nanotech";
    }
    override string getDescription() {
        return "Repairs itself each "
            ..
            String.Format("%.1f", (Gametime.TicksToSeconds(modifierLevel)))
            .." seconds";
    }
    override bool IsCompatibleWithRArmor(RandomizedArmor arm) {
        return !(arm.stats.IsEnergyArmor());
    }
    override void initAndapplyEffectToRArmor(RandomizedArmor arm, int quality) {
        let secondsx10 = 100 - remapQualityToRange(quality, 5, 100);
        modifierLevel = gametime.secondsToTicks(float(secondsx10)/10);
    }
}

// Energy-only

class ASuffECellsSpend : RwArmorSuffix {
    override string getName() {
        return "external power";
    }
    override string getDescription() {
        return "When empty, spends "..modifierLevel.." cells to start recharging";
    }
    override int getAlignment() {
        return -1;
    }
    override bool IsCompatibleWithRArmor(RandomizedArmor arm) {
        return arm.stats.IsEnergyArmor();
    }
    override void initAndapplyEffectToRArmor(RandomizedArmor arm, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, 40);
    }
}

class ASuffEBonusRepair : RwArmorSuffix {
    override string getName() {
        return "Recycling";
    }
    override string getDescription() {
        return String.Format("Can be recharged by armor bonuses (+%d)", modifierLevel);
    }
    override int getAlignment() {
        return 1;
    }
    override bool IsCompatibleWithRArmor(RandomizedArmor arm) {
        return arm.stats.IsEnergyArmor();
    }
    override void initAndapplyEffectToRArmor(RandomizedArmor arm, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, arm.stats.maxDurability/2);
        arm.stats.BonusRepair = modifierLevel;
    }
}

class ASuffEDamageOnEmpty : RwArmorSuffix {
    override string getName() {
        return "UAC A-Def";
    }
    override string getDescription() {
        return String.Format("On emptying deals %d dmg to everyone nearby", modifierLevel);
    }
    override int getAlignment() {
        return 1;
    }
    override bool IsCompatibleWithRArmor(RandomizedArmor arm) {
        return arm.stats.IsEnergyArmor();
    }
    override void initAndapplyEffectToRArmor(RandomizedArmor arm, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, 10);
    }
}
