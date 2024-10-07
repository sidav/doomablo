class RwWeaponPrefix : Affix {
    override bool IsCompatibleWithItem(Inventory item) {
        return (RandomizedWeapon(item) != null) && IsCompatibleWithRWeapon(RandomizedWeapon(item));
    }
    // Override this, and not IsCompatibleWithItem() in descendants. Stop excessive super.IsCompatibleWithItem() calls!
    private virtual bool IsCompatibleWithRWeapon(RandomizedWeapon wpn) {
        return true;
    }
}

// Universal ones

class WPrefWorseMinDamage : RwWeaponPrefix {
    override string getName() {
        return "weaker";
    }
    override string getNameAsSuffix() {
        return "weakness";
    }
    override int getAlignment() {
        return -1;
    }
    override string getDescription() {
        return "min damage -"..modifierLevel;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'WPrefBetterMinDamage';
    }
    override bool IsCompatibleWithRWeapon(RandomizedWeapon wpn) {
        return wpn.stats.minDamage > 0;
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, wpn.stats.minDamage);

        wpn.stats.modifyDamageRange(-modifierLevel, 0);
    }
}

class WPrefBetterMinDamage : RwWeaponPrefix {
    override string getName() {
        return "stronger";
    }
    override string getNameAsSuffix() {
        return "strength";
    }
    override int getAlignment() {
        return 1;
    }
    override string getDescription() {
        return "min damage +"..modifierLevel;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'WPrefWorseMinDamage';
    }
    override bool IsCompatibleWithRWeapon(RandomizedWeapon wpn) {
        return wpn.stats.getDamageSpread() > 0;
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, wpn.stats.getDamageSpread());

        wpn.stats.modifyDamageRange(modifierLevel, 0);
    }
}

class WPrefWorseMaxDamage : RwWeaponPrefix {
    override string getName() {
        return "used";
    }
    override int getAlignment() {
        return -1;
    }
    override string getDescription() {
        return "max damage -"..modifierLevel;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'WPrefBetterMaxDamage';
    }
    override bool IsCompatibleWithRWeapon(RandomizedWeapon wpn) {
        return wpn.stats.getDamageSpread() > 0;
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, wpn.stats.getDamageSpread());

        wpn.stats.modifyDamageRange(0, -modifierLevel);
    }
}

class WPrefBetterMaxDamage : RwWeaponPrefix {
    override string getName() {
        return "potent";
    }
    override string getNameAsSuffix() {
        return "potential";
    }
    override int getAlignment() {
        return 1;
    }
    override string getDescription() {
        return "max damage +"..modifierLevel;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'WPrefWorseMaxDamage';
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, wpn.stats.maxDamage);

        wpn.stats.modifyDamageRange(0, modifierLevel);
    }
}

class WPrefInaccurate : RwWeaponPrefix {
    override string getName() {
        return "inaccurate";
    }
    override string getNameAsSuffix() {
        return "misses";
    }
    override int getAlignment() {
        return -1;
    }
    override string getDescription() {
        return "accuracy decreased by "..modifierLevel.."%";
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'WPrefPrecise';
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, 200);

        wpn.stats.HorizSpread *= float(100+modifierLevel)/100;
        wpn.stats.VertSpread *= float(100+modifierLevel)/100;
    }
}

class WPrefPrecise : RwWeaponPrefix {
    override string getName() {
        return "precise";
    }
    override int getAlignment() {
        return 1;
    }
    override string getDescription() {
        return "accuracy increased by "..modifierLevel.."%";
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'WPrefInaccurate';
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, 50);

        wpn.stats.HorizSpread *= float(100-modifierLevel)/100;
        wpn.stats.VertSpread *= float(100-modifierLevel)/100;
    }
}


class WPrefSlow : RwWeaponPrefix {
    override string getName() {
        return "slow";
    }
    override int getAlignment() {
        return -1;
    }
    override string getDescription() {
        return modifierLevel.."% slower rate of fire";
    }
    override bool IsCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'WPrefFast';
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, 75);

        wpn.stats.rofModifier = -modifierLevel;
    }
}

class WPrefFast : RwWeaponPrefix {
    override string getName() {
        return "fast";
    }
    override string getNameAsSuffix() {
        return "barraging";
    }
    override int getAlignment() {
        return 1;
    }
    override string getDescription() {
        return modifierLevel.."% faster rate of fire";
    }
    override bool IsCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'WPrefSlow';
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, 100);

        wpn.stats.rofModifier = modifierLevel;
    }
}

class WPrefFreeShots : RwWeaponPrefix {
    override string getName() {
        return "replicating";
    }
    override string getNameAsSuffix() {
        return "replication";
    }
    override int getAlignment() {
        return 1;
    }
    override string getDescription() {
        return "Each "..modifierLevel.."th shot is free";
    }
    override bool IsCompatibleWithAffClass(Affix a2) {
        return true;
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
        modifierLevel = 12 - remapQualityToRange(quality, 1, 10);

        wpn.stats.freeShotPeriod = modifierLevel;
    }
}

class WPrefTargetKnockback : RwWeaponPrefix { // There is no bad counterpart, I don't think it's needed
    override string getName() {
        return "repulsive";
    }
    override string getNameAsSuffix() {
        return "repulsion";
    }
    override int getAlignment() {
        return 1;
    }
    override string getDescription() {
        return modifierLevel.."% target knockback";
    }
    override bool IsCompatibleWithAffClass(Affix a2) {
        return true;
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
        modifierLevel = remapQualityToRange(quality, 150, 1000);

        wpn.stats.TargetKnockback = math.getIntPercentage(wpn.stats.TargetKnockback, modifierLevel);
    }
}

class WPrefBiggerShooterKickback : RwWeaponPrefix {
    override string getName() {
        return "kicking";
    }
    override string getNameAsSuffix() {
        return "kickback";
    }
    override int getAlignment() {
        return -1;
    }
    override string getDescription() {
        return "+"..modifierLevel.."% shooter kickback";
    }
    override bool IsCompatibleWithRWeapon(RandomizedWeapon wpn) {
        return wpn.stats.ShooterKickback > 0;
    }
    override bool IsCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'WPrefSmallerShooterKickback';
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
        modifierLevel = remapQualityToRange(quality, 25, 200);

        wpn.stats.ShooterKickback *= double(100+modifierLevel)/100;
    }
}

class WPrefSmallerShooterKickback : RwWeaponPrefix {
    override string getName() {
        return "balanced";
    }
    override string getNameAsSuffix() {
        return "balance";
    }
    override int getAlignment() {
        return 1;
    }
    override string getDescription() {
        return "-"..modifierLevel.."% kickback";
    }
    override bool IsCompatibleWithRWeapon(RandomizedWeapon wpn) {
        return wpn.stats.ShooterKickback > 0;
    }
    override bool IsCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'WPrefBiggerShooterKickback';
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, 95);

        wpn.stats.ShooterKickback *= double(100-modifierLevel)/100;
    }
}

class WPrefBiggerRecoil : RwWeaponPrefix {
    override string getName() {
        return "unstable";
    }
    override string getNameAsSuffix() {
        return "instability";
    }
    override int getAlignment() {
        return -1;
    }
    override string getDescription() {
        return "+"..modifierLevel.."% recoil";
    }
    override bool IsCompatibleWithRWeapon(RandomizedWeapon wpn) {
        return wpn.stats.recoil > 0;
    }
    override bool IsCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'WPrefSmallerRecoil';
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
        modifierLevel = remapQualityToRange(quality, 25, 200);

        wpn.stats.Recoil *= double(100+modifierLevel)/100;
    }
}

class WPrefSmallerRecoil : RwWeaponPrefix {
    override string getName() {
        return "stable";
    }
    override string getNameAsSuffix() {
        return "stability";
    }
    override int getAlignment() {
        return 1;
    }
    override string getDescription() {
        return "-"..modifierLevel.."% recoil";
    }
    override bool IsCompatibleWithRWeapon(RandomizedWeapon wpn) {
        return wpn.stats.recoil > 0;
    }
    override bool IsCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'WPrefBiggerRecoil';
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, 95);

        wpn.stats.recoil *= double(100-modifierLevel)/100;
    }
}

// Magazine-related

class WPrefSmallerMag : RwWeaponPrefix {
    override string getName() {
        return "scarce";
    }
    override string getNameAsSuffix() {
        return "scarcity";
    }
    override int getAlignment() {
        return -1;
    }
    override string getDescription() {
        return "-"..modifierLevel.." magazine size";
    }
    override bool IsCompatibleWithRWeapon(RandomizedWeapon wpn) {
        return wpn.stats.clipSize > 1;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'WPrefBiggerMag';
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, wpn.stats.clipSize-1);

        wpn.stats.clipSize -= modifierLevel;
    }
}

class WPrefBiggerMag : RwWeaponPrefix {
    override string getName() {
        return "capacious";
    }
    override string getNameAsSuffix() {
        return "abundance";
    }
    override int getAlignment() {
        return 1;
    }
    override string getDescription() {
        return "+"..modifierLevel.." magazine size";
    }
    override bool IsCompatibleWithRWeapon(RandomizedWeapon wpn) {
        return wpn.stats.clipSize > 0;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'WPrefSmallerMag';
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, 3*wpn.stats.clipSize/2);

        wpn.stats.clipSize += modifierLevel;
    }
}

class WPrefSlowerReload : RwWeaponPrefix {
    override string getName() {
        return "loosy";
    }
    override int getAlignment() {
        return -1;
    }
    override string getDescription() {
        return modifierLevel.."% slower reload";
    }
    override bool IsCompatibleWithRWeapon(RandomizedWeapon wpn) {
        return wpn.stats.clipSize > 0;
    }
    override bool IsCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'WPrefFasterReload';
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, 75);

        wpn.stats.reloadSpeedModifier = -modifierLevel;
    }
}

class WPrefFasterReload : RwWeaponPrefix {
    override string getName() {
        return "comfy";
    }
    override string getNameAsSuffix() {
        return "comfort";
    }
    override int getAlignment() {
        return 1;
    }
    override string getDescription() {
        return modifierLevel.."% faster reload";
    }
    override bool IsCompatibleWithRWeapon(RandomizedWeapon wpn) {
        return wpn.stats.clipSize > 0;
    }
    override bool IsCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'WPrefSlowerReload';
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, 100);

        wpn.stats.reloadSpeedModifier = modifierLevel;
    }
}

// Shotgun-specific

class WPrefPuny : RwWeaponPrefix {
    override string getName() {
        return "puny";
    }
    override int getAlignment() {
        return -1;
    }
    override string getDescription() {
        return "-"..modifierLevel.." pellets per shot";
    }
    override bool IsCompatibleWithRWeapon(RandomizedWeapon wpn) {
        return wpn.stats.Pellets > 3;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'WPrefBulk';
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, wpn.stats.pellets/2);

        wpn.stats.Pellets -= modifierLevel;
    }
}

class WPrefBulk : RwWeaponPrefix {
    override string getName() {
        return "bulk";
    }
    override string getNameAsSuffix() {
        return "overload";
    }
    override int getAlignment() {
        return 1;
    }
    override string getDescription() {
        return "+"..modifierLevel.." pellets per shot";
    }
    override bool IsCompatibleWithRWeapon(RandomizedWeapon wpn) {
        return wpn.stats.Pellets > 3;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'WPrefPuny';
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, 3*wpn.stats.Pellets/2);

        wpn.stats.Pellets += modifierLevel;
    }
}

// Projectile-weapon specific

class WPrefLazy : RwWeaponPrefix {
    override string getName() {
        return "lazy";
    }
    override int getAlignment() {
        return -1;
    }
    override string getDescription() {
        return modifierLevel.."% slower projectile";
    }
    override bool IsCompatibleWithRWeapon(RandomizedWeapon wpn) {
        return wpn.stats.firesProjectiles;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'WPrefQuick';
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, 75);

        wpn.stats.projSpeedPercModifier = -modifierLevel;
    }
}

class WPrefQuick : RwWeaponPrefix {
    override string getName() {
        return "quick";
    }
    override string getNameAsSuffix() {
        return "delivery";
    }
    override int getAlignment() {
        return 1;
    }
    override string getDescription() {
        return modifierLevel.."% faster projectile";
    }
    override bool IsCompatibleWithRWeapon(RandomizedWeapon wpn) {
        return wpn.stats.firesProjectiles;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'WPrefLazy';
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, 200);

        wpn.stats.projSpeedPercModifier = modifierLevel;
    }
}

// Explosion-weapon specific

class WPrefSmallerExplosion : RwWeaponPrefix {
    override string getName() {
        return "safer";
    }
    override string getNameAsSuffix() {
        return "safety";
    }
    override int getAlignment() {
        return -1;
    }
    override string getDescription() {
        return modifierLevel.."% smaller explosion radius";
    }
    override bool IsCompatibleWithRWeapon(RandomizedWeapon wpn) {
        return wpn.stats.ExplosionRadius > 0;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'WPrefBiggerExplosion';
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
        modifierLevel = remapQualityToRange(quality, 10, 75);

        wpn.stats.ExplosionRadius = math.getIntPercentage(
            wpn.stats.ExplosionRadius,
            100-modifierLevel
        );
    }
}

class WPrefBiggerExplosion : RwWeaponPrefix {
    override string getName() {
        return "volatile";
    }
    override string getNameAsSuffix() {
        return "danger";
    }
    override int getAlignment() {
        return 1;
    }
    override string getDescription() {
        return modifierLevel.."% bigger explosion radius";
    }
    override bool IsCompatibleWithRWeapon(RandomizedWeapon wpn) {
        return wpn.stats.ExplosionRadius > 0;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'WPrefSmallerExplosion';
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
        modifierLevel = remapQualityToRange(quality, 5, 100);

        wpn.stats.ExplosionRadius = math.getIntPercentage(
            wpn.stats.ExplosionRadius,
            100+modifierLevel
        );
    }
}
