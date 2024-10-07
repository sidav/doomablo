class RwArmorSuffix : Affix {
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
        return RandomizedArmor(item) != null;
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

class ASuffHealing : RwArmorSuffix {
    override string getName() {
        return "UAC Auto-Med";
    }
    override string getDescription() {
        return "Each "
            ..
            String.Format("%.1f", (Gametime.TicksToSeconds(modifierLevel)))
            ..
            " seconds tranfers 1 durability to your health";
    }
    override void initAndapplyEffectToRArmor(RandomizedArmor arm, int quality) {
        let secondsx10 = 100 - remapQualityToRange(quality, 5, 100);
        modifierLevel = gametime.secondsToTicks(float(secondsx10)/10);
    }
}
