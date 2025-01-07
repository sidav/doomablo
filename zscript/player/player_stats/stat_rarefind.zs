extend class RwPlayerStats {

    const rareFindCost = 1;
    const maxBaseRareFind = 1000; // Promille

    int baseRareFindChance;

    bool canIncreaseBaseRareFind() {
        return statPointsAvailable >= rareFindCost;
    }

    void doIncreaseBaseRareFind() {
        statPointsAvailable -= rareFindCost;
        baseRareFindChance += 15;
    }

    // The stat effect itself
    int rollForIncreasedRarity(int initialRarity) {
        let chances = baseRareFindChance / (2 ** initialRarity);
        if (Random(0, 1000) < chances) {
            initialRarity += 1;
        }
        return min(initialRarity, 5);
    }

    string getRareFindButtonName() {
        return String.Format("Rare find chance: +%.1f%%", double(baseRareFindChance)/10);
    }

    string getRareFindButtonDescription() {
        double bfc = double(baseRareFindChance)/10.;
        return "Rare Find stat determines your chance to receive an artifact drop of increased rarity.\n"
                .." The effect is twice as small for each next rarity level."
                .."Your current chances for increased rarity are:\n"
                ..String.Format("Uncommon: +%.1f%%\n", bfc)
                ..String.Format("Rare: +%.1f%%\n", bfc/2)
                ..String.Format("Epic: +%.1f%%\n", bfc/4)
                ..String.Format("Legendary: +%.1f%%\n", bfc/8)
                ..String.Format("Mythic: +%.1f%%\n", bfc/16);
    }
}