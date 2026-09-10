class RwRelicAffix : Affix abstract {
    override bool isSuffix() {
        return true;
    }
    override bool IsCompatibleWithItem(Inventory item) {
        return item is 'RwRelic';
    }
    override int getAlignment() {
        return 1;
    }
    override bool TryUnapplyingSelfFrom(Inventory item) {
        return true;
    }
    override int selectionProbabilityPercentage(Inventory appliedOn) {
        return 25;
    }
}

class RAffPlusAllStats : RwRelicAffix {
    override bool isSuffix() {
        return true;
    }
    override string getName() {
        return "VIP";
    }
    int statBonus;
    override string getDescription() {
        return "All stats +"..statBonus;
    }
    override void InitAndApplyEffectToItem(Inventory item, int quality) {
        statBonus = rnd.multipliedWeightedRandByEndWeight(1, 10, 0.05) + remapQualityToRange(quality, 0, 15);
    }

    override void onPlayerStatsRecalc(RwPlayer owner) {
        owner.stats.modifyCurrentStat(RwPlayerStats.StatVitality, statBonus);
        owner.stats.modifyCurrentStat(RwPlayerStats.StatCritChance, statBonus);
        owner.stats.modifyCurrentStat(RwPlayerStats.StatCritDmg, statBonus);
        owner.stats.modifyCurrentStat(RwPlayerStats.StatStrength, statBonus);
        owner.stats.modifyCurrentStat(RwPlayerStats.StatRareFind, statBonus);
    }
}

class RAffExpBonus : RwRelicAffix {
    override string getName() {
        return "Veterancy";
    }
    int expBonusPrc;
    override string getDescription() {
        return String.format("Receive +%d%% more experience", (expBonusPrc) );
    }
    override void InitAndApplyEffectToItem(Inventory item, int quality) {
        expBonusPrc = rnd.multipliedWeightedRandByEndWeight(5, 25, 0.05) + remapQualityToRange(quality, 0, 25);
    }

    override void onPlayerStatsRecalc(RwPlayer owner) {
        owner.stats.modifyCurrentStat(RwPlayerStats.StatExperienceBonusPrc, expBonusPrc);
    }
}

class RAffModifyAllDmg : RwRelicAffix {
    override string getName() {
        return "Targeting";
    }
    int dmgBonusPrc;
    override string getDescription() {
        return "+"..dmgBonusPrc.."% to all damage";
    }
    override void InitAndApplyEffectToItem(Inventory item, int quality) {
        dmgBonusPrc = rnd.multipliedWeightedRandByEndWeight(5, 20, 0.05) + remapQualityToRange(quality, 0, 10);
    }

    override void onModifyDamage(int damage, out int newdamage, bool passive, Actor inflictor, Actor source, Actor owner, int flags) {
        if (passive) return;
        newdamage = math.GetIntPercentage(damage, 100+dmgBonusPrc);
    }
}

class RAffModifyDmgOfSlot : RwRelicAffix {
    override string getName() {
        return "Speciality";
    }
    int dmgBonusPrc;
    int slot;
    override string getDescription() {
        return "+"..dmgBonusPrc.."% DMG for all "..WpnSlotsHelper.getSlotNamePlural(slot).." (slot "..slot..")";
    }
    override void InitAndApplyEffectToItem(Inventory item, int quality) {
        dmgBonusPrc = rnd.multipliedWeightedRandByEndWeight(10, 35, 0.05) + remapQualityToRange(quality, 0, 15);
        slot = rnd.rand(2, 7);
        if (slot == 2) {
            dmgBonusPrc += rnd.rand(5, 15); // Pistol receives even bigger bonus
        }
    }
    override void onModifyDamage(int damage, out int newdamage, bool passive, Actor inflictor, Actor source, Actor owner, int flags) {
        if (passive) return;
        if (!(owner.player.readyWeapon.SlotNumber == slot)) return;
        newdamage = math.GetIntPercentage(damage, 100+dmgBonusPrc);
    }
}

class RSuffRegen : RwRelicAffix {
    override string getName() {
        return "Regeneration";
    }
    int healPerTickX1000; // healPerTickX1000 is "HP per tick * precision"
    int maxHealPrc;
    override string getDescription() {
        return String.Format("Heals %.1f HP/sec until %d%% HP", (double(healPerTickX1000) * TICRATE/precision, maxHealPrc));
    }
    override void InitAndApplyEffectToItem(Inventory item, int quality) {
        healPerTickX1000 = math.divideIntWithRounding(
            rnd.multipliedWeightedRandByEndWeight(1000, 2500, 0.01) + remapQualityToRange(quality, 0, 1000),
            TICRATE
        );
        maxHealPrc = rnd.multipliedWeightedRandByEndWeight(50, 75, 0.01) + remapQualityToRange(quality, 0, 25);
    }
    const precision = 1000;
    int fractionAccumulator;
    override void onDoEffect(Actor owner, Inventory affixedItem) {
        let plr = RwPlayer(owner);
        if (plr == null) return;
        if (plr.getHealthPercentage() < maxHealPrc) {
            let addAmount = math.AccumulatedFixedPointAdd(0, healPerTickX1000, 1000, fractionAccumulator);
            if (addAmount > 0) {
                owner.GiveBody(addAmount);
            }
        }
    }
}

class RSuffArmorRepair : RwRelicAffix {
    override string getName() {
        return "Damage control";
    }
    int repairPerTick; // it is "repaired ampunt per tick * precision"
    override string getDescription() {
        return String.Format("Repairs your armor for %.1f DRB/sec", (double(repairPerTick) * TICRATE/1000));
    }
    override void InitAndApplyEffectToItem(Inventory item, int quality) {
        repairPerTick = math.divideIntWithRounding(
            rnd.multipliedWeightedRandByEndWeight(500, 1500, 0.05) + remapQualityToRange(quality, 0, 500),
            TICRATE
        );
    }
    override void onDoEffect(Actor owner, Inventory affixedItem) {
        let plr = RwPlayer(owner);
        if (plr == null) return;

        let arm = plr.CurrentEquippedArmor;
        if (arm == null) return;
        if (arm.stats.IsEnergyArmor()) return;

        let addAmount = math.AccumulatedFixedPointAdd(0, repairPerTick, 1000, arm.stats.currRepairFraction);
        if (addAmount > 0) {
            arm.RepairFor(addAmount);
        }
    }
}

class RSuffImprovedEnergyArmor : RwRelicAffix {
    override string getName() {
        return "Forcefields";
    }
    int delayPercReduction;
    int rechargeSpeedBonusPrc;
    override string getDescription() {
        return String.Format("All energy armor: -%d%% delay, +%d%% recharge speed", (delayPercReduction, rechargeSpeedBonusPrc));
    }
    override void InitAndApplyEffectToItem(Inventory item, int quality) {
        delayPercReduction = rnd.multipliedWeightedRandByEndWeight(10, 30, 0.05) + remapQualityToRange(quality, 0, 20);
        rechargeSpeedBonusPrc = rnd.multipliedWeightedRandByEndWeight(25, 150, 0.05) + remapQualityToRange(quality, 0, 50);
    }
    override void onDoEffect(Actor owner, Inventory affixedItem) {
        let plr = RwPlayer(owner);
        let arm = plr.CurrentEquippedArmor;
        if (arm && arm.stats.IsEnergyArmor()) {
            // Call only some ticks after the damage to prevent bugs with "next-tick-expecting" affixes (such as ASuffECellsSpend)
            if (arm.ticksSinceDamage() == 3) {
                arm.reduceRechargeDelay(delayPercReduction);
            }
            if (arm.isRechargingNow() && arm.stats.currDurability > 0) {
                let bonusRecharge = math.getIntPercentage(arm.stats.energyRestoreSpeedX1000, rechargeSpeedBonusPrc);
                arm.stats.currDurability = math.AccumulatedFixedPointAdd(arm.stats.currDurability, bonusRecharge, 1000, arm.stats.currRepairFraction);
            }
        }
    }
}

class RSuffImprovedActiveItems : RwRelicAffix {
    override string getName() {
        return "Activity";
    }
    int delayPercReduction;
    int bonusRefillRatePrc;
    override string getDescription() {
        return String.Format("Active items: -%d%% cooldown, +%d%% refill rate", (delayPercReduction, bonusRefillRatePrc));
    }
    override void InitAndApplyEffectToItem(Inventory item, int quality) {
        delayPercReduction = rnd.multipliedWeightedRandByEndWeight(10, 30, 0.05) + remapQualityToRange(quality, 0, 20);
        bonusRefillRatePrc = rnd.multipliedWeightedRandByEndWeight(10, 30, 0.05) + remapQualityToRange(quality, 0, 25);
    }
    int frac;
    int prevCharges;
    override void onDoEffect(Actor owner, Inventory affixedItem) {
        let plr = RwPlayer(owner);
        let asi = plr.EquippedActiveSlotItem;
        // Call only some ticks after the damage to prevent bugs with "next-tick-expecting" affixes (such as ASuffECellsSpend)
        if (plr && asi != null) {
            // Reduce cooldown
            if (asi.ticksSinceCooldownStarted() == 2) {
                asi.reduceCooldown(delayPercReduction);
            }
            // Add bonus recharge
            if (prevCharges < asi.currentCharges) {
                let diff = asi.currentCharges - prevCharges;
                let bonusRechargex1000 = math.getIntPercentage(diff * 1000, bonusRefillRatePrc);
                let add = math.AccumulatedFixedPointAdd(0, bonusRechargex1000, 1000, frac);
                asi.refill(add);
            }
            prevCharges = asi.currentCharges;
        }
    }
}
