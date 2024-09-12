mixin class Affixable {

    const ASSIGN_TRIES = 1000;
    array <Affix> appliedAffixes;
    string nameWithAppliedAffixes;

    private void AssignRandomAffixes(int prefixesCount) {
        for (int i = 0; i < prefixesCount; i++) {
            Affix newAffix;
            let try = 0;
            do {
                if (try >= ASSIGN_TRIES) {
                    debug.panic("Failed to find good affix. Found "..appliedAffixes.Size().." out of "..prefixesCount.." total.");
                } else {
                    try++;
                }
                newAffix = Affix.GetRandomAffixFor(self);
            } until (
                newAffix.IsCompatibleWithItem(self) &&
                newAffix.IsCompatibleWithListOfAffixes(appliedAffixes)
            );

            appliedAffixes.push(newAffix);
        }
        
        for (int i = appliedAffixes.Size() - 1; i >= 0; i--) {
            appliedAffixes[i].InitAndApplyEffectToItem(self);
        }
        applyAffixNames();
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