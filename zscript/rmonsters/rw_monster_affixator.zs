// This is a special item which is put into monster inventory
// The item itself is affixable, not the monster (for ensuring universal compatibility)
class RwMonsterAffixator : Inventory {
    mixin Affixable; // Maybe it's NOT Affixable? The logic is quite different (at least for now)

    string descriptionStr;

    override void DoEffect() {
        if (owner.Health <= 0) {
            return;
        }
        Affix aff;
        foreach (aff : appliedAffixes) {
            aff.onDoEffect(owner);
        }
    }

    override void ModifyDamage(int damage, Name damageType, out int newdamage, bool passive, Actor inflictor, Actor source, int flags) {
        if (owner.Health <= 0) {
            return;
        }
        // debug.print("Owner "..owner.GetClassName()..": damage before "..damage);
        // Passive is True if the attack is being received by the owner. False if the attack is being dealt by the owner.
        if (passive) {
            Affix aff;
            foreach (aff : appliedAffixes) {
                aff.onModifyDamageToOwner(damage, damageType, newdamage, inflictor, source, owner, flags);
            }
        } else {
            Affix aff;
            foreach (aff : appliedAffixes) {
                aff.onModifyDamageDealtByOwner(damage, damageType, newdamage, inflictor, source, owner, flags);
            }
        }
        // debug.print("  Damage after "..newdamage);
    }
}