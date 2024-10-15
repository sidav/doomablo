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

class ASuffDegrading : RwArmorSuffix {
    override string getName() {
        return "Lacking the license";
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

class ASuffDurabToHealth : RwArmorSuffix {
    override string getName() {
        return "UAC Auto-Surgeon";
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

class ASuffSlowHeal : RwArmorSuffix {
    override string getName() {
        return "UAC HealTech";
    }
    override string getDescription() {
        return "Each "
            ..
            String.Format("%.1f", (Gametime.TicksToSeconds(modifierLevel)))
            ..
            " sec heals you";
    }
    override void initAndapplyEffectToRArmor(RandomizedArmor arm, int quality) {
        let secondsx10 = 150 - remapQualityToRange(quality, 0, 140);
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
        modifierLevel = remapQualityToRange(quality, 1, 50);
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
        modifierLevel = remapQualityToRange(quality, 1, arm.stats.maxDurability);
        arm.stats.BonusRepair = modifierLevel;
    }
}

class ASuffEDamageOnEmpty : RwArmorSuffix {
    override string getName() {
        return "UAC A-Def";
    }
    override string getDescription() {
        return String.Format("On emptying deals %d dmg to everyone around", modifierLevel);
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
