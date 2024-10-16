// Suffixes are unique things gameplay-wise, so they require this separate definition.
// TODO: optimization of this logic...

extend class RandomizedArmor {

    // needed for affixes:
    int lastDamageTick;
    int cumulativeRepair; 
    const RepairForAbsUpgrade = 50;
    const RepairForDrbUpgrade = 25;

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
        }

        // Second: heal the owner
        if (stats.currDurability > 0 && owner.health < 100) {
            let aff = findAppliedAffix('ASuffDurabToHealth');
            if (aff != null) {
                if (age % aff.modifierLevel == 0) {
                    owner.GiveBody(1, 100);
                    stats.currDurability--;
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
            if (aff != null) {
                stats.AbsorbsPercentage += 1;
                cumulativeRepair = 0;
                return; // There may be no other affix anyway
            }
        }

        if (cumulativeRepair >= RepairForDrbUpgrade) {
            let aff = findAppliedAffix('ASuffDrbImprove');
            if (aff != null) {
                stats.maxDurability += 1;
                stats.currDurability += 1;
                cumulativeRepair = 0;
                return; // There may be no other affix anyway
            }
        }

    }

    override void AbsorbDamage(int damage, Name damageType, out int newdamage, Actor inflictor, Actor source, int flags) {
        damage -= stats.DamageReduction;
        if (damage <= 0) {
            damage = 1;
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
