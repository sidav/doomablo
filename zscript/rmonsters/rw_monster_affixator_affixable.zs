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

            // After affixes are applied

            // Increase owner's health. It occurs for ALL affixed monsters, analogous to "More Health" affix and stacks with it.
            let minPerc = 125+(appliedAffixes.Size() * 25); // 150% min
            let maxPerc = 250+(appliedAffixes.Size() * 50); // 500% max
            let newHpPercent = math.remapIntRange(generatedQuality, 1, 100, minPerc, maxPerc, true);
            // debug.print("Increasing owner HP from "..owner.health.." by "..newHpPercent.."% via rar/qty "..appliedAffixes.Size().."/"..generatedQuality);
            owner.starthealth = math.getIntPercentage(owner.health, newHpPercent);
            owner.A_SetHealth(owner.starthealth);
            // debug.print("           New HP is "..owner.health);

            
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