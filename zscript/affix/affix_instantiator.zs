extend class Affix {

    static Affix GetRandomAffixFor(Inventory item) {
        if (item is 'RandomizedWeapon') {
            return GetRandomWeaponAffixInstance();
        } 
        if (item is 'RandomizedArmor') {
            return GetRandomArmorAffixInstance();
        }
        if (item is 'RwBackpack') {
            return GetRandomBackpackAffixInstance();
        }
        if (item is 'RwFlask') {
            return GetRandomFlaskAffixInstance();
        }
        if (item is 'RwMonsterAffixator') {
            return GetRandomMonsterAffixInstance();
        }
        debug.panic("Unknown class to give affix for: "..item.GetClassName());
        return null;
    }

    private static Affix GetRandomWeaponAffixInstance() {
        let handler = AffixClassesCacheHandler(StaticEventHandler.Find('AffixClassesCacheHandler'));
        let index = rnd.randn(handler.totalWeaponAffixesClasses + handler.totalUniversalAffixesClasses);

        Affix affToReturn;
        foreach (affClass : handler.applicableAffixClasses) {
            if (affClass is 'RwWeaponPrefix' || affClass is 'RwWeaponSuffix' || affClass is 'RwUniversalAffix') {
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
        let index = rnd.randn(handler.totalArmorAffixesClasses + handler.totalUniversalAffixesClasses);

        Affix affToReturn;
        foreach (affClass : handler.applicableAffixClasses) {
            if (affClass is 'RwArmorPrefix' || affClass is 'RwArmorSuffix' || affClass is 'RwUniversalAffix') {
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

    private static Affix GetRandomBackpackAffixInstance() {
        let handler = AffixClassesCacheHandler(StaticEventHandler.Find('AffixClassesCacheHandler'));
        let index = rnd.randn(handler.totalBackpackAffixesClasses + handler.totalUniversalAffixesClasses);

        Affix affToReturn;
        foreach (affClass : handler.applicableAffixClasses) {
            if (affClass is 'RwBackpackPrefix' || affClass is 'RwBackpackSuffix' || affClass is 'RwUniversalAffix') {
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

    private static Affix GetRandomFlaskAffixInstance() {
        let handler = AffixClassesCacheHandler(StaticEventHandler.Find('AffixClassesCacheHandler'));
        let index = rnd.randn(handler.totalFlaskAffixesClasses + handler.totalUniversalAffixesClasses);

        Affix affToReturn;
        foreach (affClass : handler.applicableAffixClasses) {
            if (affClass is 'RwFlaskPrefix' || affClass is 'RwFlaskSuffix' || affClass is 'RwUniversalAffix') {
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

    private static Affix GetRandomMonsterAffixInstance() {
        let handler = AffixClassesCacheHandler(StaticEventHandler.Find('AffixClassesCacheHandler'));
        let index = rnd.randn(handler.totalMonsterAffixesClasses);

        Affix affToReturn;
        foreach (affClass : handler.applicableAffixClasses) {
            if (affClass is 'RwMonsterAffix') {
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
    int totalBackpackAffixesClasses;
    int totalFlaskAffixesClasses;
    int totalUniversalAffixesClasses;
    int totalMonsterAffixesClasses;

	override void OnRegister() {
        debug.print("===== RW_ACCH REPORT BEGIN =====");
        // Output superclasses for debug purposes
        debug.print("  --- AFFIX SUPERCLASSES:");
        foreach (cls : AllClasses)  {
            let affClass = (class<Affix>)(cls);
            if (affClass && affClass.isAbstract()) {
                debug.print("   |- "..affClass.GetClassName());
            }
        }

        // debug.print("  --- AFFIX SUBCLASSES:");
        foreach (cls : AllClasses)  {

            string specifyStr;
            let affClass = (class<Affix>)(cls);

            if (affClass && !affClass.isAbstract()) {

                if (isAffixForWeapon(affClass)) {
                    specifyStr = "(weapon affix)";
                    totalWeaponAffixesClasses++;
                } else if (isAffixForArmor(affClass)) {
                    specifyStr = "(armor affix)";
                    totalArmorAffixesClasses++;
                } else if (isAffixForBackpack(affClass)) {
                    specifyStr = "(backpack affix)";
                    totalBackpackAffixesClasses++;
                } else if (isAffixForBackpack(affClass)) {
                    specifyStr = "(backpack affix)";
                    totalBackpackAffixesClasses++;
                } else if (isAffixForFlask(affClass)) {
                    specifyStr = "(flask affix)";
                    totalFlaskAffixesClasses++;
                } else if (isAffixForMonster(affClass)) {
                    specifyStr = "(monster affix)";
                    totalMonsterAffixesClasses++;
                } else if (isAffixUniversal(affClass)) {
                    specifyStr = "(universal affix)";
                    totalUniversalAffixesClasses++;
                } else {
                    specifyStr = "(!! unknown !!)";
                    totalUnknownAffixesClasses++;
                }

                // debug.print("   |- "..affClass.GetClassName().." "..specifyStr);
                applicableAffixClasses.push(affClass);
                totalAffixesClasses++;
            }
        }

        debug.print("===== RW_ACCH REPORT SUMMARY =====");
        debug.print("   Non-abstract affix classes found total: "..applicableAffixClasses.Size());
        debug.print("   From them:");
        debug.print("             "..totalWeaponAffixesClasses.." for weapons");
        debug.print("             "..totalArmorAffixesClasses.." for armor");
        debug.print("             "..totalBackpackAffixesClasses.." for backpacks");
        debug.print("             "..totalFlaskAffixesClasses.." for flasks");
        debug.print("             "..totalMonsterAffixesClasses.." for monsters");
        debug.print("             "..totalUnknownAffixesClasses.." unknown");

        debug.print("===== RW_ACCH REPORT END =====");
        if (totalUnknownAffixesClasses > 0) {
            debug.panic("At least one unknown affix class found. Check the instantiator.");
        }
	}

    static bool isAffixForWeapon(class<Affix> cls) {
        return (cls is 'RwWeaponPrefix') || (cls is 'RwWeaponSuffix');
    }

    static bool isAffixForArmor(class<Affix> cls) {
        return (cls is 'RwArmorPrefix') || (cls is 'RwArmorSuffix');
    }

    static bool isAffixForBackpack(class<Affix> cls) {
        return (cls is 'RwBackpackPrefix') || (cls is 'RwBackpackSuffix');
    }

    static bool isAffixForFlask(class<Affix> cls) {
        return (cls is 'RwFlaskPrefix') || (cls is 'RwFlaskSuffix');
    }

    static bool isAffixUniversal(class<Affix> cls) {
        return (cls is 'RwUniversalAffix');
    }

    static bool isAffixForMonster(class<Affix> cls) {
        return (cls is 'RwMonsterAffix');
    }
}
