class Prefix : Affix {

}

// Copy-paste and uncomment for new prefix
// class PrefExample : Prefix {
//     override string getName() {
//         // Write here
//     }
//     override bool IsCompatibleWithAffClass(Affix a2) {
//         // Write here
//     }
//     override void applyEffectToRw(RandomizedWeapon wpn) {
//         // Write here
//     }
// }

class PrefWeak : Prefix {
    override string getName() {
        return "weak";
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'PrefStrong';
    }
    override void applyEffectToRw(RandomizedWeapon wpn) {
        wpn.stats.DamageDice.Mod -= 2;
    }
}

class PrefStrong : Prefix {
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'PrefWeak';
    }
    override string getName() {
        return "strong";
    }
    override void applyEffectToRw(RandomizedWeapon wpn) {
        wpn.stats.DamageDice.Mod += 2;
    }
}

class PrefInaccurate : Prefix {
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'PrefPrecise';
    }
    override string getName() {
        return "inaccurate";
    }
    override void applyEffectToRw(RandomizedWeapon wpn) {
        wpn.stats.HorizSpread *= 2;
        wpn.stats.VertSpread *= 1.5;
    }
}

class PrefPrecise : Prefix {
    override string getName() {
        return "precise";
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'PrefInaccurate';
    }
    override void applyEffectToRw(RandomizedWeapon wpn) {
        wpn.stats.HorizSpread /= 2;
        wpn.stats.VertSpread /= 1.5;
    }
}

class PrefPuny : Prefix {
    override string getName() {
        return "puny";
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'PrefBulk';
    }
    override bool IsCompatibleWithItem(Inventory item) {
        return RandomizedWeapon(item).stats.Pellets > 1;
    }
    override void applyEffectToRw(RandomizedWeapon wpn) {
        wpn.stats.Pellets = 2 * wpn.stats.Pellets / 3;
    }
}

class PrefBulk : Prefix {
    override string getName() {
        return "bulk";
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'PrefPuny';
    }
    // override bool IsCompatibleWithItem(Inventory item) {
    // }
    override void applyEffectToRw(RandomizedWeapon wpn) {
        let pellets = wpn.stats.Pellets;
        pellets = Clamp(3 * pellets / 2, 2, 100);
        wpn.stats.Pellets = pellets;
    }
}

class PrefSlow : Prefix {
    override string getName() {
        return "slow";
    }
    override bool IsCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'PrefFast';
    }
    override void applyEffectToRw(RandomizedWeapon wpn) {
        wpn.stats.rofModifier = -25;
    }
}

class PrefFast : Prefix {
    override string getName() {
        return "fast";
    }
    override bool IsCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'PrefSlow';
    }
    override void applyEffectToRw(RandomizedWeapon wpn) {
        wpn.stats.rofModifier = 25;
    }
}
