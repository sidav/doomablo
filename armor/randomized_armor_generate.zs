extend class RandomizedArmor {
    void Generate() {
        let prefixesCount = rnd.linearWeightedRand(0, 3, 10, 1);

        // DEBUG: delete the following line when not needed
        prefixesCount = 3;

        AssignRandomAffixes(prefixesCount);
        rwFullName = rwbaseName;
    }

    private void AssignRandomAffixes(int prefixesCount) {
        for (int i = 0; i < prefixesCount; i++) {
            Affix newAffix;
            let try = 0;
            do {
                if (try >= 1000) {
                    debug.panic("Failed to find good affix. Found "..appliedAffixes.Size().." out of "..prefixesCount.." total.");
                } else {
                    try++;
                }
                newAffix = Affix.GetAndInitRandomAffix();
            } until (
                newAffix.IsCompatibleWithItem(self) &&
                newAffix.IsCompatibleWithListOfAffixes(appliedAffixes)
            );

            appliedAffixes.push(newAffix);
        }
        
        for (int i = appliedAffixes.Size() - 1; i >= 0; i--) {
            applyPrefixEffect(appliedAffixes[i]);
        }
    }

    private void applyPrefixEffect(Affix aff) {
        aff.ApplyEffectToItem(self);
        rwbaseName = aff.getName().." "..rwbaseName;
    }
}