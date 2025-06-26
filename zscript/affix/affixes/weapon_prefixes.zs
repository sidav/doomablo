class RwWeaponPrefix : Affix abstract {
    override void InitAndApplyEffectToItem(Inventory item, int quality) {
        initAndApplyEffectToRWeapon(RandomizedWeapon(item), quality);
    }
    protected virtual void initAndApplyEffectToRWeapon(RandomizedWeapon weapon, int quality) {
        debug.panicUnimplemented(self);
    }
    override bool IsCompatibleWithItem(Inventory item) {
        return (RandomizedWeapon(item) != null) && IsCompatibleWithRWeapon(RandomizedWeapon(item));
    }
    // Override this, and not IsCompatibleWithItem() in descendants. Stop excessive super.IsCompatibleWithItem() calls!
    private virtual bool IsCompatibleWithRWeapon(RandomizedWeapon wpn) {
        return true;
    }
}

// Universal ones

// class WPrefWorseMinDamage : RwWeaponPrefix {
//     override string getName() {
//         return "weaker";
//     }
//     override string getNameAsSuffix() {
//         return "weakness";
//     }
//     override int getAlignment() {
//         return -1;
//     }
//     override string getDescription() {
//         return "min damage -"..modifierLevel;
//     }
//     override bool isCompatibleWithAffClass(Affix a2) {
//         return a2.GetClass() != 'WPrefBetterMinDamage';
//     }
//     override bool IsCompatibleWithRWeapon(RandomizedWeapon wpn) {
//         return wpn.stats.minDamage > 0;
//     }
//     override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
//         modifierLevel = remapQualityToRange(quality, 1, wpn.stats.minDamage);

//         wpn.stats.modifyDamageRange(-modifierLevel, 0);
//     }
// }

// class WPrefBetterMinDamage : RwWeaponPrefix {
//     override string getName() {
//         return "stronger";
//     }
//     override string getNameAsSuffix() {
//         return "strength";
//     }
//     override int getAlignment() {
//         return 1;
//     }
//     override string getDescription() {
//         return "min damage +"..modifierLevel;
//     }
//     override bool isCompatibleWithAffClass(Affix a2) {
//         return a2.GetClass() != 'WPrefWorseMinDamage';
//     }
//     override bool IsCompatibleWithRWeapon(RandomizedWeapon wpn) {
//         return true;
//     }
//     override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
//         modifierLevel = remapQualityToRange(quality, 1, 1+wpn.stats.minDamage);

//         wpn.stats.increaseMinDamagePushingMax(modifierLevel);
//     }
// }

// class WPrefWorseMaxDamage : RwWeaponPrefix {
//     override string getName() {
//         return "used";
//     }
//     override int getAlignment() {
//         return -1;
//     }
//     override string getDescription() {
//         return "max damage -"..modifierLevel;
//     }
//     override bool isCompatibleWithAffClass(Affix a2) {
//         return a2.GetClass() != 'WPrefBetterMaxDamage';
//     }
//     override bool IsCompatibleWithRWeapon(RandomizedWeapon wpn) {
//         return wpn.stats.getDamageSpread() > 0;
//     }
//     override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
//         modifierLevel = remapQualityToRange(quality, 1, wpn.stats.getDamageSpread());

//         wpn.stats.modifyDamageRange(0, -modifierLevel);
//     }
// }

// class WPrefBetterMaxDamage : RwWeaponPrefix {
//     override string getName() {
//         return "potent";
//     }
//     override string getNameAsSuffix() {
//         return "potential";
//     }
//     override int getAlignment() {
//         return 1;
//     }
//     override string getDescription() {
//         return "max damage +"..modifierLevel;
//     }
//     override bool isCompatibleWithAffClass(Affix a2) {
//         return a2.GetClass() != 'WPrefWorseMaxDamage';
//     }
//     override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
//         modifierLevel = remapQualityToRange(quality, 1, math.getIntPercentage(wpn.stats.maxDamage, 150));

//         wpn.stats.modifyDamageRange(0, modifierLevel);
//     }
// }

class WPrefWorseDamage : RwWeaponPrefix {
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
        return String.format("Total DMG -%.1f%%", (double(modifierLevel) / 10) );
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'WPrefBetterDamage';
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(10, 60, 0.1) + remapQualityToRange(quality, 0, 40);
        wpn.stats.additionalDamagePromille = -modifierLevel;
    }
    override bool TryUnapplyingSelfFrom(Inventory item) {
        RandomizedWeapon(item).stats.additionalDamagePromille += modifierLevel;
        return true;
    }
}

class WPrefBetterDamage : RwWeaponPrefix {
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
        return String.format("Total DMG +%.1f%%", (double(modifierLevel) / 10) );
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'WPrefWorseDamage';
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(50, 200, 0.05) + remapQualityToRange(quality, 0, 50);
        wpn.stats.additionalDamagePromille = modifierLevel;
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
        return String.format("Shot spread +%d%%", (modifierLevel) );
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'WPrefPrecise';
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(5, 75, 0.1) + remapQualityToRange(quality, 1, 25);

        wpn.stats.HorizSpread *= float(100+modifierLevel)/100;
        wpn.stats.VertSpread *= float(100+modifierLevel)/100;
    }
    override bool TryUnapplyingSelfFrom(Inventory item) {
        RandomizedWeapon(item).stats.HorizSpread /= float(100+modifierLevel)/100;
        RandomizedWeapon(item).stats.VertSpread /= float(100+modifierLevel)/100;
        return true;
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
        return String.format("Shot spread -%d%%", (modifierLevel) );
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'WPrefInaccurate';
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(5, 25, 0.1) + remapQualityToRange(quality, 1, 25);

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
        return String.format("Rate of fire -%d%%", (modifierLevel) );
    }
    override bool IsCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'WPrefFast';
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, 15, 0.1) + remapQualityToRange(quality, 1, 15);
        wpn.stats.rofModifier = -modifierLevel;
    }
    override bool TryUnapplyingSelfFrom(Inventory item) {
        RandomizedWeapon(item).stats.rofModifier += modifierLevel;
        return true;
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
        return String.format("Rate of fire +%d%%", (modifierLevel) );
    }
    override bool IsCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'WPrefSlow';
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, 50, 0.1) + remapQualityToRange(quality, 1, 20);
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
        return String.format("%d%% chance for a shot to be free", (modifierLevel) );
    }
    override bool IsCompatibleWithRWeapon(RandomizedWeapon wpn) {
        return wpn.stats.ammoUsage > 0;
    }
    override bool IsCompatibleWithAffClass(Affix a2) {
        return true;
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, 35, 0.05) + remapQualityToRange(quality, 0, 15);
        wpn.stats.freeShotChance = modifierLevel;
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
        return 0;
    }
    override string getDescription() {
        return String.format("x%.1f target knockback", double(modifierLevel)/100.);
    }
    override bool IsCompatibleWithRWeapon(RandomizedWeapon wpn) {
        return wpn.stats.fireType != RWStatsClass.FTMelee && wpn.stats.fireType != RWStatsClass.FTRailgun;
    }
    override bool IsCompatibleWithAffClass(Affix a2) {
        return true;
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
        modifierLevel = 25 * (rnd.multipliedWeightedRandByEndWeight(5, 38, 0.1) + quality/50);

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
        return wpn.stats.fireType != RWStatsClass.FTMelee && wpn.stats.fireType != RWStatsClass.FTRailgun;
    }
    override bool IsCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'WPrefSmallerShooterKickback';
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
        modifierLevel = remapQualityToRange(quality, 25, 200);

        wpn.stats.ShooterKickback *= double(100+modifierLevel)/100;
    }
    override bool TryUnapplyingSelfFrom(Inventory item) {
        RandomizedWeapon(item).stats.ShooterKickback /= double(100 + modifierLevel)/100;
        return true;
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
        return "-"..modifierLevel.."% shooter kickback";
    }
    override bool IsCompatibleWithRWeapon(RandomizedWeapon wpn) {
        return wpn.stats.fireType != RWStatsClass.FTMelee && wpn.stats.fireType != RWStatsClass.FTRailgun;
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
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, 100, 0.1) + remapQualityToRange(quality, 1, 50);
        wpn.stats.Recoil *= double(100+modifierLevel)/100;
    }
    override bool TryUnapplyingSelfFrom(Inventory item) {
        RandomizedWeapon(item).stats.Recoil /= double(100 + modifierLevel)/100;
        return true;
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
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, 50, 0.1) + remapQualityToRange(quality, 1, 45);
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
        return String.format("-%d%% magazine size", (modifierLevel) );
    }
    override bool IsCompatibleWithRWeapon(RandomizedWeapon wpn) {
        return wpn.stats.clipSize > 2;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'WPrefBiggerMag';
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
        let minPerc = math.minimumMeaningIntPercent(wpn.stats.clipSize);
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(minPerc, 50, 0.1);
        // Make the percent value meaningful and consider ammo usage.
        modifierLevel = math.discretizeIntPercentFraction(wpn.stats.clipSize/wpn.stats.ammoUsage, modifierLevel);
        wpn.stats.clipSize = math.getIntPercentage(wpn.stats.clipSize, 100 - modifierLevel);
    }
    override bool TryUnapplyingSelfFrom(Inventory item) {
        RandomizedWeapon(item).stats.clipSize = math.getWholeByPartPercentage(RandomizedWeapon(item).stats.clipSize, 100-modifierLevel);
        return true;
    }
}

class WPrefBiggerMag : RwWeaponPrefix {
    override string getName() {
        return "capacious";
    }
    override string getNameAsSuffix() {
        return "stocks";
    }
    override int getAlignment() {
        return 1;
    }
    override string getDescription() {
        return String.format("+%d%% magazine size", (modifierLevel) );
    }
    override bool IsCompatibleWithRWeapon(RandomizedWeapon wpn) {
        return wpn.stats.clipSize > 0;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'WPrefSmallerMag';
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
        let minPerc = math.minimumMeaningIntPercent(wpn.stats.clipSize);
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(minPerc, 175, 0.01) + quality/2;
        // Make the percent value meaningful and consider ammo usage.
        modifierLevel = math.discretizeIntPercentFraction(wpn.stats.clipSize/wpn.stats.ammoUsage, modifierLevel);

        wpn.stats.clipSize = math.getIntPercentage(wpn.stats.clipSize, 100 + modifierLevel);
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
        return String.format("Reload speed -%d%%", (modifierLevel) );
    }
    override bool IsCompatibleWithRWeapon(RandomizedWeapon wpn) {
        return wpn.stats.clipSize > 0;
    }
    override bool IsCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'WPrefFasterReload';
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, 50, 0.1) + remapQualityToRange(quality, 1, 25);

        wpn.stats.reloadSpeedModifier = -modifierLevel;
    }
    override bool TryUnapplyingSelfFrom(Inventory item) {
        RandomizedWeapon(item).stats.reloadSpeedModifier += modifierLevel;
        return true;
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
        return String.format("Reload speed +%d%%", (modifierLevel) );
    }
    override bool IsCompatibleWithRWeapon(RandomizedWeapon wpn) {
        return wpn.stats.clipSize > 0;
    }
    override bool IsCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'WPrefSlowerReload';
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, 50, 0.1) + remapQualityToRange(quality, 1, 50);
        wpn.stats.reloadSpeedModifier = modifierLevel;
    }
}

// Shotgun-specific

class WPrefLessPellets : RwWeaponPrefix {
    override string getName() {
        return "puny";
    }
    override int getAlignment() {
        return -1;
    }
    override string getDescription() {
        return String.format("-%d%% pellets per shot", (modifierLevel) );
    }
    override bool IsCompatibleWithRWeapon(RandomizedWeapon wpn) {
        return wpn.stats.Pellets > 3;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'WPrefMorePellets' && a2.GetClass() != 'WSuffSlugshotShotgun';
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
        let minPerc = math.minimumMeaningIntPercent(wpn.stats.pellets);
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(minPerc, 50, 0.1);
        modifierLevel = math.discretizeIntPercentFraction(wpn.stats.Pellets, modifierLevel);
        wpn.stats.Pellets = math.getIntPercentage(wpn.stats.pellets, 100 - modifierLevel);
    }
    override bool TryUnapplyingSelfFrom(Inventory item) {
        RandomizedWeapon(item).stats.Pellets = math.getWholeByPartPercentage(RandomizedWeapon(item).stats.pellets, 100-modifierLevel);
        return true;
    }
}

class WPrefMorePellets : RwWeaponPrefix {
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
        return String.format("+%d%% pellets per shot", (modifierLevel) );
    }
    override bool IsCompatibleWithRWeapon(RandomizedWeapon wpn) {
        return wpn.stats.Pellets > 3;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'WPrefLessPellets' && a2.GetClass() != 'WSuffSlugshotShotgun';
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
        let minPerc = math.minimumMeaningIntPercent(wpn.stats.pellets);
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(minPerc, 50, 0.01) + quality/4;
        modifierLevel = math.discretizeIntPercentFraction(wpn.stats.Pellets, modifierLevel);
        wpn.stats.Pellets = math.getIntPercentage(wpn.stats.pellets, 100 + modifierLevel);
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
        return String.format("Projectile speed -%d%%", (modifierLevel) );
    }
    override bool IsCompatibleWithRWeapon(RandomizedWeapon wpn) {
        return wpn.stats.fireType == RWStatsClass.FTProjectile;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'WPrefQuick';
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(5, 50, 0.05) + quality/10;

        wpn.stats.projSpeedPercModifier = -modifierLevel;
    }
    override bool TryUnapplyingSelfFrom(Inventory item) {
        RandomizedWeapon(item).stats.projSpeedPercModifier += modifierLevel;
        return true;
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
        return String.format("Projectile speed +%d%%", (modifierLevel) );
    }
    override bool IsCompatibleWithRWeapon(RandomizedWeapon wpn) {
        return wpn.stats.fireType == RWStatsClass.FTProjectile;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'WPrefLazy';
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(5, 150, 0.05) + quality/2;
        wpn.stats.projSpeedPercModifier = modifierLevel;
    }
}

class WPrefHomingProjectile : RwWeaponPrefix {
    override string getName() {
        return "homing";
    }
    override string getDescription() {
        string levelStr = "(level "..modifierLevel..")";
        switch (modifierLevel) {
            case 1:
                levelStr = "(weak)"; break;
            case 2:
                levelStr = "(medium)"; break;
            case 3:
                levelStr = "(strong)"; break;
        }
        return "Projectiles seek closest target "..levelStr;
    }
    override int getAlignment() {
        return 0; // On purpose
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'WSuffFlechettes';
    }
    override bool IsCompatibleWithRWeapon(RandomizedWeapon wpn) {
        return wpn.stats.fireType == RWStatsClass.FTProjectile;
    }
    override int minRequiredRarity() {
        return 3; // It's quite a rare affix
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, 3, 0.5);
        wpn.stats.levelOfSeekerProjectile = modifierLevel;
    }
}

// Explosion-weapon specific

// TODO: rework this into "% less self damage" affix, the current callbacks allow that
class WPrefNoSelfExplosionDamage : RwWeaponPrefix {
    override string getName() {
        return "safe";
    }
    override string getDescription() {
        return "No self damage from explosion";
    }
    override int getAlignment() {
        return 1;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return true;
    }
    override bool IsCompatibleWithRWeapon(RandomizedWeapon wpn) {
        return wpn.stats.ExplosionRadius > 0;
    }
    override int minRequiredRarity() {
        return 3; // It's quite a rare affix
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
        wpn.stats.noDamageToOwner = true;
    }
}

class WPrefSmallerExplosion : RwWeaponPrefix {
    override string getName() {
        return "fizzling";
    }
    override string getNameAsSuffix() {
        return "fizzle";
    }
    override int getAlignment() {
        return -1;
    }
    override string getDescription() {
        return String.format("Explosion radius -%d%%", (modifierLevel) );
    }
    override bool IsCompatibleWithRWeapon(RandomizedWeapon wpn) {
        return wpn.stats.ExplosionRadius > 0;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'WPrefBiggerExplosion';
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, 50, 0.1) + remapQualityToRange(quality, 1, 25);

        wpn.stats.ExplosionRadius = math.getIntPercentage(
            wpn.stats.ExplosionRadius,
            100-modifierLevel
        );
    }
    override bool TryUnapplyingSelfFrom(Inventory item) {
        RandomizedWeapon(item).stats.ExplosionRadius = math.getWholeByPartPercentage(RandomizedWeapon(item).stats.ExplosionRadius, 100-modifierLevel);
        return true;
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
        return String.format("Explosion radius +%d%%", (modifierLevel) );
    }
    override bool IsCompatibleWithRWeapon(RandomizedWeapon wpn) {
        return wpn.stats.ExplosionRadius > 0;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'WPrefSmallerExplosion';
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, 50, 0.1) + remapQualityToRange(quality, 1, 50);

        wpn.stats.ExplosionRadius = math.getIntPercentage(
            wpn.stats.ExplosionRadius,
            100+modifierLevel
        );
    }
}

// Melee-specific

class WPrefLessMeleeRange : RwWeaponPrefix {
    override string getName() {
        return "short";
    }
    override int getAlignment() {
        return -1;
    }
    override string getDescription() {
        return String.format("attack range -%d%%", (modifierLevel) );
    }
    override bool IsCompatibleWithRWeapon(RandomizedWeapon wpn) {
        return wpn.stats.fireType == RWStatsClass.FTMelee;
    }
    override bool IsCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'WPrefMoreMeleeRange';
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, 25, 0.1) + remapQualityToRange(quality, 1, 25);
        wpn.stats.attackRange = math.getIntPercentage(wpn.stats.attackRange, 100 - modifierLevel);
    }
    override bool TryUnapplyingSelfFrom(Inventory item) {
        RandomizedWeapon(item).stats.attackRange = math.getWholeByPartPercentage(RandomizedWeapon(item).stats.attackRange, 100-modifierLevel);
        return true;
    }
}

class WPrefMoreMeleeRange : RwWeaponPrefix {
    override string getName() {
        return "reaching";
    }
    override string getNameAsSuffix() {
        return "reach";
    }
    override int getAlignment() {
        return 1;
    }
    override string getDescription() {
        return String.format("attack range +%d%%", (modifierLevel) );
    }
    override bool IsCompatibleWithRWeapon(RandomizedWeapon wpn) {
        return wpn.stats.fireType == RWStatsClass.FTMelee;
    }
    override bool IsCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'WPrefLessMeleeRange';
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, 25, 0.1) + remapQualityToRange(quality, 1, 25);
        wpn.stats.attackRange = math.getIntPercentage(wpn.stats.attackRange, 100 + modifierLevel);
    }
}