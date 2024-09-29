mixin class Affixable {

    array <Affix> appliedAffixes;
    int generatedQuality;
    string nameWithAppliedAffixes;

    // Rarity is equal to number of affixes, affixQuality defines their min/max generated values.
    void Generate(int rarity, int affixQuality) {

        RW_Reset(); // Just in case; events order is unclear so let's clear once more
        generatedQuality = affixQuality;

        int qgoodmin, qgoodmax;
        [qgoodmin, qgoodmax] = goodAffixSpreadForQuality(affixQuality);
        int qbadmin, qbadmax;
        [qbadmin, qbadmax] = badAffixSpreadForQuality(affixQuality);

        array <int> affQualities;
        rnd.fillArrWithRandsInTwoRanges(affQualities, 
            qgoodmin, qgoodmax,
            qbadmin, qbadmax,
            rarity, minGoodAffixesForRarity(rarity), 0);
        // debug.print(
        //     "Generated qualities for "..GetClassName()
        //     .." at rarity "..rarity.." and quality "..affixQuality..": "
        //     ..debug.intArrToString(affQualities)
        // );

        AssignRandomAffixesByAffQualityArr(affQualities);
        setNameAfterGeneration();
    }

    int, int goodAffixSpreadForQuality(int quality) {
        if (quality < 5) {
            return 1, 5;
        }
        return quality/2, quality;
    }

    int, int badAffixSpreadForQuality(int quality) {
        if (quality < 5) {
            return -1, -5;
        }
        return -quality, -quality/2;
    }

    private static int minGoodAffixesForRarity(int rarity) {
        switch (rarity) {
            case 0: return 0;
            case 1: return 1;
            case 2: return 1;
            case 3: return 2;
            case 4: return 2;
            case 5: return 3;
        }
        debug.panic("Rarity "..rarity.." not found");
        return 0;
    }

    const ASSIGN_TRIES = 1000;
    private void AssignRandomAffixesByAffQualityArr(array <int> affQualities) {
        for (int i = 0; i < affQualities.Size(); i++) {
            Affix newAffix;
            let try = 0;
            do {
                if (try >= ASSIGN_TRIES) {
                    debug.print("ERROR: Failed to find good affix. Found "..appliedAffixes.Size().." out of "..affQualities.Size().." total.");
                    debug.print("Applied affixes:");
                    Affix a;
                    foreach(a : appliedAffixes) {
                        debug.print("  "..a.getName());
                    }
                    debug.panic();
                }
                try++;
                newAffix = Affix.GetRandomAffixFor(self);
            } until (
                newAffix.getAlignment() == math.sign(affQualities[i]) &&
                newAffix.IsCompatibleWithItem(self) &&
                newAffix.IsCompatibleWithListOfAffixes(appliedAffixes)
            );
            appliedAffixes.push(newAffix);
        }
        // Apply them in reverse order on purpose
        for (int i = appliedAffixes.Size() - 1; i >= 0; i--) {
            appliedAffixes[i].InitAndApplyEffectToItem(self, math.abs(affQualities[i]));
        }
    }

    Affix findAppliedAffix(class <Affix> affcls) {
        foreach (aff : appliedAffixes) {
            if (aff is affcls) {
                return aff;
            }
        }
        return null;
    }

    /////////////////////////
    ///  NAME GENERATION  ///
    /////////////////////////
    void setNameAfterGeneration() {
        switch (appliedAffixes.Size()) {
            case 0: // fallthrough
            case 1: // fallthrough
            case 2:
                nameWithAppliedAffixes = nameRar012Item();
                return;
            case 3:
                nameWithAppliedAffixes = NameGenerator.createXYAZName(
                    appliedAffixes[0].getName(),
                    appliedAffixes[1].getName(),
                    rwBaseName,
                    appliedAffixes[2].getName()
                );
                return;
            case 4:
                nameWithAppliedAffixes = NameGenerator.createFluffedName(getRandomFluffName());
                return;
            case 5:
                nameWithAppliedAffixes = NameGenerator.createAngelicOrDemonicName(rwBaseName);
                return;
        }
        nameWithAppliedAffixes = "<NAME ERROR>";
    }

    string nameRar012Item() {
        string setName = rwBaseName;
        for (int i = appliedAffixes.Size() - 1; i >= 0; i--) {
            let aff = appliedAffixes[i];
            if (aff.isSuffix()) {
                setName = setName.." of "..aff.getName();
            } else {
                setName = aff.getName().." "..setName;
            }
        }

        return setName;
    }
}