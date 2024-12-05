extend class RwMonsterAffixator {
    string rwbaseName;

    // Needs to be called before generation
    private void prepareForGeneration() {}

    // Needs to be called after generation
    private void finalizeAfterGeneration() {
        if (owner) {
            Affix aff;
            foreach (aff : appliedAffixes) {
                aff.onPutIntoMonsterInventory(owner);                
            }

            // After affixes are applied

            // Scale owner's health. It occurs for ALL affixed monsters, analogous to "More Health" affix and stacks with it.
            let newHealth = owner.health;
            newHealth = StatsScaler.ScaleIntValueByLevelRandomized(newHealth, generatedQuality); // Level scaling
            // Scale owner's health by its rarity.
            let minPerc = 100 - 10;
            let maxPerc = 100 + 10;
            if (getRarity() > 0) {
                minPerc = 100+((appliedAffixes.Size() - 1) * 25);
                maxPerc = 100+(appliedAffixes.Size() * 25);
            }
            newHealth = Random(math.getIntPercentage(newHealth, minPerc), math.getIntPercentage(newHealth, maxPerc));
            owner.starthealth = newHealth;
            owner.A_SetHealth(newHealth);

            // Old code:
            // let minPerc = 100+(appliedAffixes.Size() * 25); // 150% min
            // let maxPerc = 100+(appliedAffixes.Size() * 80); // 500% max
            // let newHpPercent = math.remapIntRange(generatedQuality, 1, 100, minPerc, maxPerc, true);
            // // debug.print("Increasing owner HP from "..owner.health.." by "..newHpPercent.."% via rar/qty "..appliedAffixes.Size().."/"..generatedQuality);
            // owner.starthealth = math.getIntPercentage(owner.health, newHpPercent);
            // owner.A_SetHealth(owner.starthealth);
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