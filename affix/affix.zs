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

    // Alignment is -1 for bad affixes and 1 for good ones.
    virtual int getAlignment() {
        debug.panicUnimplemented(self);
        return 0;
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

    // needed for code readability, nothing more.
    virtual bool isSuffix() {
        return false;
    }

    virtual string getDescription() {
        debug.panicUnimplemented(self);
        return "";
    }
}
