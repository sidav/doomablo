class RwArmorSuffix : Affix {
    override bool isSuffix() {
        return true;
    }
    override int getAlignment() {
        return 1; // All suffixes are good (for now)
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
    override void initAndapplyEffectToRArmor(RandomizedArmor arm) {
        let secondsx10 = rnd.linearWeightedRand(5, 50, 1, 100);
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
    override void initAndapplyEffectToRArmor(RandomizedArmor arm) {
        let secondsx10 = rnd.linearWeightedRand(2, 50, 1, 100); 
        modifierLevel = gametime.secondsToTicks(float(secondsx10)/10);
    }
}
