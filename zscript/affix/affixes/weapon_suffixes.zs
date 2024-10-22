class RwWeaponSuffix : Affix {
    override void InitAndApplyEffectToItem(Inventory item, int quality) {
        initAndApplyEffectToRWeapon(RandomizedWeapon(item), quality);
    }
    protected virtual void initAndApplyEffectToRWeapon(RandomizedWeapon weapon, int quality) {
        debug.panicUnimplemented(self);
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

    override void onDamageDealtByPlayer(int damage, Actor target, RwPlayer plr) {
        if (rnd.PercentChance(modifierLevel)) {
            plr.Player.bonusCount += 3;
            plr.GiveBody(1, 200);
        }
    }
}

class WSuffDamageIncreaseOnLowHealth : RwWeaponSuffix {
    const requiredHp = 25;
    override string getName() {
        return "Last Resort";
    }
    override string getDescription() {
        return String.Format("%d%% damage when you have %d HP or less", (modifierLevel, requiredHp));
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
        let maxPercentage = 250;
        if (wpn.stats.Pellets > 1) {
            maxPercentage = 200;
        }
        modifierLevel = remapQualityToRange(quality, 150, maxPercentage);
    }
    override int modifyRolledDamage(int rolledDmg, RwPlayer owner) {
        if (owner.health <= requiredHp) {
            return math.getIntPercentage(rolledDmg, modifierLevel);
        }
        return rolledDmg;
    }
}

class WSuffDamageIncreaseOnZeroArmor : RwWeaponSuffix {
    override string getName() {
        return "Glass Cannon";
    }
    override string getDescription() {
        return modifierLevel.."% damage when you have zero armor";
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
        let maxPercentage = 200;
        if (wpn.stats.Pellets > 1) {
            maxPercentage = 150;
        }
        modifierLevel = remapQualityToRange(quality, 105, maxPercentage);
    }
    override int modifyRolledDamage(int rolledDmg, RwPlayer owner) {
        if (owner.CurrentEquippedArmor == null || owner.CurrentEquippedArmor.stats.currDurability == 0) {
            return math.getIntPercentage(rolledDmg, modifierLevel);
        }
        return rolledDmg;
    }
}

class WSuffDamageIncreaseOnFullArmor : RwWeaponSuffix {
    override string getName() {
        return "Best defense";
    }
    override string getDescription() {
        return modifierLevel.."% damage when you have full non-energy armor";
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
        let maxPercentage = 200;
        if (wpn.stats.Pellets > 1) {
            maxPercentage = 175;
        }
        modifierLevel = remapQualityToRange(quality, 105, maxPercentage);
    }
    override int modifyRolledDamage(int rolledDmg, RwPlayer owner) {
        if (owner.CurrentEquippedArmor != null && !owner.CurrentEquippedArmor.stats.IsEnergyArmor() && owner.CurrentEquippedArmor.stats.IsFull()) {
            return math.getIntPercentage(rolledDmg, modifierLevel);
        }
        return rolledDmg;
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
        modifierLevel = remapQualityToRange(quality, 1, maxPercentage);
    }
    override void onDamageDealtByPlayer(int damage, Actor target, RwPlayer plr) {
        if (rnd.PercentChance(modifierLevel)) {
            target.GiveInventory('RWPoisonToken', 10);
        }
    }
}

class WSuffRadiation : RwWeaponSuffix {
    override string getName() {
        return "Irradiation";
    }
    override string getDescription() {
        return modifierLevel.."% chance to irradiate the target on hit";
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
        let maxPercentage = 50;
        if (wpn.stats.Pellets > 1) {
            maxPercentage = 20;
        } else if (wpn.stats.clipSize > 5) {
            maxPercentage = 33;
        }
        modifierLevel = remapQualityToRange(quality, 1, maxPercentage);
    }
    override void onDamageDealtByPlayer(int damage, Actor target, RwPlayer plr) {
        if (rnd.PercentChance(modifierLevel)) {
            target.GiveInventory('RWRadiationToken', 1);
        }
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
    override void onDamageDealtByPlayer(int damage, Actor target, RwPlayer plr) {
        if (rnd.PercentChance(modifierLevel)) {
            target.GiveInventory('RWPainToken', 5);
        }
    }
}

class WSuffAmmoDrops : RwWeaponSuffix {
    mixin DropSpreadable;
    override string getName() {
        return "Abundance";
    }
    override string getDescription() {
        return modifierLevel.."% chance for killed enemy to drop additional ammo";
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
        modifierLevel = remapQualityToRange(quality, 15, 100);
    }
    override void onFatalDamageDealtByPlayer(int damage, Actor target, RwPlayer plr) {
        if (rnd.PercentChance(modifierLevel)) {
            let ammoitem = DropsHandler.SpawnRandomAmmoDrop(target);
            AssignSpreadVelocityTo(ammoitem);
        }
    }
}

class WSuffSpawnBarrelOnKill : RwWeaponSuffix {
    mixin DropSpreadable;
    override string getName() {
        return "Barrels";
    }
    override string getDescription() {
        return modifierLevel.."% chance to create explosive barrel on kill";
    }
    override void initAndApplyEffectToRWeapon(RandomizedWeapon wpn, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, 25);
    }
    override void onFatalDamageDealtByPlayer(int damage, Actor target, RwPlayer plr) {
        if (rnd.PercentChance(modifierLevel)) {
            let brl = Target.Spawn('ExplosiveBarrel', target.Pos);
            AssignSpreadVelocityTo(brl);
        }
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
