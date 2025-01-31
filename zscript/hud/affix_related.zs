extend class MyCustomHUD {

    void printAffixDescriptionLineAt(Affix aff, int x, int y, int textFlags) {

        let clr = Font.CR_White;
        if (aff.isSuffix()) {
            if (aff.getAlignment() > 0) {
                clr = Font.CR_TEAL;
            } else if (aff.getAlignment() < 0) {
                clr = Font.CR_CREAM;
            }
        } else {
            if (aff.getAlignment() > 0) {
                clr = Font.CR_GREEN;
            } else if (aff.getAlignment() < 0) {
                clr = Font.CR_RED;
            }
        }

        if (RwSettingsShowAffixNamesInTables) {
            PrintLineAt("* "..aff.getName()..": "..aff.getDescription(),
                        x, y, itemStatsFont, textFlags, clr);
        } else {
            PrintLineAt("* "..aff.getDescription(),
                        x, y, itemStatsFont, textFlags, clr);
        }
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

    static int PickColorForAffixableItem(Inventory i) {
        int rarity = -1;
        if (i is 'RandomizedWeapon') {
            rarity = RandomizedWeapon(i).appliedAffixes.Size();
        } else if (i is 'RandomizedArmor') {
            rarity = RandomizedArmor(i).appliedAffixes.Size();
        } else if (i is 'RwBackpack') {
            rarity = RwBackpack(i).appliedAffixes.Size();
        } else if (i is 'RwMonsterAffixator') {
            rarity = RwMonsterAffixator(i).appliedAffixes.Size();
        }
        if (rarity == -1) {
            debug.panic("Unknown affixable item to pick color for: "..i.GetClassName());
        }
        switch (rarity) {
            case 0: return Font.CR_WHITE;
            case 1: return Font.CR_GREEN;
            case 2: return Font.CR_BLUE;
            case 3: return Font.CR_PURPLE;
            case 4: return Font.CR_ORANGE;
            case 5: return Font.CR_CYAN;
            default: return Font.CR_Black;
        }
    }

}