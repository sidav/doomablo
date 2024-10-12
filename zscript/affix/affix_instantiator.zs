extend class Affix {

    static Affix GetRandomAffixFor(Inventory item) {
        if (item is 'RandomizedWeapon') {
            return GetRandomWeaponAffixInstance();
        } 
        if (item is 'RandomizedArmor') {
            return GetRandomArmorAffixInstance();
        }
        debug.panic("Unknown class to give affix for: "..item.GetClassName());
        return null;
    }

    private static Affix GetRandomWeaponAffixInstance() {
        let handler = AffixClassesCacheHandler(StaticEventHandler.Find('AffixClassesCacheHandler'));
        let index = rnd.randn(handler.totalWeaponAffixesClasses);

        Affix affToReturn;
        foreach (affClass : handler.applicableAffixClasses) {
            if ((affClass is 'RwWeaponPrefix') || (affClass is 'RwWeaponSuffix')) {
                if (index > 0) {
                    index--;
                } else {
                    affToReturn = Affix(New(affClass));
                    break;
                }
            }
        }
        return affToReturn;
    }

    private static Affix GetRandomArmorAffixInstance() {
        let handler = AffixClassesCacheHandler(StaticEventHandler.Find('AffixClassesCacheHandler'));
        let index = rnd.randn(handler.totalArmorAffixesClasses);

        Affix affToReturn;
        foreach (affClass : handler.applicableAffixClasses) {
            if ((affClass is 'RwArmorPrefix') || (affClass is 'RwArmorSuffix')) {
                if (index > 0) {
                    index--;
                } else {
                    affToReturn = Affix(New(affClass));
                    break;
                }
            }
        }
        return affToReturn;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////
// This handler is used on game init in order to cache all the affixes' classes existing (needed for random selection).
class AffixClassesCacheHandler : StaticEventHandler
{
    array< Class<Affix> > applicableAffixClasses;
    int totalAffixesClasses;

    int totalUnknownAffixesClasses;
    int totalWeaponAffixesClasses;
    int totalArmorAffixesClasses;

	override void OnRegister() {
        debug.print("===== RW_ACCH REPORT BEGIN =====");
        // Output superclasses for debug purposes
        debug.print("  --- AFFIX SUPERCLASSES:");
        foreach (cls : AllClasses)  {
            let affClass = (class<Affix>)(cls);
            if (affClass && isAffixASuperclass(affClass)) {
                debug.print("   |- "..affClass.GetClassName());
            }
        }

        debug.print("  --- AFFIX SUBCLASSES:");
        foreach (cls : AllClasses)  {

            string specifyStr;
            let affClass = (class<Affix>)(cls);

            if (affClass && !isAffixASuperclass(affClass)) {

                if (isAffixForWeapon(affClass)) {
                    specifyStr = "(weapon affix)";
                    totalWeaponAffixesClasses++;
                } else if (isAffixForArmor(affClass)) {
                    specifyStr = "(armor affix)";
                    totalArmorAffixesClasses++;
                } else {
                    specifyStr = "(!! unknown !!)";
                    totalUnknownAffixesClasses++;
                }

                debug.print("   |- "..affClass.GetClassName().." "..specifyStr);
                applicableAffixClasses.push(affClass);
                totalAffixesClasses++;
            }
        }

        debug.print("===== RW_ACCH REPORT SUMMARY =====");
        debug.print("   Non-superclass affix classes found total: "..applicableAffixClasses.Size());
        debug.print("   From them:");
        debug.print("             "..totalWeaponAffixesClasses.." for weapons");
        debug.print("             "..totalArmorAffixesClasses.." for armor");
        debug.print("             "..totalUnknownAffixesClasses.." unknown");

        debug.print("===== RW_ACCH REPORT END =====");
        if (totalUnknownAffixesClasses > 0) {
            debug.panic("At least one unknown affix class found. Check the instantiator.");
        }
	}

    static bool isAffixASuperclass(class<Affix> cls) {
        return (cls == 'Affix') 
            || (cls == 'RwWeaponPrefix') || (cls == 'RwWeaponSuffix')
            || (cls == 'RwArmorPrefix') || (cls == 'RwArmorSuffix');
    }

    static bool isAffixForWeapon(class<Affix> cls) {
        return (cls is 'RwWeaponPrefix') || (cls is 'RwWeaponSuffix');
    }

    static bool isAffixForArmor(class<Affix> cls) {
        return (cls is 'RwArmorPrefix') || (cls is 'RwArmorSuffix');
    }
}
