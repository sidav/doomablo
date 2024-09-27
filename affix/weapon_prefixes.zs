class RwWeaponPrefix : Affix {
    override bool IsCompatibleWithItem(Inventory item) {
        return RandomizedWeapon(item) != null;
    }
}

// Universal ones

class WPrefWorseMinDamage : RwWeaponPrefix {
    override string getName() {
        return "weaker";
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
    override bool IsCompatibleWithItem(Inventory item) {
        return super.IsCompatibleWithItem(item) && RandomizedWeapon(item).stats.minDamage > 0;
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn) {
        modifierLevel = rnd.linearWeightedRand(1, wpn.stats.minDamage, 10, 1);

        wpn.stats.modifyDamageRange(-modifierLevel, 0);
    }
}

class WPrefBetterMinDamage : RwWeaponPrefix {
    override string getName() {
        return "stronger";
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
    override bool IsCompatibleWithItem(Inventory item) {
        return super.IsCompatibleWithItem(item) && 
            RandomizedWeapon(item).stats.getDamageSpread() > 0;
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn) {
        modifierLevel = rnd.linearWeightedRand(1, wpn.stats.getDamageSpread(), 100, 1);

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
    override bool IsCompatibleWithItem(Inventory item) {
        return super.IsCompatibleWithItem(item) && 
            RandomizedWeapon(item).stats.getDamageSpread() > 0;
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn) {
        modifierLevel = rnd.linearWeightedRand(1, wpn.stats.getDamageSpread(), 100, 1);

        wpn.stats.modifyDamageRange(0, -modifierLevel);
    }
}

class WPrefBetterMaxDamage : RwWeaponPrefix {
    override string getName() {
        return "potent";
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
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn) {
        modifierLevel = rnd.linearWeightedRand(1, 10, 100, 1);

        wpn.stats.modifyDamageRange(0, modifierLevel);
    }
}

class WPrefInaccurate : RwWeaponPrefix {
    override string getName() {
        return "inaccurate";
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
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn) {
        modifierLevel = 5*rnd.linearWeightedRand(1, 20, 100, 1);

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
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn) {
        modifierLevel = 5*rnd.linearWeightedRand(1, 15, 100, 1);

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
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn) {
        modifierLevel = 5*rnd.linearWeightedRand(1, 15, 100, 1);

        wpn.stats.rofModifier = -modifierLevel;
    }
}

class WPrefFast : RwWeaponPrefix {
    override string getName() {
        return "fast";
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
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn) {
        modifierLevel = 5*rnd.linearWeightedRand(1, 10, 100, 1);

        wpn.stats.rofModifier = modifierLevel;
    }
}

class WPrefFreeShots : RwWeaponPrefix {
    override string getName() {
        return "replicating";
    }
    override int getAlignment() {
        return 1;
    }
    override string getDescription() {
        return "Each "..modifierLevel.."th shot is free";
    }
    override bool IsCompatibleWithAffClass(Affix a2) {
        return true; // TODO: think of a "bad" counterpart
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn) {
        modifierLevel = rnd.linearWeightedRand(1, 10, 1, 200);

        wpn.stats.freeShotPeriod = modifierLevel;
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
    override bool IsCompatibleWithItem(Inventory item) {
        return super.IsCompatibleWithItem(item) && RandomizedWeapon(item).stats.Pellets > 3;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'WPrefBulk';
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn) {
        modifierLevel = rnd.linearWeightedRand(1, wpn.stats.pellets, 20, 1);

        wpn.stats.Pellets -= modifierLevel;
    }
}

class WPrefBulk : RwWeaponPrefix {
    override string getName() {
        return "bulk";
    }
    override int getAlignment() {
        return 1;
    }
    override string getDescription() {
        return "+"..modifierLevel.." pellets per shot";
    }
    override bool IsCompatibleWithItem(Inventory item) {
        return super.IsCompatibleWithItem(item) && RandomizedWeapon(item).stats.Pellets > 3;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'WPrefPuny';
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn) {
        modifierLevel = rnd.linearWeightedRand(1, (wpn.stats.Pellets/2 + 1), 100, 1);

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
    override bool IsCompatibleWithItem(Inventory item) {
        return super.IsCompatibleWithItem(item) && RandomizedWeapon(item).stats.firesProjectiles;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'WPrefQuick';
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn) {
        modifierLevel = rnd.linearWeightedRand(1, 75, 100, 1);

        wpn.stats.projSpeedPercModifier = -modifierLevel;
    }
}

class WPrefQuick : RwWeaponPrefix {
    override string getName() {
        return "quick";
    }
    override int getAlignment() {
        return 1;
    }
    override string getDescription() {
        return modifierLevel.."% faster projectile";
    }
    override bool IsCompatibleWithItem(Inventory item) {
        return super.IsCompatibleWithItem(item) && RandomizedWeapon(item).stats.firesProjectiles;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'WPrefLazy';
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn) {
        modifierLevel = rnd.linearWeightedRand(1, 100, 100, 1);

        wpn.stats.projSpeedPercModifier = modifierLevel;
    }
}

// Explosion-weapon specific

class WPrefSmallerExplosion : RwWeaponPrefix {
    override string getName() {
        return "safer";
    }
    override int getAlignment() {
        return -1;
    }
    override string getDescription() {
        return modifierLevel.."% smaller explosion radius";
    }
    override bool IsCompatibleWithItem(Inventory item) {
        return super.IsCompatibleWithItem(item) && RandomizedWeapon(item).stats.ExplosionRadius > 0;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'WPrefBiggerExplosion';
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn) {
        modifierLevel = rnd.linearWeightedRand(10, 75, 100, 1);

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
    override int getAlignment() {
        return 1;
    }
    override string getDescription() {
        return modifierLevel.."% bigger explosion radius";
    }
    override bool IsCompatibleWithItem(Inventory item) {
        return  super.IsCompatibleWithItem(item) && RandomizedWeapon(item).stats.ExplosionRadius > 0;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'WPrefSmallerExplosion';
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn) {
        modifierLevel = rnd.linearWeightedRand(20, 200, 1000, 1);

        wpn.stats.ExplosionRadius = math.getIntPercentage(
            wpn.stats.ExplosionRadius,
            100+modifierLevel
        );
    }
}
