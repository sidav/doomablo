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

    // Alignment is -1 for bad affixes and 1 for good ones. Alignment of 0 allows using Affix as any.
    virtual int getAlignment() {
        debug.panicUnimplemented(self);
        return 0;
    }

    virtual int minRequiredRarity() {
        return 0;
    }

    virtual bool IsCompatibleWithItem(Inventory item) {
        debug.panicUnimplemented(self);
        return false;
    }

    virtual void InitAndApplyEffectToItem(Inventory item, int quality) {
        debug.panicUnimplemented(self);
    }

    // Helper method for code readability.
    protected static int remapQualityToRange(int qty, int rmin, int rmax) {
        if (qty <= 0) {
            debug.panic("Negative quality in range mapping");
        }
        return math.remapIntRange(qty, 1, 100, rmin, rmax);
    }

    virtual string getName() {
        debug.panicUnimplemented(self);
        return "";
    }

    // Optional to override. Used only for prefixes when there's no place for (e.g.) third prefix in the name.
    virtual string getNameAsSuffix() {
        return getName().."ness";
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
