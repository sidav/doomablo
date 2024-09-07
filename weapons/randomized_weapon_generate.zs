extend class RandomizedWeapon {

    void Generate() {
        let prefixesCount = rnd.linearWeightedRand(0, 3, 10, 1);

        // DEBUG: delete the following line when not needed
        // prefixesCount = 3;

        AssignRandomAffixes(prefixesCount);
    }

    private void AssignRandomAffixes(int prefixesCount) {
        
        for (int i = 0; i < prefixesCount; i++) {
            Affix newAffix;
            do {
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

    private void SetDescriptionString() {
        if (stats.Pellets > 1) {
            rwFullName = rwbaseName.." ("..stats.Pellets.."x"..stats.DamageDice.ToString()..")";
        } else {
            rwFullName = rwbaseName.." ("..stats.DamageDice.ToString()..")";
        }
        return;
    }

    private void applyPrefixEffect(Affix aff) {
        aff.ApplyEffectToItem(self);
        rwbaseName = aff.getName().." "..rwbaseName;
    }

}