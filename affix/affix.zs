class Affix {

    int modifierLevel;

    bool IsCompatibleWithListOfAffixes(out array <Affix> list) {
        foreach (aff : list) {
            if (!isCompatibleWithAff(aff)) {
                return false;
            }
        }
        return true;
    }

    virtual bool IsCompatibleWithAff(Affix a2) {
        return a2.GetClass() != GetClass() && isCompatibleWithAffClass(a2);
    }

    // This SHOULD be overridden in descendants.
    protected virtual bool isCompatibleWithAffClass(Affix a2) {
        debug.panicUnimplemented(self);
        return false;
    }

    virtual bool IsCompatibleWithItem(Inventory item) {
        debug.panicUnimplemented(self);
        return false;
    }

    virtual void InitAndApplyEffectToItem(Inventory item) {
        if (RandomizedWeapon(item) != null) {
            initAndApplyEffectToRWeapon(RandomizedWeapon(item));
            return;
        }
        if (RandomizedArmor(item) != null) {
            initAndapplyEffectToRArmor(RandomizedArmor(item));
            return;
        }
    }

    protected virtual void initAndApplyEffectToRWeapon(RandomizedWeapon weapon) {
        debug.panicUnimplemented(self);
    }

    protected virtual void initAndapplyEffectToRArmor(RandomizedArmor armor) {
        debug.panicUnimplemented(self);
    }

    virtual string getName() {
        debug.panicUnimplemented(self);
        return "";
    }

    virtual string getDescription() {
        debug.panicUnimplemented(self);
        return "";
    }
}
