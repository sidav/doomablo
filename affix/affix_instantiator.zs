extend class Affix {

    static Affix GetRandomAffix() {
        let aff = GetRandomAffixInstance();
        return aff;
    }

    private static Affix GetRandomAffixInstance() {
        let index = rnd.Rand(0, RwGlobalVars.GetTotalAffixes()-1);
        switch (index) {
            // Weapon affixes
            case 0: return New('WPrefWorseMinDamage');
            case 1: return New('WPrefBetterMinDamage');
            case 2: return New('WPrefWorseMaxDamage');
            case 3: return New('WPrefBetterMaxDamage');
            case 4: return New('WPrefInaccurate');
            case 5: return New('WPrefPrecise');
            case 6: return New('WPrefBulk');
            case 7: return New('WPrefPuny');
            case 8: return New('WPrefSlow');
            case 9: return New('WPrefFast');
            case 10: return New('WPrefLazy');
            case 11: return New('WPrefQuick');
            case 12: return New('WPrefSmallerExplosion');
            case 13: return New('WPrefBiggerExplosion');
            case 14: return New('WPrefFreeShots');
            // Armor affixes
            case 15: return New('APrefFragile');
            case 16: return New('APrefSturdy');
            case 17: return New('APrefSoft');
            case 18: return New('APrefHard');
            case 19: return New('APrefWorseRepair');
            case 20: return New('APrefBetterRepair');
            default:
                debug.panic("Some affixes are not added to Affix GetRandomAffix() instantiator.");
                return New('Affix');
        }
    }
}
