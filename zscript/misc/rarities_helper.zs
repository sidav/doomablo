class RaritiesHelper {
    
    static string getRarityName(int rarity) {
        switch (rarity) {
            case 0: return "Common";
            case 1: return "Uncommon";
            case 2: return "Rare";
            case 3: return "Epic";
            case 4: return "Legendary";
            case 5: return "Mythic";
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
            default: return Font.CR_Black;
        }
    }

    static string getRarityColorCode(int rarity) {
        switch (rarity) {
            case 0: return "\cc";
            case 1: return "\cd";
            case 2: return "\cy";
            case 3: return "\ct";
            case 4: return "\ci";
            case 5: return "\cv";
            default: return "\cm";
        }
    }
}