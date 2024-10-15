// Suffixes are unique things gameplay-wise, so they require this separate definition.
// TODO: optimization of this logic...

extend class RandomizedArmor {

    // call this inside "DoEffect" method for armor
    action void RWA_DoSuffixEffect() {
        let age = GetAge();

        // First: self-repair
        if (invoker.stats.currDurability < invoker.stats.maxDurability) {
            let aff = invoker.findAppliedAffix('ASuffSelfrepair');
            if (aff != null) {
                if (age % aff.modifierLevel == 0) {
                    invoker.stats.currDurability++;
                }
                return; // There may be no other affix anyway
            }
        }

        // Second: heal the owner
        if (invoker.stats.currDurability > 0 && invoker.owner.health < 100) {
            let aff = invoker.findAppliedAffix('ASuffDurabToHealth');
            if (aff != null) {
                if (age % aff.modifierLevel == 0) {
                    invoker.owner.GiveBody(1, 100);
                    invoker.stats.currDurability--;
                }
                return; // There may be no other affix anyway
            }
        }

        if (invoker.stats.currDurability > 0 && invoker.owner.health < 100) {
            let aff = invoker.findAppliedAffix('ASuffSlowHeal');
            if (aff != null) {
                if (age % aff.modifierLevel == 0) {
                    invoker.owner.GiveBody(1, 125);
                }
                return; // There may be no other affix anyway
            }
        }

        // Loses durability
        if (invoker.stats.currDurability > 0) {
            let aff = invoker.findAppliedAffix('ASuffDegrading');
            if (aff != null) {
                if (age % aff.modifierLevel == 0) {
                    invoker.stats.currDurability--;
                    RandomizedArmor(invoker).lastDamageTick = invoker.GetAge();
                }
                return; // There may be no other affix anyway
            }
        }

        if (invoker.stats.currDurability == 0 && (invoker.ticksSinceDamage() == invoker.stats.delayUntilRecharge)) {
            let aff = invoker.findAppliedAffix('ASuffECellsSpend');
            if (aff != null) {
                let cl = invoker.owner.FindInventory('Cell');
                if (cl && cl.Amount >= aff.modifierLevel) {
                    cl.Amount -= aff.modifierLevel;
                } else {
                    invoker.lastDamageTick += TICRATE; // call this again 1 sec later hehe
                }
                return; // There may be no other affix anyway
            }
        }

        if (invoker.stats.currDurability == 0 && (invoker.ticksSinceDamage() == 1)) {
            let aff = invoker.findAppliedAffix('ASuffEDamageOnEmpty');
            if (aff != null) {
                let ti = ThinkerIterator.Create('Actor');
                Actor mo;
                while (mo = Actor(ti.next())) {
                    let reqDistance = invoker.owner.radius * 10;
                    if (mo && invoker.owner != mo && invoker.owner.Distance2D(mo) <= reqDistance) {
                        mo.damageMobj(null, invoker.owner, aff.modifierLevel, 'Normal', DMG_NO_PROTECT);
                    }
                }
                return; // There may be no other affix anyway
            }
        }

    }

}
