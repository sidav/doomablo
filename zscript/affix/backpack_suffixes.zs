class RwBackpackSuffix : Affix {
    override void InitAndApplyEffectToItem(Inventory item, int quality) {
        initAndapplyEffectToRBackpack(RWBackpack(item), quality);
    }
    protected virtual void initAndapplyEffectToRBackpack(RWBackpack bpk, int quality) {
        debug.panicUnimplemented(self);
    }
    override bool IsCompatibleWithItem(Inventory item) {
        return (RWBackpack(item) != null);
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
        return !(a2 is 'RwBackpackSuffix'); // There may be only one suffix on an item
    }
}

class BSuffNoisy : RwBackpackSuffix {
    override string getName() {
        return "Noise";
    }
    override string getDescription() {
        return "Has a "..modifierLevel.."% chance to aggro monsters around you";
    }
    override int getAlignment() {
        return -1;
    }
    override void initAndapplyEffectToRBackpack(RWBackpack bkpk, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, 100); // Chance 1-100
    }
}

class BSuffLessAmmoChance : RwBackpackSuffix {
    override string getName() {
        return "Holes";
    }
    override string getDescription() {
        return "Ammo pickups have "..modifierLevel.."% chance to have less ammo";
    }
    override int getAlignment() {
        return -1;
    }
    override void initAndapplyEffectToRBackpack(RWBackpack bkpk, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, 50);
    }
}

class BSuffRestoreCells : RwBackpackSuffix {
    override string getName() {
        return "RITEG";
    }
    override string getDescription() {
        return "Each "
            ..
            String.Format("%.1f", (Gametime.TicksToSeconds(modifierLevel)))
            .." seconds gives an energy cell";
    }
    override void initAndapplyEffectToRBackpack(RWBackpack bkpk, int quality) {
        let secondsx10 = 100 - remapQualityToRange(quality, 0, 95);
        modifierLevel = gametime.secondsToTicks(float(secondsx10)/10);
    }
}

class BSuffAutoreload : RwBackpackSuffix {
    override string getName() {
        return "Auto-reload";
    }
    override string getDescription() {
        return "Each "
            ..
            String.Format("%.1f", (Gametime.TicksToSeconds(modifierLevel)))
            .." seconds reloads your weapons";
    }
    override void initAndapplyEffectToRBackpack(RWBackpack bkpk, int quality) {
        let seconds = 30 - remapQualityToRange(quality, 0, 25);
        modifierLevel = gametime.secondsToTicks(seconds);
    }
}

class BSuffBetterMedikits : RwBackpackSuffix {
    override string getName() {
        return "Surgeon";
    }
    override string getDescription() {
        return "+"..modifierLevel.." to each non-bonus health pickup";
    }
    override void initAndapplyEffectToRBackpack(RWBackpack bkpk, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, 5);
    }
}

class BSuffMoreAmmoChance : RwBackpackSuffix {
    override string getName() {
        return "Optimization";
    }
    override string getDescription() {
        return "Ammo pickups have "..modifierLevel.."% chance to have more ammo";
    }
    override void initAndapplyEffectToRBackpack(RWBackpack bkpk, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, 50);
    }
}
