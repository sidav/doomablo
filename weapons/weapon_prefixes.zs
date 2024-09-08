class RwWeaponPrefix : Affix {
    override bool IsCompatibleWithItem(Inventory item) {
        return RandomizedWeapon(item) != null;
    }
}

// Universal ones

class PrefWeak : RwWeaponPrefix {
    override string getName() {
        return "weak";
    }
    override string getDescription() {
        return "damage "..modifierLevel;
    }
    override void Init() {
        modifierLevel = rnd.Rand(-3, -1);
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'PrefStrong';
    }
    override void applyEffectToRw(RandomizedWeapon wpn) {
        wpn.stats.DamageDice.Mod -= modifierLevel;
    }
}

class PrefStrong : RwWeaponPrefix {
    override string getName() {
        return "strong";
    }
    override string getDescription() {
        return "damage +"..modifierLevel;
    }
    override void Init() {
        modifierLevel = rnd.linearWeightedRand(1, 10, 100, 1);
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'PrefWeak';
    }
    override void applyEffectToRw(RandomizedWeapon wpn) {
        wpn.stats.DamageDice.Mod += modifierLevel;
    }
}

class PrefInaccurate : RwWeaponPrefix {
    override string getName() {
        return "inaccurate";
    }
    override string getDescription() {
        return "accuracy decreased by "..modifierLevel.."%";
    }
    override void Init() {
        modifierLevel = 5*rnd.linearWeightedRand(1, 20, 100, 1);
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'PrefPrecise';
    }
    override void applyEffectToRw(RandomizedWeapon wpn) {
        wpn.stats.HorizSpread *= float(100+modifierLevel)/100;
        wpn.stats.VertSpread *= float(100+modifierLevel)/100;
    }
}

class PrefPrecise : RwWeaponPrefix {
    override string getName() {
        return "precise";
    }
    override string getDescription() {
        return "accuracy increased by "..modifierLevel.."%";
    }
    override void Init() {
        modifierLevel = 5*rnd.linearWeightedRand(1, 15, 100, 1);
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'PrefInaccurate';
    }
    override void applyEffectToRw(RandomizedWeapon wpn) {
        wpn.stats.HorizSpread *= float(100-modifierLevel)/100;
        wpn.stats.VertSpread *= float(100-modifierLevel)/100;
    }
}


class PrefSlow : RwWeaponPrefix {
    override string getName() {
        return "slow";
    }
    override string getDescription() {
        return modifierLevel.."% slower rate of fire";
    }
    override void Init() {
        modifierLevel = 5*rnd.linearWeightedRand(1, 15, 100, 1);
    }
    override bool IsCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'PrefFast';
    }
    override void applyEffectToRw(RandomizedWeapon wpn) {
        wpn.stats.rofModifier = -modifierLevel;
    }
}

class PrefFast : RwWeaponPrefix {
    override string getName() {
        return "fast";
    }
    override string getDescription() {
        return modifierLevel.."% faster rate of fire";
    }
    override void Init() {
        modifierLevel = 5*rnd.linearWeightedRand(1, 10, 100, 1);
    }
    override bool IsCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'PrefSlow';
    }
    override void applyEffectToRw(RandomizedWeapon wpn) {
        wpn.stats.rofModifier = modifierLevel;
    }
}

// Shotgun-specific

class PrefPuny : RwWeaponPrefix {
    override string getName() {
        return "puny";
    }
    override string getDescription() {
        return "-"..modifierLevel.." pellets per shot";
    }
    override void Init() {
        modifierLevel = rnd.Rand(1, 3);
    }
    override bool IsCompatibleWithItem(Inventory item) {
        return super.IsCompatibleWithItem(item) && RandomizedWeapon(item).stats.Pellets > 3;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'PrefBulk';
    }
    override void applyEffectToRw(RandomizedWeapon wpn) {
        wpn.stats.Pellets -= modifierLevel;
    }
}

class PrefBulk : RwWeaponPrefix {
    override string getName() {
        return "bulk";
    }
    override string getDescription() {
        return "+"..modifierLevel.." pellets per shot";
    }
    override void Init() {
        modifierLevel = rnd.linearWeightedRand(1, 5, 100, 1);
    }
    override bool IsCompatibleWithItem(Inventory item) {
        return super.IsCompatibleWithItem(item) && RandomizedWeapon(item).stats.Pellets > 3;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'PrefPuny';
    }
    override void applyEffectToRw(RandomizedWeapon wpn) {
        wpn.stats.Pellets += modifierLevel;
    }
}

// Projectile-weapon specific

class PrefLazy : RwWeaponPrefix {
    override string getName() {
        return "lazy";
    }
    override string getDescription() {
        return modifierLevel.."% slower projectile";
    }
    override void Init() {
        modifierLevel = rnd.linearWeightedRand(1, 75, 100, 1);
    }
    override bool IsCompatibleWithItem(Inventory item) {
        return super.IsCompatibleWithItem(item) && RandomizedWeapon(item).stats.firesProjectiles;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'PrefQuick';
    }
    override void applyEffectToRw(RandomizedWeapon wpn) {
        wpn.stats.projSpeedPercModifier = -modifierLevel;
    }
}

class PrefQuick : RwWeaponPrefix {
    override string getName() {
        return "quick";
    }
    override string getDescription() {
        return modifierLevel.."% faster projectile";
    }
    override void Init() {
        modifierLevel = rnd.linearWeightedRand(1, 100, 100, 1);
    }
    override bool IsCompatibleWithItem(Inventory item) {
        return super.IsCompatibleWithItem(item) && RandomizedWeapon(item).stats.firesProjectiles;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'PrefLazy';
    }
    override void applyEffectToRw(RandomizedWeapon wpn) {
        wpn.stats.projSpeedPercModifier = modifierLevel;
    }
}

// Explosion-weapon specific

class PrefSmallerExplosion : RwWeaponPrefix {
    override string getName() {
        return "safer";
    }
    override string getDescription() {
        return modifierLevel.."% smaller explosion radius";
    }
    override void Init() {
        modifierLevel = rnd.linearWeightedRand(10, 75, 100, 1);
    }
    override bool IsCompatibleWithItem(Inventory item) {
        return super.IsCompatibleWithItem(item) && RandomizedWeapon(item).stats.ExplosionRadius > 0;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'PrefBiggerExplosion';
    }
    override void applyEffectToRw(RandomizedWeapon wpn) {
        wpn.stats.ExplosionRadius = math.getIntPercentage(
            wpn.stats.ExplosionRadius,
            100-modifierLevel
        );
    }
}

class PrefBiggerExplosion : RwWeaponPrefix {
    override string getName() {
        return "volatile";
    }
    override string getDescription() {
        return modifierLevel.."% bigger explosion radius";
    }
    override void Init() {
        modifierLevel = rnd.linearWeightedRand(20, 200, 1000, 1);
    }
    override bool IsCompatibleWithItem(Inventory item) {
        return  super.IsCompatibleWithItem(item) && RandomizedWeapon(item).stats.ExplosionRadius > 0;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'PrefSmallerExplosion';
    }
    override void applyEffectToRw(RandomizedWeapon wpn) {
        wpn.stats.ExplosionRadius = math.getIntPercentage(
            wpn.stats.ExplosionRadius,
            100+modifierLevel
        );
    }
}
