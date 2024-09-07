class Affix {

    int modifierLevel;

    static Affix GetAndInitRandomAffix() {
        let aff = GetRandomAffixInstance();
        aff.init();
        return aff;
    }

    private static Affix GetRandomAffixInstance() {
        let index = rnd.Rand(0, RwGlobalVars.GetTotalAffixes()-1);
        switch (index) {
            case 0: return New('PrefWeak');
            case 1: return New('PrefStrong');
            case 2: return New('PrefInaccurate');
            case 3: return New('PrefPrecise');
            case 4: return New('PrefBulk');
            case 5: return New('PrefPuny');
            case 6: return New('PrefSlow');
            case 7: return New('PrefFast');
            default:
                debug.panic("Some affixes are not added to Affix GetRandomAffix() instantiator.");
                return New('Affix');
        }
    }

    bool IsCompatibleWithListOfAffixes(array <Affix> list) {
        foreach (aff : list) {
            if (!isCompatibleWithAff(aff)) {
                return false;
            }
        }
        return true;
    }

    private virtual void init() {}

    virtual bool IsCompatibleWithAff(Affix a2) {
        return a2.GetClass() != GetClass() && isCompatibleWithAffClass(a2);
    }

    // This SHOULD be overridden in descendants.
    protected virtual bool isCompatibleWithAffClass(Affix a2) {
        debug.panicUnimplemented(self);
        return false;
    }

    virtual bool IsCompatibleWithItem(Inventory item) {
        return RandomizedWeapon(item) != null;
    }

    virtual void ApplyEffectToItem(Inventory item) {
        applyEffectToRw(RandomizedWeapon(item));
    }

    // This SHOULD be overridden in descendants.
    protected virtual void applyEffectToRw(RandomizedWeapon weapon) {
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

class Suffix : Affix {}
