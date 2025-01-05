// Suffixes are unique things gameplay-wise, so they require this separate definition.
// TODO: optimization of this logic...

extend class RandomizedArmor {

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
            // TODO: Define this logic in "Thorns" affix code, not here
            let aff = findAppliedAffix('ASuffThorns');
            if (aff != null && rnd.PercentChance(aff.modifierLevel)) {
                let thornDamage = max(1, math.getIntPercentage(damage, aff.stat2));
                source.damageMobj(null, owner, thornDamage, 'Normal', DMG_NO_PROTECT);
            }

            // TODO: Define this logic in "Holy" affix code, not here
            if (stats.currDurability > 0) {
                aff = findAppliedAffix('ASuffHoly');
                if (aff != null) {
                    RwMonsterAffixator monAffixator = RwMonsterAffixator.GetMonsterAffixator(source);
                    // Epic monsters and higher
                    if (monAffixator != null && monAffixator.GetRarity() >= 3) {
                        damage = max(1, math.getIntPercentage(damage, 100 - aff.modifierLevel));
                    }
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
