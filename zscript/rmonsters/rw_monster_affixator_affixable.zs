extend class RwMonsterAffixator {
    string rwbaseName;
    int baseUnscaledOwnerMaxHealth;

    // Needs to be called before generation
    private void prepareForGeneration() {}

    // Needs to be called after generation
    private void finalizeAfterGeneration() {
        if (owner) {
            baseUnscaledOwnerMaxHealth = owner.GetMaxHealth(); // Store unmodified owner health; used for drops deciding

            Affix aff;
            foreach (aff : appliedAffixes) {
                aff.onPutIntoMonsterInventory(owner);                
            }

            // After affixes are applied

            // Scale owner's health. It occurs for ALL affixed monsters (including common ones), analogous to "More Health" affix and stacks with it.
            let newHealth = owner.health;
            newHealth = MonsterStatsScaler.ScaleIntValueByLevelRandomized(newHealth, generatedQuality); // Level scaling
            // Scale owner's health by its rarity.
            int minPerc, maxPerc;
            switch (getRarity()) {
                case 0: // Common
                    minPerc = 95;
                    maxPerc = 110;
                    break;
                case 1: // Uncommon
                    minPerc = 125;
                    maxPerc = 150;
                    break;
                case 2: // Rare
                    minPerc = 150;
                    maxPerc = 200;
                    break;
                case 3: // Epic
                    minPerc = 200;
                    maxPerc = 300;
                    break;
                case 4: // Legendary
                    minPerc = 275;
                    maxPerc = 325;
                    break;
                case 5: // Mythic
                    minPerc = 300;
                    maxPerc = 400;
                    break;
                default:
                    debug.panic("HP scaling: unhandled monster rarity "..getRarity());
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
            if (GetRarity() >= 2) {
                bNOINFIGHTING = true;
            }
            if (GetRarity() >= 3) {
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