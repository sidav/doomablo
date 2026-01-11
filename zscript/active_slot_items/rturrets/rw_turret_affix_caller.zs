// This is a special item which is put into sentry inventory
// The item itself is used only for calling turret item's affixes when appropriate
class RwTurretAffixCaller : Inventory {
    int ownerDiedTick; // needed for onOwnerDiedPreviousTick() affix call.
    array <Affix> appliedAffixes;

    static void AffixateTurretWithItem(BaseRwTurretActor turret, RwTurretItem item) {
        let callerInv = turret.GiveInventoryType('RwTurretAffixCaller');
        let caller = RwTurretAffixCaller(callerInv);
        foreach (aff : item.AppliedAffixes) {
            caller.appliedAffixes.Push(aff);
        }
    }

    override void DoEffect() {
        if (owner.Health <= 0) {
            if (owner.GetAge() - ownerDiedTick == 1) {
                Affix aff;
                foreach (aff : appliedAffixes) {
                    if (RwMonsterAffix(aff)) {
                        RwMonsterAffix(aff).onOwnerDiedPreviousTick(owner);
                    }
                }
            }
            return;
        }
        Affix aff;
        foreach (aff : appliedAffixes) {
            aff.onDoEffect(owner);
        }
    }

    override void OwnerDied () {
        ownerDiedTick = owner.GetAge();
        Affix aff;
        foreach (aff : appliedAffixes) {
            aff.onOwnerDied(owner);
        }
    }

    override void ModifyDamage(int damage, Name damageType, out int newdamage, bool passive, Actor inflictor, Actor source, int flags) {
        if (owner.Health <= 0) {
            return;
        }
        if (source == BaseRwTurretActor(owner).Creator) {
            damage = 0;
        }
        // Passive is True if the attack is being received by the owner. False if the attack is being dealt by the owner.
        newdamage = damage;
        Affix aff;
        foreach (aff : appliedAffixes) {
            aff.onModifyDamage(damage, newdamage, passive, inflictor, source, owner, flags);
            damage = newdamage;
        }
    }
}