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
        let index = rnd.randn(totalWeaponAffixesClasses());
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
            case 15: return New('WPrefSmallerMag');
            case 16: return New('WPrefBiggerMag');
            case 17: return New('WPrefSlowerReload');
            case 18: return New('WPrefFasterReload');
            case 19: return New('WPrefTargetKickback');
            case 20: return New('WPrefBiggerShooterKickback');
            case 21: return New('WPrefSmallerShooterKickback');
            case 22: return New('WPrefBiggerRecoil');
            case 23: return New('WPrefSmallerRecoil');
            // Suffixes
            case 24: return New('WSuffVampiric');
            case 25: return New('WSuffPoison');
            case 26: return New('WSuffMinirockets');
            case 27: return New('WSuffFlechettes');

            default:
                debug.panic("Some affixes are not added to GetRandomWeaponAffixInstance() instantiator.");
                return New('Affix');
        }
    }

    private static Affix GetRandomArmorAffixInstance() {
        let index = rnd.randn(totalArmorAffixesClasses());
        switch (index) {
            // Armor affixes
            case 0: return New('APrefFragile');
            case 1: return New('APrefSturdy');
            case 2: return New('APrefSoft');
            case 3: return New('APrefHard');
            case 4: return New('APrefWorseRepair');
            case 5: return New('APrefBetterRepair');
            case 6: return New('APrefDamageIncrease');
            case 7: return New('APrefDamageReduction');
            // Suffixes
            case 8: return New('ASuffSelfrepair');
            case 9: return New('ASuffDegrading');
            case 10: return New('ASuffHealing');
            default:
                debug.panic("Some affixes are not added to Affix GetRandomArmorAffixInstance() instantiator.");
                return New('Affix');
        }
    }

    static int totalAffixesClasses() {
        let handler = AffixCountHandler(StaticEventHandler.Find('AffixCountHandler'));
        return handler.totalAffixesClasses;
    }

    static int totalWeaponAffixesClasses() {
        let handler = AffixCountHandler(StaticEventHandler.Find('AffixCountHandler'));
        return handler.totalWeaponAffixesClasses;
    }

    static int totalArmorAffixesClasses() {
        let handler = AffixCountHandler(StaticEventHandler.Find('AffixCountHandler'));
        return handler.totalArmorAffixesClasses;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////
// This handler is used on game init in order to count total affixes' number (needed for random selection).
class AffixCountHandler : StaticEventHandler
{
    int totalAffixesClasses;
    int totalWeaponAffixesClasses;
    int totalArmorAffixesClasses;

	override void OnRegister() {
        countAffixesClasses();
        countWeaponAffixes();
        countArmorAffixes();

        // Check consistency
        let diff = totalAffixesClasses - (totalWeaponAffixesClasses + totalArmorAffixesClasses);
        if (diff == 0) {
            debug.print("RW_ACH consistency check OK.");
        } else {
            debug.panic(
                "RW_ACH affixes count inconsistency: have "..diff.." unaccounted affix classes."
            );
        }
	}

    void countAffixesClasses() {
        totalAffixesClasses = 0;
        foreach (cls : AllClasses)  {
            let ba = (class<Affix>)(cls);
            if (ba && ba != 'Affix' && ba != 'RwWeaponPrefix' && ba != 'RwWeaponSuffix' && ba != 'RwArmorPrefix' && ba != 'RwArmorSuffix') {
                totalAffixesClasses++;
            }
        }
        let t = CVar.GetCVar('totalAffixesClasses', null);
        t.SetInt(totalAffixesClasses);
        debug.print("RW_ACH: Found "..totalAffixesClasses.." affix classes.");
    }

    void countWeaponAffixes() {
        totalWeaponAffixesClasses = 0;
        foreach (cls : AllClasses)  {
            let asWPref = (class<RwWeaponPrefix>)(cls);
            let asWSuff = (class<RwWeaponSuffix>)(cls);
            if (asWPref && asWPref != 'RwWeaponPrefix' || asWSuff && asWSuff != 'RwWeaponSuffix') {
                totalWeaponAffixesClasses++;
            }
        }
        debug.print("RW_ACH: Found "..totalWeaponAffixesClasses.." weapon affix classes.");
    }

    void countArmorAffixes() {
        totalArmorAffixesClasses = 0;
        foreach (cls : AllClasses)  {
            let asAPref = (class<RwArmorPrefix>)(cls);
            let asASuff = (class<RwArmorSuffix>)(cls);
            if (asAPref && asAPref != 'RwArmorPrefix' || asASuff && asASuff != 'RwArmorSuffix') {
                totalArmorAffixesClasses++;
            }
        }
        debug.print("RW_ACH: Found "..totalArmorAffixesClasses.." armor affix classes.");
    }
}
