extend class RwMonsterAffixator {
    string rwbaseName;
    // Needs to be called after generation
    private void finalizeAfterGeneration() {
        if (owner) {
            Affix aff;
            foreach (aff : appliedAffixes) {
                aff.onPutIntoMonsterInventory(owner);

                // Save all the descriptions to string
                if (aff.getDescription() != "") {
                    if (descriptionStr == "") {
                        descriptionStr = aff.GetDescription();
                    } else {
                        descriptionStr = descriptionStr.."   "..aff.GetDescription();
                    }
                }
            }
            GenerateOwnersName();
            attachLight();
            if (appliedAffixes.Size() >= 2) {
                bNOINFIGHTING = true;
            }
            if (appliedAffixes.Size() >= 3) {
                bNOTARGET = true;
            }
        } else {
            debug.panic("Oh noes, finalizing before being given");
        }
    }

    // Needed if the item should be re-generated
    private void RW_Reset() {
        appliedAffixes.Clear();
        nameWithAppliedAffixes = rwBaseName;
    }

    virtual string GetRandomFluffName() {
        return "NONE";
    }
}