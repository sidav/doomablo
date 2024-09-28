extend class MyCustomHUD {

    void printAffixDescriptionLine(Affix aff) {

        let clr = Font.CR_White;
        if (aff.getAlignment() > 0) {
            clr = Font.CR_GREEN;
        } else if (aff.getAlignment() < 0) {
            clr = Font.CR_RED;
        }

        PrintLine(" * "..aff.getName()..": "..aff.getDescription(),
                mSmallFont, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT,
                clr);
    }

    string getRarityName(int rarity) {
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

}