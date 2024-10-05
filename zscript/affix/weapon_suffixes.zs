class RwWeaponSuffix : Affix {
    override bool isSuffix() {
        return true;
    }
    override int getAlignment() {
        return 1;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return !(a2 is 'RwWeaponSuffix'); // There may be only one suffix on an item
    }
    override bool IsCompatibleWithItem(Inventory item) {
        return RandomizedWeapon(item) != null;
    }
}

// Universal ones

class WSuffVampiric : RwWeaponSuffix {
    override string getName() {
        return "Vampirism";
    }
    override string getDescription() {
        return modifierLevel.."% chance to regain health on hit";
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
        let maxPercentage = 50;
        if (wpn.stats.Pellets > 1) {
            maxPercentage = maxPercentage / (1 + wpn.stats.Pellets/2);
        } else if (wpn.stats.clipSize > 5) {
            maxPercentage = maxPercentage / (1 + wpn.stats.clipSize / 5);
        }
        if (maxPercentage == 0) {
            maxPercentage = 3;
        }
        // debug.print("maxPerc is "..maxPercentage);
        modifierLevel = remapQualityToRange(quality, 1, maxPercentage);
    }
}
