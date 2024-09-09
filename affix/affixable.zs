mixin class Affixable {

    const ASSIGN_TRIES = 1000;
    array <Affix> appliedAffixes;

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
                newAffix = Affix.GetRandomAffix();
            } until (
                newAffix.IsCompatibleWithItem(self) &&
                newAffix.IsCompatibleWithListOfAffixes(appliedAffixes)
            );

            appliedAffixes.push(newAffix);
        }
        
        for (int i = appliedAffixes.Size() - 1; i >= 0; i--) {
            applyAffixEffect(appliedAffixes[i]);
        }
    }

    private void applyAffixEffect(Affix aff) {
        aff.InitAndApplyEffectToItem(self);
        rwbaseName = aff.getName().." "..rwbaseName;
    }
}