class RwWeaponSuffix : Affix {
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
        return !(a2 is 'RwWeaponSuffix'); // There may be only one suffix on an item
    }
    override bool IsCompatibleWithItem(Inventory item) {
        return (RandomizedWeapon(item) != null) && IsCompatibleWithRWeapon(RandomizedWeapon(item));
    }
    // Override this, and not IsCompatibleWithItem() in descendants. Stop excessive super() calls!
    private virtual bool IsCompatibleWithRWeapon(RandomizedWeapon wpn) {
        return true;
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
            maxPercentage = 15;
        } else if (wpn.stats.clipSize > 5) {
            maxPercentage = 40;
        }
        // debug.print("maxPerc is "..maxPercentage);
        modifierLevel = remapQualityToRange(quality, 1, maxPercentage);
    }
}

class WSuffPoison : RwWeaponSuffix {
    override string getName() {
        return "Venom";
    }
    override string getDescription() {
        return modifierLevel.."% chance to poison the target on hit";
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
        let maxPercentage = 50;
        if (wpn.stats.Pellets > 1) {
            maxPercentage = 20;
        } else if (wpn.stats.clipSize > 5) {
            maxPercentage = 33;
        }
        // debug.print("maxPerc is "..maxPercentage);
        modifierLevel = remapQualityToRange(quality, 1, maxPercentage);
    }
}

class WSuffPain : RwWeaponSuffix {
    override string getName() {
        return "Torment";
    }
    override string getDescription() {
        return modifierLevel.."% chance to inflict pain on target";
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
        let maxPercentage = 50;
        if (wpn.stats.Pellets > 1) {
            maxPercentage = 15;
        } else if (wpn.stats.clipSize > 5) {
            maxPercentage = 25;
        }
        // debug.print("maxPerc is "..maxPercentage);
        modifierLevel = remapQualityToRange(quality, 1, maxPercentage);
    }
}

class WSuffAmmoDrops : RwWeaponSuffix {
    override string getName() {
        return "Abundance";
    }
    override string getDescription() {
        return modifierLevel.."% chance for killed enemy to drop additional ammo";
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
        modifierLevel = remapQualityToRange(quality, 15, 100);
    }
}

// Hitscan only
class WSuffMinirockets : RwWeaponSuffix {
    override string getName() {
        return "Minimissiles";
    }
    override string getDescription() {
        return "Fires exploding mini-rockets. Damage x"..(modifierLevel/10).."."..(modifierLevel%10);
    }
    override bool IsCompatibleWithRWeapon(RandomizedWeapon wpn) {
        return wpn.stats.firesProjectiles == false;
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
        modifierLevel = remapQualityToRange(quality, 5, 20);
        wpn.stats.firesProjectiles = true;
        wpn.stats.projClass = 'RwMiniRocket';
        wpn.stats.BaseExplosionRadius = 64;
        wpn.stats.ExplosionRadius = 16;
        wpn.stats.minDamage = math.divideIntWithRounding(wpn.stats.minDamage * modifierLevel, 10);
        wpn.stats.maxDamage = math.divideIntWithRounding(wpn.stats.maxDamage * modifierLevel, 10);
    }
}

class WSuffFlechettes : RwWeaponSuffix {
    override string getName() {
        return "Flechettes";
    }
    override string getDescription() {
        return "Fires slow homing bullets. Damage x"..(modifierLevel/10).."."..(modifierLevel%10);
    }
    override bool IsCompatibleWithRWeapon(RandomizedWeapon wpn) {
        return wpn.stats.firesProjectiles == false;
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
        modifierLevel = remapQualityToRange(quality, 8, 15);
        wpn.stats.firesProjectiles = true;
        wpn.stats.projClass = 'RwFlechette';
        wpn.stats.minDamage = math.divideIntWithRounding(wpn.stats.minDamage * modifierLevel, 10);
        wpn.stats.maxDamage = math.divideIntWithRounding(wpn.stats.maxDamage * modifierLevel, 10);
    }
}
