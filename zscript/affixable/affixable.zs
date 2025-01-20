mixin class Affixable {

    array <Affix> appliedAffixes;
    int generatedQuality;
    string nameWithAppliedAffixes;
    RarityIndicator attachedRarityIndicator;

    // Rarity is equal to number of affixes, affixQuality defines their min/max generated values.
    void Generate(int rarity, int affixQuality) {

        RW_Reset(); // Just in case; events order is unclear so let's clear once more
        generatedQuality = affixQuality;

        prepareForGeneration(); // this method is unique to each item type; may be empty

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

        AssignRandomAffixesByAffQualityArr(affQualities, rarity);
        setNameAfterGeneration();
        attachRarityIndicatorIfNone();
        finalizeAfterGeneration();
    }

    // Determines the actual levels of applied "good" affixes. For lvl50 item, its affixes are not neccessarily lvl50
    // But are in some range. This time it's (quality-10, quality); before it was quality/2, quality (too high spread was actual before scaling implementation).
    const goodAffixLevelSpread = 10;
    int, int goodAffixSpreadForQuality(int quality) {
        return max(quality - goodAffixLevelSpread, 1), max(quality, 2);
    }

    // The same, but for "bad" affixes.
    const badAffixLevelSpread = 10;
    int, int badAffixSpreadForQuality(int quality) {
        return min(-quality, -2), min(-(quality - badAffixLevelSpread), -1);
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
    private void AssignRandomAffixesByAffQualityArr(array <int> affQualities, int itemRarity) {
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
                    debug.print("Arguments: affQualities "..debug.intArrToString(affQualities).."; rarity "..itemRarity);
                    debug.print("Current quality is "..i.."th, value "..affQualities[i]);
                    debug.panic();
                }
                try++;
                newAffix = Affix.GetRandomAffixFor(self);
                // debug.print("Checking "..newAffix.GetClassName());
            } until (
                // (newAffix.GetClass() == 'ASuffHealthToDurab' || (rnd.randn(4000) == 0)) &&  // Uncomment for specific affix testing
                ((newAffix.getAlignment() == 0) || (newAffix.getAlignment() == math.sign(affQualities[i]))) &&
                newAffix.isEnabled() &&
                newAffix.IsCompatibleWithItem(self) &&
                newAffix.IsCompatibleWithListOfAffixes(appliedAffixes) &&
                newAffix.minRequiredRarity() <= itemRarity
            );
            appliedAffixes.push(newAffix);
        }
        // If there are suffixes, move them to the front of the list
        int currSuffIndex = 0;
        for (int i = 1; i < appliedAffixes.Size(); i++) {
            if (appliedAffixes[i].isSuffix()) {
                let t = appliedAffixes[currSuffIndex];
                appliedAffixes[currSuffIndex] = appliedAffixes[i];
                appliedAffixes[i] = t;
                currSuffIndex++;
            }
        }
        // Apply them in reverse order on purpose (so that the name generation will have correct affix order)
        for (int i = appliedAffixes.Size() - 1; i >= 0; i--) {
            // debug.print("Applying affix "..appliedAffixes[i].getName().." of level "..affQualities[i]);
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

    Affix getAppliedSuffix() {
        foreach (aff : appliedAffixes) {
            if (aff.isSuffix()) {
                return aff;
            }
        }
        return null;
    }

    // True if has no negative affixes
    bool isFlawless() {
        foreach (aff : appliedAffixes) {
            if (aff.getAlignment() < 0) {
                return false;
            }
        }
        return true;
    }

    int getRarity() {
        return appliedAffixes.Size();
    }

    /////////////////////////
    ///  NAME GENERATION  ///
    /////////////////////////
    void setNameAfterGeneration() {
        switch (appliedAffixes.Size()) {
            case 0: // fallthrough
            case 1: // fallthrough
            case 2:
                nameWithAppliedAffixes = nameWithAffixNamesAppended();
                break;
            case 3:
                nameWithAppliedAffixes = nameRar3Item();
                break;
            case 4:
                if (isFlawless()) {
                    nameWithAppliedAffixes = NameGenerator.createPossessiveName(getRandomFluffName());
                } else {
                    nameWithAppliedAffixes = NameGenerator.createFluffedName(getRandomFluffName());
                }
                break;
            case 5:
                if (isFlawless()) {
                    nameWithAppliedAffixes = NameGenerator.generateRandomBlessedName(getRandomFluffName());
                } else {
                    nameWithAppliedAffixes = NameGenerator.generateRandomCursedName(getRandomFluffName());
                }
                break;
        }
        if (nameWithAppliedAffixes.Length() == 0) {
            nameWithAppliedAffixes = "<NAME ERROR>";
        } else {
            // Capitalize the name
            nameWithAppliedAffixes = StringsHelper.Capitalize(nameWithAppliedAffixes);
        }
    }

    string nameWithAffixNamesAppended() {
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

    string nameRar3Item() {
        string setName = rwBaseName;
        Affix suffix = getAppliedSuffix();

        if (suffix) {
            return nameWithAffixNamesAppended();
        } else {
            for (int i = appliedAffixes.Size() - 2; i >= 0; i--) {
                let aff = appliedAffixes[i];
                setName = aff.getName().." "..setName;
            }
        }

        return setName.." of "..appliedAffixes[appliedAffixes.Size()-1].getNameAsSuffix();
    }

    void attachRarityIndicatorIfNone() {
        if (attachedRarityIndicator == null) {
            attachedRarityIndicator = RarityIndicator.Attach(self, appliedAffixes.Size());
        }
    }

    override void onDrop(Actor dropper) {
        super.onDrop(dropper);
        attachRarityIndicatorIfNone();
    }
}