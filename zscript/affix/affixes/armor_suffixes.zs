class RwArmorSuffix : Affix {
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
    override bool isCompatibleWithAffClass(Affix a2) {
        return !(a2 is 'RwArmorSuffix'); // There may be only one suffix on an item
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
        return -1;
    }
    override string getDescription() {
        return String.Format("If damaged, eats your HP each %.1f secs (this won't kill)", 
            (Gametime.TicksToSeconds(modifierLevel)));
    }
    override void initAndapplyEffectToRArmor(RandomizedArmor arm, int quality) {
        let secondsx10 = remapQualityToRange(quality, 100, 5);
        modifierLevel = gametime.secondsToTicks(float(secondsx10)/10);
    }
    const HpDrainThreshold = 25;
    override void onDoEffect(Actor owner, Inventory affixedItem) {
        RandomizedArmor arm = RandomizedArmor(affixedItem);
        if (affixedItem.GetAge() % modifierLevel == 0 && RwPlayer(owner).health > HpDrainThreshold) {
            arm.RepairFor(5);
            owner.damageMobj(null, null, 5, 'Normal', DMG_NO_PROTECT|DMG_NO_ARMOR);
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
        return String.Format("Each %.1f sec heals you for free", (Gametime.TicksToSeconds(modifierLevel)));
    }
    override void initAndapplyEffectToRArmor(RandomizedArmor arm, int quality) {
        let secondsx10 = remapQualityToRange(quality, 150, 10);
        modifierLevel = gametime.secondsToTicks(float(secondsx10)/10);
    }
    override void onDoEffect(Actor owner, Inventory affixedItem) {
        RandomizedArmor arm = RandomizedArmor(affixedItem);
        if (affixedItem.GetAge() % modifierLevel == 0 && owner.Health < 100 && arm.IsNotBroken()) {
            owner.GiveBody(1, 125);
        }
    }
}

class ASuffHoly : RwArmorSuffix {
    override string getName() {
        return "Holy";
    }
    override string getDescription() {
        return String.Format("-%d%% damage from legendary and mythic monsters", (modifierLevel));
    }
    override void initAndapplyEffectToRArmor(RandomizedArmor arm, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(5, 35, 0.05) + remapQualityToRange(quality, 0, 25);
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
        return "Loses durability each "
            ..
            String.Format("%.1f", (Gametime.TicksToSeconds(modifierLevel)))
            .." seconds";
    }
    override bool IsCompatibleWithRArmor(RandomizedArmor arm) {
        return !(arm.stats.IsEnergyArmor());
    }
    override void initAndapplyEffectToRArmor(RandomizedArmor arm, int quality) {
        let secondsx10 = remapQualityToRange(quality, 150, 75);
        modifierLevel = gametime.secondsToTicks(float(secondsx10)/10);
    }
    override void onDoEffect(Actor owner, Inventory affixedItem) {
        RandomizedArmor arm = RandomizedArmor(affixedItem);
        if (affixedItem.GetAge() % modifierLevel == 0) {
            arm.DoDamageToArmor(1);
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
        return !(a2 is 'RwArmorSuffix' || a2 is 'APrefHard');
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
        return String.Format("Each %.1f sec spends %d durability to heal you", 
            (Gametime.TicksToSeconds(modifierLevel), DurabToHealthAmount));
    }
    override bool IsCompatibleWithRArmor(RandomizedArmor arm) {
        return !(arm.stats.IsEnergyArmor());
    }
    override void initAndapplyEffectToRArmor(RandomizedArmor arm, int quality) {
        let secondsx10 = remapQualityToRange(quality, 80, 5);
        modifierLevel = gametime.secondsToTicks(float(secondsx10)/10);
    }
    const DurabToHealthAmount = 2;
    override void onDoEffect(Actor owner, Inventory affixedItem) {
        RandomizedArmor arm = RandomizedArmor(affixedItem);
        if (arm.GetAge() % modifierLevel == 0 && arm.stats.currDurability >= DurabToHealthAmount && owner.health < 100) {
            owner.GiveBody(DurabToHealthAmount, 100);
            arm.stats.currDurability -= DurabToHealthAmount;
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
        return "Repairs itself each "
            ..
            String.Format("%.1f", (Gametime.TicksToSeconds(modifierLevel)))
            .." seconds";
    }
    override bool IsCompatibleWithRArmor(RandomizedArmor arm) {
        return !(arm.stats.IsEnergyArmor());
    }
    override void initAndapplyEffectToRArmor(RandomizedArmor arm, int quality) {
        let secondsx10 = remapQualityToRange(quality, 100, 5);
        modifierLevel = gametime.secondsToTicks(float(secondsx10)/10);
    }
    override void onDoEffect(Actor owner, Inventory affixedItem) {
        RandomizedArmor arm = RandomizedArmor(affixedItem);
        if (arm.GetAge() % modifierLevel == 0 && arm.IsDamaged()) {
            arm.RepairFor(1);
        }
    }
}

class ASuffThorns : RwArmorSuffix {
    override string getName() {
        return "Feedback";
    }
    override string getDescription() {
        return String.Format("%d%% chance to return %d%% of damage to the attacker",
            (modifierLevel, RandomizedArmor.ThornsReturnedPercentage));
    }
    override bool IsCompatibleWithRArmor(RandomizedArmor arm) {
        return !(arm.stats.IsEnergyArmor());
    }
    override void initAndapplyEffectToRArmor(RandomizedArmor arm, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, 50);
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
        return String.Format("On emptying deals %d dmg to everyone nearby", modifierLevel);
    }
    override int getAlignment() {
        return 1;
    }
    override bool IsCompatibleWithRArmor(RandomizedArmor arm) {
        return arm.stats.IsEnergyArmor();
    }
    override void initAndapplyEffectToRArmor(RandomizedArmor arm, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(5, 15, 0.05) + remapQualityToRange(quality, 0, 10);
        modifierLevel = StatsScaler.ScaleIntValueByLevelRandomized(modifierLevel, quality);
    }
    override void onDoEffect(Actor owner, Inventory affixedItem) {
        RandomizedArmor arm = RandomizedArmor(affixedItem);
        if (arm.stats.currDurability == 0 && (arm.ticksSinceDamage() == 1)) {
            let ti = ThinkerIterator.Create('Actor');
            Actor mo;
            while (mo = Actor(ti.next())) {
                let reqDistance = owner.radius * 10;
                if (mo && owner != mo && owner.Distance2D(mo) <= reqDistance) {
                    mo.damageMobj(null, owner, modifierLevel, 'Normal', DMG_NO_PROTECT);
                }
            }
        }
    }
}
