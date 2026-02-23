class RaritiesHelper {
    const MAX_RARITY = 6;
    const MAX_NON_UNIQUE_RARITY = 5;
    const UNIQUE_RARITY = 6;
    static string getRarityName(int rarity) {
        switch (rarity) {
            case 0: return "Common";
            case 1: return "Uncommon";
            case 2: return "Rare";
            case 3: return "Epic";
            case 4: return "Legendary";
            case 5: return "Mythic";
            case 6: return "Unique";
        }
        debug.panic("Rarity "..rarity.." not found");
        return "";
    }

    static int getRarityFontColor(int rarity) {
        switch (rarity) {
            case 0: return Font.CR_WHITE;
            case 1: return Font.CR_GREEN;
            case 2: return Font.CR_SAPPHIRE;
            case 3: return Font.CR_PURPLE;
            case 4: return Font.CR_ORANGE;
            case 5: return Font.CR_CYAN;
            case 6: return Font.CR_FIRE;
            default: return Font.CR_Black;
        }
    }

    static Color indicatorColorForRarity(int rarity) {
        switch (rarity) {
            case 0: return 0xFFFFFF;
            case 1: return 0x00FF00;
            case 2: return 0x1111FF;
            case 3: return 0xCC00FF;
            case 4: return 0xFFFF00;
            case 5: return 0x00FFFF;
            case 6: return 0xFF0000;
        }
        return 0xAAAAAA;
    }

    static string getRarityColorCode(int rarity) {
        switch (rarity) {
            case 0: return "\cc";
            case 1: return "\cd";
            case 2: return "\cy";
            case 3: return "\ct";
            case 4: return "\ci";
            case 5: return "\cv";
            case 5: return "\cx";
            default: return "\cm";
        }
    }

    static int totalAffixesForRarity(int rarity) {
        switch (rarity) {
            case 0: return 0;
            case 1: return 1;
            case 2: return 2;
            case 3: return 3;
            case 4: return 4;
            case 5: return 5;
            case 6: return 5;
        }
        debug.panic("Affixable: rarity "..rarity.." not found");
        return 0;
    }

    static int minGoodAffixesForRarity(int rarity) {
        switch (rarity) {
            case 0: return 0;
            case 1: return 1;
            case 2: return 1;
            case 3: return 2;
            case 4: return 2;
            case 5: return 3;
            case 6: return 5;
        }
        debug.panic("Affixable: rarity "..rarity.." not found");
        return 0;
    }

    // Be careful modifying this: it may cause generation failures
    static int minSuffixesForRarity(int rarity) {
        switch (rarity) {
            case 0: return 0;
            case 1: return 0;
            case 2: return 0;
            case 3: return 1;
            case 4: return 1;
            case 5: return 2;
            case 6: return 0;
        }
        debug.panic("Affixable: rarity "..rarity.." not found");
        return 0;
    }

    static int maxSuffixesForRarity(int rarity) {
        switch (rarity) {
            case 0: return 0;
            case 1: return 0;
            case 2: return 0;
            case 3: return 1;
            case 4: return 2;
            case 5: return 3;
            case 6: return 3;
        }
        debug.panic("Affixable: rarity "..rarity.." not found");
        return 0;
    }
}