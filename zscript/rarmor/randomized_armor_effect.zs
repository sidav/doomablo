// Suffixes are unique things gameplay-wise, so they require this separate definition.
// TODO: optimization of this logic...

extend class RandomizedArmor {

    // needed for affixes:
    int lastDamageTick;
    int cumulativeRepair; 
    const HpDrainThreshold = 25;
    const DurabToHealthAmount = 2;
    const RepairForAbsUpgrade = 50;
    const RepairForDrbUpgrade = 25;
    const ThornsReturnedPercentage = 25;

    override void DoEffect() {
        let age = GetAge();

        // First: self-repair
        if (stats.currDurability < stats.maxDurability) {
            let aff = findAppliedAffix('ASuffSelfrepair');
            if (aff != null) {
                if (age % aff.modifierLevel == 0) {
                    stats.currDurability++;
                }
                return; // There may be no other affix anyway
            }

            aff = findAppliedAffix('ASuffMedikitsRepairArmor');
            if (aff != null && RwPlayer(owner).lastHealedBy >= 10) {
                stats.currDurability += aff.modifierLevel;
                return;
            }

            aff = findAppliedAffix('ASuffHealthToDurab');
            if (aff != null && RwPlayer(owner).health > HpDrainThreshold && (age % aff.modifierLevel == 0)) {
                RepairFor(5);
                owner.damageMobj(null, null, 5, 'Normal', DMG_NO_PROTECT|DMG_NO_ARMOR);
                return;
            }
        }

        // Second: heal the owner
        if (stats.currDurability > 0 && owner.health < 100) {
            let aff = findAppliedAffix('ASuffDurabToHealth');
            if (aff != null) {
                if (age % aff.modifierLevel == 0) {
                    owner.GiveBody(DurabToHealthAmount, 100);
                    stats.currDurability -= DurabToHealthAmount;
                }
                return; // There may be no other affix anyway
            }
        }

        if (stats.currDurability > 0 && owner.health < 100) {
            let aff = findAppliedAffix('ASuffSlowHeal');
            if (aff != null) {
                if (age % aff.modifierLevel == 0) {
                    owner.GiveBody(1, 125);
                }
                return; // There may be no other affix anyway
            }
        }

        // Loses durability
        if (stats.currDurability > 0) {
            let aff = findAppliedAffix('ASuffDegrading');
            if (aff != null) {
                if (age % aff.modifierLevel == 0) {
                    stats.currDurability--;
                    lastDamageTick = GetAge();
                }
                return; // There may be no other affix anyway
            }
        }

        if (stats.currDurability == 0 && (ticksSinceDamage() == stats.delayUntilRecharge)) {
            let aff = findAppliedAffix('ASuffECellsSpend');
            if (aff != null) {
                let cl = owner.FindInventory('Cell');
                if (cl && cl.Amount >= aff.modifierLevel) {
                    cl.Amount -= aff.modifierLevel;
                } else {
                    lastDamageTick += TICRATE; // call this again 1 sec later hehe
                }
                return; // There may be no other affix anyway
            }
        }

        if (stats.currDurability == 0 && (ticksSinceDamage() == 1)) {
            let aff = findAppliedAffix('ASuffEDamageOnEmpty');
            if (aff != null) {
                let ti = ThinkerIterator.Create('Actor');
                Actor mo;
                while (mo = Actor(ti.next())) {
                    let reqDistance = owner.radius * 10;
                    if (mo && owner != mo && owner.Distance2D(mo) <= reqDistance) {
                        mo.damageMobj(null, owner, aff.modifierLevel, 'Normal', DMG_NO_PROTECT);
                    }
                }
                return; // There may be no other affix anyway
            }
        }

        if (cumulativeRepair >= RepairForAbsUpgrade) {
            let aff = findAppliedAffix('ASuffAbsImprove');
            if (aff != null && aff.modifierLevel > stats.AbsorbsPercentage) {
                stats.AbsorbsPercentage += 1;
                cumulativeRepair = 0;
                return; // There may be no other affix anyway
            }
        }

        if (cumulativeRepair >= RepairForDrbUpgrade) {
            let aff = findAppliedAffix('ASuffDrbImprove');
            if (aff != null && aff.modifierLevel > stats.maxDurability) {
                stats.maxDurability += 1;
                stats.currDurability += 1;
                cumulativeRepair = 0;
                return; // There may be no other affix anyway
            }
        }

    }

    override void AbsorbDamage(int damage, Name damageType, out int newdamage, Actor inflictor, Actor source, int flags) {
        if (source && damage > 1) {
            let aff = findAppliedAffix('ASuffThorns');
            if (aff != null && rnd.PercentChance(aff.modifierLevel)) {
                let thornDamage = max(1, math.getIntPercentage(damage, ThornsReturnedPercentage));
                source.damageMobj(null, owner, thornDamage, 'Normal', DMG_NO_PROTECT);
            }

            // TODO: maybe it's too OP? Increase absorption only?
            if (stats.currDurability > 0) {
                aff = findAppliedAffix('ASuffHoly');
                if (aff != null) {
                    damage = max(1, math.getIntPercentage(damage, 100 - aff.modifierLevel));
                }
            }
        }
        if (stats.currDurability > 0) {
            damage -= stats.DamageReduction;
            if (damage <= 0) {
                damage = 1;
            }
        }
        let damageToArmor = math.getIntPercentage(damage, stats.AbsorbsPercentage);
        if (damageToArmor > stats.currDurability) {
            damageToArmor = stats.currDurability;
        }
        if (stats.currDurability > 0 && damageToArmor > 0) {
            lastDamageTick = GetAge();
        }
        stats.currDurability -= damageToArmor;
        newdamage = damage - damageToArmor;
    }

}
