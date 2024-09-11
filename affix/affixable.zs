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
        for (int i = appliedAffixes.Size() - 1; i >= 0; i--) {
            let aff = appliedAffixes[i];
            if (aff.isSuffix()) {
                nameWithAppliedAffixes = nameWithAppliedAffixes.." ("..aff.getName()..")";
            } else {
                nameWithAppliedAffixes = aff.getName().." "..nameWithAppliedAffixes;
            }
        }
        if (appliedAffixes.Size() == 0) {
            nameWithAppliedAffixes = "Common "..nameWithAppliedAffixes;
        }
    }
}