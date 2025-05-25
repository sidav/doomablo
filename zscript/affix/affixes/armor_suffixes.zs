class RwArmorSuffix : Affix abstract {
    override void InitAndApplyEffectToItem(Inventory item, int quality) {
        initAndapplyEffectToRArmor(RandomizedArmor(item), quality);
    }
    protected virtual void initAndapplyEffectToRArmor(RandomizedArmor armor, int quality) {
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
    override int selectionProbabilityPercentage() {
        return 50;
    }
    override bool IsCompatibleWithItem(Inventory item) {
        return (RandomizedArmor(item) != null) && IsCompatibleWithRArmor(RandomizedArmor(item));
    }
    // Override this, and not IsCompatibleWithItem() in descendants. Stop excessive super.IsCompatibleWithItem() calls!
    private virtual bool IsCompatibleWithRArmor(RandomizedArmor arm) {
        return true;
    }
}

// Universal ones

class ASuffHealthToDurab : RwArmorSuffix {
    override string getName() {
        return "Blood pact";
    }
    override int getAlignment() {
        return 0;
    }
    override string getDescription() {
        return String.Format("Regains %.1f DRB/sec for %.1f HP/sec (leaves %d HP)",
        (double(stat2) * TICRATE/precision, double(modifierLevel) * TICRATE/precision, HpDrainThreshold));
    }
    override void initAndapplyEffectToRArmor(RandomizedArmor arm, int quality) {
        // ModifierLevel is "HP per tick * precision"
        modifierLevel = math.divideIntWithRounding(
            1000 - (rnd.multipliedWeightedRandByEndWeight(0, 500, 0.05) + remapQualityToRange(quality, 0, 250)),
            TICRATE
        );
        // stat2 is "DRB per tick * precision"
        stat2 = math.divideIntWithRounding(
            rnd.multipliedWeightedRandByEndWeight(0, 2500, 0.05) + remapQualityToRange(quality, 500, 1000),
            TICRATE
        );
    }
    const HpDrainThreshold = 50;
    const precision = 1000;
    int drbAccum; // fraction for reducing armor
    int hpAccum; // fraction for healed value
    override void onDoEffect(Actor owner, Inventory affixedItem) {
        RandomizedArmor arm = RandomizedArmor(affixedItem);
        if (RwPlayer(owner).health > HpDrainThreshold && arm.GetDrbPercentage() < 100) {
            let addAmount = math.AccumulatedFixedPointAdd(0, stat2, precision, drbAccum);
            if (addAmount > 0) {
                arm.RepairFor(addAmount);
            }
            let subAmount = math.AccumulatedFixedPointAdd(0, modifierLevel, precision, hpAccum);
            if (subAmount > 0) {
                owner.damageMobj(null, null, subAmount, 'Normal', DMG_NO_PROTECT|DMG_NO_ARMOR);
            }
        }
    }
}

class ASuffLengthenStatusEffects : RwArmorSuffix {
    override string getName() {
        return "Rust";
    }
    override string getDescription() {
        return String.Format("Status effects wear off %d%% slower", (modifierLevel));
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'ASuffShortenStatusEffects';
    }
    override int getAlignment() {
        return -1;
    }
    override int minRequiredRarity() {
        return 2;
    }
    override void initAndapplyEffectToRArmor(RandomizedArmor arm, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(3, 40, 0.05) + remapQualityToRange(quality, 0, 10);
    }
    override void onDoEffect(Actor owner, Inventory affixedItem) {
        RandomizedArmor arm = RandomizedArmor(affixedItem);
        if (arm.IsFullyBroken()) return;
        let invlist = owner.inv;
        while(invlist != null) {
            if (invlist != null && invlist is 'RwStatusEffectToken') {
                let se = RwStatusEffectToken(invlist);
                if (se.ReductionPeriodTicks > 0 && se.ReductionPeriodTicks == se.Default.ReductionPeriodTicks) {
                    // Speed application formula
                    let newPeriod = math.divideIntWithRounding(se.ReductionPeriodTicks * 100, 100 - modifierLevel);
                    se.ReductionPeriodTicks = newPeriod;
                }
            }
            invlist=invlist.Inv;
        };    
    }
}

class ASuffShortenStatusEffects : RwArmorSuffix {
    override string getName() {
        return "ResisTech";
    }
    override string getDescription() {
        return String.Format("Status effects wear off %d%% faster", (modifierLevel));
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'ASuffLengthenStatusEffects';
    }
    override void initAndapplyEffectToRArmor(RandomizedArmor arm, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(5, 125, 0.05) + remapQualityToRange(quality, 0, 25);
    }
    override void onDoEffect(Actor owner, Inventory affixedItem) {
        RandomizedArmor arm = RandomizedArmor(affixedItem);
        if (arm.IsFullyBroken()) return;
        let invlist = owner.inv;
        while(invlist != null) {
            if (invlist != null && invlist is 'RwStatusEffectToken') {
                let se = RwStatusEffectToken(invlist);
                if (se.ReductionPeriodTicks > 0 && se.ReductionPeriodTicks == se.Default.ReductionPeriodTicks) {
                    // Speed application formula
                    let newPeriod = math.divideIntWithRounding(se.ReductionPeriodTicks * 100, 100 + modifierLevel);
                    se.ReductionPeriodTicks = newPeriod;
                }
            }
            invlist=invlist.Inv;
        };    
    }
}

class ASuffSlowHeal : RwArmorSuffix {
    override string getName() {
        return "UAC RegenTech";
    }
    override string getDescription() {
        return String.Format("Heals %.1f HP/sec for free", (double(modifierLevel) * TICRATE/precision));
    }
    override void initAndapplyEffectToRArmor(RandomizedArmor arm, int quality) {
        // ModifierLevel is "HP per tick * precision"
        modifierLevel = math.divideIntWithRounding(
            rnd.multipliedWeightedRandByEndWeight(120, 1250, 0.01) + remapQualityToRange(quality, 0, 250),
            TICRATE
        );
    }
    const precision = 1000;
    int fractionAccumulator;
    override void onDoEffect(Actor owner, Inventory affixedItem) {
        RandomizedArmor arm = RandomizedArmor(affixedItem);
        if (owner.Health < 100 && arm.IsNotBroken()) {
            let addAmount = math.AccumulatedFixedPointAdd(0, modifierLevel, 1000, fractionAccumulator);
            if (addAmount > 0) {
                owner.GiveBody(addAmount);
            }
        }
    }
}

class ASuffHoly : RwArmorSuffix {
    override string getName() {
        return "Holy";
    }
    override string getDescription() {
        return String.Format("-%d%% damage from epic monsters and higher", (modifierLevel));
    }
    override void initAndapplyEffectToRArmor(RandomizedArmor arm, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(5, 35, 0.05) + remapQualityToRange(quality, 0, 25);
    }
    override void onAbsorbDamage(int damage, Name damageType, out int newdamage, Actor inflictor, Actor source, Actor armorOwner, int flags) {
        RwMonsterAffixator monAffixator = RwMonsterAffixator.GetMonsterAffixator(source);
        // Epic monsters and higher
        if (monAffixator != null && monAffixator.GetRarity() >= 3) {
            newdamage = max(1, math.getIntPercentage(damage, 100 - modifierLevel));
        }
    }
}

// Non-energy only

class ASuffDegrading : RwArmorSuffix {
    override string getName() {
        return "No license";
    }
    override int getAlignment() {
        return -1;
    }
    override int minRequiredRarity() {
        return 2;
    }
    override string getDescription() {
        return String.Format("Loses %.1f DRB/sec until %d%% DRB", (double(modifierLevel) * TICRATE/precision, stat2));
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'ASuffSelfRepair';
    }
    override bool IsCompatibleWithRArmor(RandomizedArmor arm) {
        return !(arm.stats.IsEnergyArmor());
    }
    override void initAndapplyEffectToRArmor(RandomizedArmor arm, int quality) {
        // ModifierLevel is "DRB per tick * precision"
        modifierLevel = math.divideIntWithRounding(
            rnd.multipliedWeightedRandByEndWeight(150, 700, 0.05) + remapQualityToRange(quality, 0, 100),
            TICRATE
        );
        // stat2 is "percentage at which it stops"
        stat2 = rnd.multipliedWeightedRandByEndWeight(25, 75, 0.1);
    }
    const precision = 1000;
    int fractionAccumulator;
    override void onDoEffect(Actor owner, Inventory affixedItem) {
        RandomizedArmor arm = RandomizedArmor(affixedItem);
        if (arm.GetDrbPercentage() > stat2) {
            let addAmount = math.AccumulatedFixedPointAdd(0, modifierLevel, 1000, fractionAccumulator);
            if (addAmount > 0) {
                arm.stats.currDurability -= addAmount;
            }
        }
    }
}

class ASuffAbsImprove : RwArmorSuffix {
    override string getName() {
        return "AdapTek";
    }
    override string getDescription() {
        return "Gain +1% ABS (max "..modifierLevel..") for each "..stat2.." repaired";
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return !(a2 is 'RwArmorSuffix' || a2 is 'APrefBetterAbsorption');
    }
    override bool IsCompatibleWithRArmor(RandomizedArmor arm) {
        return !(arm.stats.IsEnergyArmor());
    }
    override void initAndapplyEffectToRArmor(RandomizedArmor arm, int quality) {
        modifierLevel = remapQualityToRange(quality, 5*arm.stats.AbsorbsPercentage/4, min(5*arm.stats.AbsorbsPercentage/2, 100));
        stat2 = 65 - rnd.multipliedWeightedRandByEndWeight(0, 30, 0.05); // Upgrade each this much repaired
    }
    override void onDoEffect(Actor owner, Inventory affixedItem) {
        RandomizedArmor arm = RandomizedArmor(affixedItem);
        if (arm.cumulativeRepair >= stat2 && modifierLevel > arm.stats.AbsorbsPercentage) {
            arm.stats.AbsorbsPercentage += 1;
            arm.cumulativeRepair = 0;
        }
    }
}

class ASuffDrbImprove : RwArmorSuffix {
    override string getName() {
        return "Overbuild";
    }
    override string getDescription() {
        return "Gain +1 DRB (max "..modifierLevel..") for each "..stat2.." repaired";
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return !(a2 is 'RwArmorSuffix' || a2 is 'APrefSturdy');
    }
    override bool IsCompatibleWithRArmor(RandomizedArmor arm) {
        return !(arm.stats.IsEnergyArmor());
    }
    override void initAndapplyEffectToRArmor(RandomizedArmor arm, int quality) {
        // 120-250% max
        let percentage = rnd.multipliedWeightedRandByEndWeight(120, 200, 0.05) + remapQualityToRange(quality, 0, 50);
        modifierLevel = math.getIntPercentage(arm.stats.maxDurability, percentage);
        stat2 = 55 - rnd.multipliedWeightedRandByEndWeight(0, 35, 0.05); // Upgrade each this much repaired
    }
    override void onDoEffect(Actor owner, Inventory affixedItem) {
        RandomizedArmor arm = RandomizedArmor(affixedItem);
        if (arm.cumulativeRepair >= stat2 && modifierLevel > arm.stats.maxDurability) {
            arm.stats.maxDurability += 1;
            arm.stats.currDurability += 1;
            arm.cumulativeRepair = 0;
        }
    }
}

class ASuffDurabToHealth : RwArmorSuffix {
    override string getName() {
        return "UAC MediTech";
    }
    override string getDescription() {
        return String.Format("Spends %.1f DUR/sec to heal you for %.1f HP/sec", 
            (double(stat2) * TICRATE/precision, double(modifierLevel) * TICRATE/precision));
    }
    override bool IsCompatibleWithRArmor(RandomizedArmor arm) {
        return !(arm.stats.IsEnergyArmor());
    }
    override void initAndapplyEffectToRArmor(RandomizedArmor arm, int quality) {
        // ModifierLevel is "HP per tick * precision"
        modifierLevel = math.divideIntWithRounding(
            rnd.multipliedWeightedRandByEndWeight(500, 2250, 0.05) + remapQualityToRange(quality, 0, 500),
            TICRATE
        );
        // stat2 is "DRB lost per tick * precision"
        stat2 = math.divideIntWithRounding(
            2500 - (rnd.multipliedWeightedRandByEndWeight(0, 1500, 0.01) + remapQualityToRange(quality, 0, 500)),
            TICRATE
        );
    }
    const precision = 1000;
    int substractAccum; // fraction for reducing armor
    int healAccum; // fraction for healed value
    override void onDoEffect(Actor owner, Inventory affixedItem) {
        RandomizedArmor arm = RandomizedArmor(affixedItem);
        if (arm.stats.currDurability > 0 && owner.health < 100) {
            let addAmount = math.AccumulatedFixedPointAdd(0, modifierLevel, precision, healAccum);
            if (addAmount > 0) {
                owner.GiveBody(addAmount);
            }
            let subAmount = math.AccumulatedFixedPointAdd(0, stat2, precision, substractAccum);
            if (subAmount > 0) {
                arm.stats.currDurability -= subAmount;
            }
        }
    }
}

class ASuffMedikitsRepairArmor : RwArmorSuffix {
    override string getName() {
        return "Biosteel";
    }
    override string getDescription() {
        return String.Format("Repair %d DRB on non-bonus heal", (modifierLevel));
    }
    override bool IsCompatibleWithRArmor(RandomizedArmor arm) {
        return !(arm.stats.IsEnergyArmor());
    }
    override void initAndapplyEffectToRArmor(RandomizedArmor arm, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, 5, 0.1) + remapQualityToRange(quality, 0, 5);
    }
    override void onDoEffect(Actor owner, Inventory affixedItem) {
        RandomizedArmor arm = RandomizedArmor(affixedItem);
        if (RwPlayer(owner) && RwPlayer(owner).lastHealedBy >= 10) {
            arm.RepairFor(modifierLevel);
        }
    }
}

class ASuffSelfrepair : RwArmorSuffix {
    override string getName() {
        return "UAC Nanotech";
    }
    override string getDescription() {
        return String.Format("Repairs itself for %.1f DRB/sec", (double(modifierLevel) * TICRATE/precision));
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'ASuffDegrading';
    }
    override bool IsCompatibleWithRArmor(RandomizedArmor arm) {
        return !(arm.stats.IsEnergyArmor());
    }
    override void initAndapplyEffectToRArmor(RandomizedArmor arm, int quality) {
        // ModifierLevel is "HP per tick * precision"
        modifierLevel = math.divideIntWithRounding(
            rnd.multipliedWeightedRandByEndWeight(250, 1000, 0.05) + remapQualityToRange(quality, 0, 250),
            TICRATE
        );
    }
    const precision = 1000;
    int fractionAccumulator;
    override void onDoEffect(Actor owner, Inventory affixedItem) {
        RandomizedArmor arm = RandomizedArmor(affixedItem);
        let addAmount = math.AccumulatedFixedPointAdd(0, modifierLevel, 1000, fractionAccumulator);
        if (addAmount > 0) {
            arm.RepairFor(addAmount);
        }
    }
}

class ASuffThorns : RwArmorSuffix {
    override string getName() {
        return "Feedback";
    }
    override string getDescription() {
        return String.Format("%d%% chance to return %d%% of damage to the attacker",
            (modifierLevel, stat2));
    }
    override bool IsCompatibleWithRArmor(RandomizedArmor arm) {
        return !(arm.stats.IsEnergyArmor());
    }
    override void initAndapplyEffectToRArmor(RandomizedArmor arm, int quality) {
        // Chance
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(5, 50, 0.05) + remapQualityToRange(quality, 0, 15);
        // Percentage. It may be really high (up to 500%) because the monster damage is not scaled, but their HP is.
        stat2 = rnd.multipliedWeightedRandByEndWeight(0, 300, 0.05) + remapQualityToRange(quality, 25, 200);
    }
    override void onAbsorbDamage(int damage, Name damageType, out int newdamage, Actor inflictor, Actor source, Actor armorOwner, int flags) {
        if (rnd.PercentChance(modifierLevel)) {
            let thornDamage = max(1, math.getIntPercentage(damage, stat2));
            source.damageMobj(null, armorOwner, thornDamage, 'Normal', DMG_NO_PROTECT);
        }
    }
}

class ASuffRefillFlaskOnHit : RwArmorSuffix {
    override string getName() {
        return "Bloodcycle";
    }
    override string getDescription() {
        return String.Format("%d%% chance to gain flask charge on being hit",
            (modifierLevel));
    }
    override bool IsCompatibleWithRArmor(RandomizedArmor arm) {
        return !(arm.stats.IsEnergyArmor());
    }
    override void initAndapplyEffectToRArmor(RandomizedArmor arm, int quality) {
        // Chance
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, 10, 0.05) + remapQualityToRange(quality, 0, 5);
    }
    override void onAbsorbDamage(int damage, Name damageType, out int newdamage, Actor inflictor, Actor source, Actor armorOwner, int flags) {
        if (RWPlayer(armorOwner) && RWPlayer(armorOwner).CurrentEquippedFlask != null) {
            if (rnd.PercentChance(modifierLevel)) {
                RWPlayer(armorOwner).CurrentEquippedFlask.Refill(1);
            }
        }
    }
}

// Energy-only

class ASuffECellsSpend : RwArmorSuffix {
    override string getName() {
        return "external power";
    }
    override string getDescription() {
        return "When empty, spends "..modifierLevel.." cells to start recharging";
    }
    override int getAlignment() {
        return -1;
    }
    override bool IsCompatibleWithRArmor(RandomizedArmor arm) {
        return arm.stats.IsEnergyArmor();
    }
    override void initAndapplyEffectToRArmor(RandomizedArmor arm, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(5, 15, 0.1) + remapQualityToRange(quality, 0, 10);
    }
    override void onDoEffect(Actor owner, Inventory affixedItem) {
        RandomizedArmor arm = RandomizedArmor(affixedItem);
        if (arm.stats.currDurability == 0 && (arm.ticksSinceDamage() == arm.stats.delayUntilRecharge)) {
            let cl = owner.FindInventory('Cell');
            if (cl && cl.Amount >= modifierLevel) {
                cl.Amount -= modifierLevel;
            } else {
                arm.lastDamageTick += TICRATE; // call this again 1 sec later hehe
            }
        }
    }
}

class ASuffEBonusRepair : RwArmorSuffix {
    override string getName() {
        return "Recycling";
    }
    override string getDescription() {
        return String.Format("Can be recharged by armor bonuses (+%d)", modifierLevel);
    }
    override int getAlignment() {
        return 1;
    }
    override bool IsCompatibleWithRArmor(RandomizedArmor arm) {
        return arm.stats.IsEnergyArmor();
    }
    override void initAndapplyEffectToRArmor(RandomizedArmor arm, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, 5, 0.05) + remapQualityToRange(quality, 0, 5);
        arm.stats.BonusRepair = modifierLevel;
    }
}

class ASuffEDamageOnEmpty : RwArmorSuffix {
    override string getName() {
        return "UAC A-Def";
    }
    override string getDescription() {
        return String.Format("On emptying: %d dmg to nearby enemies (radius %.1f)", (modifierLevel, float(stat2)/10));
    }
    override int getAlignment() {
        return 1;
    }
    override bool IsCompatibleWithRArmor(RandomizedArmor arm) {
        return arm.stats.IsEnergyArmor();
    }
    override void initAndapplyEffectToRArmor(RandomizedArmor arm, int quality) {
        // Damage
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(5, 45, 0.01) + remapQualityToRange(quality, 0, 15);
        modifierLevel = StatsScaler.ScaleIntValueByLevelRandomized(modifierLevel, quality);
        // Radius (x10)
        stat2 = rnd.multipliedWeightedRandByEndWeight(75, 200, 0.05);
    }
    override void onDoEffect(Actor owner, Inventory affixedItem) {
        RandomizedArmor arm = RandomizedArmor(affixedItem);
        if (arm.stats.currDurability == 0 && (arm.ticksSinceDamage() == 1)) {
            let ti = ThinkerIterator.Create('Actor');
            Actor mo;
            while (mo = Actor(ti.next())) {
                let reqDistance = owner.radius * float(stat2) / 10.;
                if (mo && owner != mo && owner.Distance2D(mo) <= reqDistance) {
                    mo.damageMobj(null, owner, modifierLevel, 'Normal', DMG_NO_PROTECT);
                }
            }
        }
    }
}
