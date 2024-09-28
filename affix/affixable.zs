mixin class Affixable {

    array <Affix> appliedAffixes;
    int generatedQuality;
    string nameWithAppliedAffixes;

    // Rarity is equal to number of affixes, affixQuality defines their min/max generated values.
    void Generate(int rarity = 5, int affixQuality = 100) {
        rarity = rnd.weightedRand(50, 100, 50, 30, 15, 5); // TODO: remove (it works, yet it's temporary)
        affixQuality = rnd.linearWeightedRand(1, 100, 1000, 1); // TODO: remove this too (it works, yet it's temporary)

        RW_Reset();
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
        debug.print("Qualities for rarity "..rarity..": "..debug.intArrToString(affQualities));

        AssignRandomAffixesByAffQualityArr(affQualities);
        applyAffixNames();
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

    private void applyAffixNames() {
        nameWithAppliedAffixes = rwBaseName;

        if (appliedAffixes.Size() == 0) {
            nameWithAppliedAffixes = "Common "..nameWithAppliedAffixes;
            return;
        } else if (appliedAffixes.Size() == 3) {
            nameWithAppliedAffixes = getRandomFluffPrefix(appliedAffixes.Size()).." "..rwBaseName;
            return;
        } else if (appliedAffixes.Size() > 3) {
            nameWithAppliedAffixes = getRandomFluffPrefix(appliedAffixes.Size())..
                " "..rwBaseName..
                " \""..GetRandomFluffName().."\"";
            return;
        }

        for (int i = appliedAffixes.Size() - 1; i >= 0; i--) {
            let aff = appliedAffixes[i];
            if (aff.isSuffix()) {
                nameWithAppliedAffixes = nameWithAppliedAffixes.." ("..aff.getName()..")";
            } else {
                nameWithAppliedAffixes = aff.getName().." "..nameWithAppliedAffixes;
            }
        }
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

    // Affixable classes MUST also implement string GetRandomFluffName() {}
    private string getRandomFluffPrefix(int affCount) {
        static const string aff3[] =
        {
            "Strange",
            "Uncommon",
            "Tinkered"
        };
        static const string aff4[] =
        {
            "Prototype",
            "Experimental",
            "Rare"
        };
        static const string aff5[] =
        {
            "Blessed",
            "Demonic",
            "Holy"
        };
        switch (affCount) {
            case 3:
                return aff3[rnd.Rand(0, aff3.Size()-1)];
                break;
            case 4:
                return aff4[rnd.Rand(0, aff4.Size()-1)];
                break;
            case 5:
                return aff5[rnd.Rand(0, aff5.Size()-1)];
                break;
        }
        debug.panic("Fluff prefix for "..affCount.." affixes not found.");
        return "";
    }
}