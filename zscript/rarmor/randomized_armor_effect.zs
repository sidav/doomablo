// Suffixes are unique things gameplay-wise, so they require this separate definition.
// TODO: optimization of this logic...

extend class RwArmor {

    override void DoEffect() {
        let age = GetAge();

        Affix aff;
        foreach (aff : appliedAffixes) {
            aff.onDoEffect(owner, self);
        }
    }

    int absorptionFractionAccum;
    override void AbsorbDamage(int damage, Name damageType, out int newdamage, Actor inflictor, Actor source, int flags) {
        if (source && damage > 1 && stats.currDurability > 0) {
            foreach (aff : appliedAffixes) {
                aff.onAbsorbDamage(damage, damageType, damage, inflictor, source, owner, flags);
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
