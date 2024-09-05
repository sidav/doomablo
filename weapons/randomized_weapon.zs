class RandomizedWeapon : DoomWeapon {

    string rwDescription; // Needed for HUD
    string rwbaseName;
    RWStatsClass stats;

    array <Affix> appliedAffixes;

    virtual void setBaseStats() {
        // Should be overridden
    }

    override void BeginPlay() {
        setBaseStats();
        AssignRandomAffixes();
        SetDescriptionString();
    }

    // override void DoEffect() {
    // }

    void AssignRandomAffixes() {
        let prefixesCount = 1;
        if (rnd.OneChanceFrom(3)) {
            prefixesCount = 2;
        }
        for (int i = 0; i < prefixesCount; i++) {
            Affix newAffix;
            do {
                newAffix = Affix.GetAndInitRandomAffix();
            } until (
                newAffix.IsCompatibleWithItem(self) &&
                newAffix.IsCompatibleWithListOfAffixes(appliedAffixes)
            );

            applyPrefixEffect(newAffix);
            appliedAffixes.push(newAffix);
        }
    }

    void SetDescriptionString() {
        if (stats.Pellets > 1) {
            rwDescription = rwbaseName.." ("..stats.Pellets.."x"..stats.DamageDice.ToString()..")";
        } else {
            rwDescription = rwbaseName.." ("..stats.DamageDice.ToString()..")";
        }
        return;
    }

    // For per-weapon special prefixes application, override this and call super in default case clause.
    private void applyPrefixEffect(Affix aff) {
        aff.ApplyEffectToItem(self);
        // let cls = aff.GetClassName();
        // switch (cls) {
        //     case 'PrefWeak':
        //         rwDamageDice.Mod -= 2;
        //         break;
        //     case 'PrefStrong':
        //         rwDamageDice.Mod += 2;
        //         break;
        //     case 'PrefInaccurate':
        //         rwHorizSpread *= 2;
        //         rwVertSpread *= 1.5;
        //         break;
        //     case 'PrefPrecise':
        //         rwHorizSpread /= 2;
        //         rwVertSpread /= 1.5;
        //         break;
        //     default:
        //         debug.print("Prefix "..cls.." not implemented in RandomizedWeapon");
        //         break;
        // }
        rwbaseName = aff.getName().." "..rwbaseName;
    }

}