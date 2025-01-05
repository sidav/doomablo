// Suffixes are unique things gameplay-wise, so they require this separate definition.
// TODO: optimization of this logic...

extend class RandomizedArmor {

    const ThornsReturnedPercentage = 25;

    override void DoEffect() {
        let age = GetAge();

        Affix aff;
        foreach (aff : appliedAffixes) {
            aff.onDoEffect(owner, self);
        }
    }

    int absorptionFractionAccum;
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
        let damageToArmor = math.AccumulatedFixedPointAdd(0, 
            damage * stats.AbsorbsPercentage,
            100, absorptionFractionAccum);
        if (damageToArmor > stats.currDurability) {
            damageToArmor = stats.currDurability;
        }
        DoDamageToArmor(damageToArmor);
        newdamage = damage - damageToArmor;
    }

}
