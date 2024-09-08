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
            // Weapon affixes
            case 0: return New('PrefWeak');
            case 1: return New('PrefStrong');
            case 2: return New('PrefInaccurate');
            case 3: return New('PrefPrecise');
            case 4: return New('PrefBulk');
            case 5: return New('PrefPuny');
            case 6: return New('PrefSlow');
            case 7: return New('PrefFast');
            case 8: return New('PrefLazy');
            case 9: return New('PrefQuick');
            case 10: return New('PrefSmallerExplosion');
            case 11: return New('PrefBiggerExplosion');
            // Armor affixes
            case 12: return New('APrefFragile');
            case 13: return New('APrefSturdy');
            case 14: return New('APrefSoft');
            case 15: return New('APrefHard');
            case 16: return New('APrefWorseRepair');
            case 17: return New('APrefBetterRepair');
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
        debug.panicUnimplemented(self);
        return false;
    }

    virtual void ApplyEffectToItem(Inventory item) {
        if (RandomizedWeapon(item) != null) {
            applyEffectToRw(RandomizedWeapon(item));
            return;
        }
        if (RandomizedArmor(item) != null) {
            applyEffectToArmor(RandomizedArmor(item));
            return;
        }
    }

    protected virtual void applyEffectToRw(RandomizedWeapon weapon) {
        debug.panicUnimplemented(self);
    }

    protected virtual void applyEffectToArmor(RandomizedArmor armor) {
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
