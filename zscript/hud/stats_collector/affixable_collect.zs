extend class RwHudArtifactStatsCollector {
    void addHeaderLinesForAffixable(Inventory item, int lines) {
        int itemLvl = 0;
        int itemRarity = 0;
        string itemFullAffixedName = "Unknown Item";
        string itemBaseName = "Unknown class "..item.GetClassName();

        if (RwWeapon(item)) {
            let wpn = RwWeapon(item);
            itemLvl = wpn.generatedQuality;
            itemRarity = wpn.GetRarity();
            itemFullAffixedName = wpn.nameWithAppliedAffixes;
            itemBaseName = wpn.rwBaseName;
        } else if (RwArmor(item)) {
            let armr = RwArmor(item);
            itemLvl = armr.generatedQuality;
            itemRarity = armr.GetRarity();
            itemFullAffixedName = armr.nameWithAppliedAffixes;
            itemBaseName = armr.rwBaseName;
        } else if (RwBackpack(item)) {
            let bkpk = RwBackpack(item);
            itemLvl = bkpk.generatedQuality;
            itemRarity = bkpk.GetRarity();
            itemFullAffixedName = bkpk.nameWithAppliedAffixes;
            itemBaseName = bkpk.rwBaseName;
        } else if (RwFlask(item)) {
            let fsk = RwFlask(item);
            itemLvl = fsk.generatedQuality;
            itemRarity = fsk.GetRarity();
            itemFullAffixedName = fsk.nameWithAppliedAffixes;
            itemBaseName = fsk.rwBaseName;
        } else if (RwTurretItem(item)) {
            let trt = RwTurretItem(item);
            itemLvl = trt.generatedQuality;
            itemRarity = trt.GetRarity();
            itemFullAffixedName = trt.nameWithAppliedAffixes;
            itemBaseName = trt.rwBaseName;
        }

        if (lines == 2) {
            addTitleLine(itemFullAffixedName, pickColorForRarity(itemRarity));
            addSimpleLine("Level "..itemLvl.." "..getRarityName(itemRarity).." "..itemBaseName,
                pickColorForRarity(itemRarity));
            return;
        }
        addTitleLine("LVL "..itemLvl.." "..itemFullAffixedName.." ("..getRarityName(itemRarity)..")", pickColorForRarity(itemRarity));
    }

    static int pickColorForRarity(int rarity) {
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

    void addAffixDescriptionLine(Affix aff) {

        let clr = Font.CR_OLIVE;
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

        string label = "* ";
        if (RwSettingsShowAffixNamesInTables) {
            label = label..aff.getName()..": ";
        }
        label = label..aff.getDescription();

        let newLine = new('RwHudStatLine');
        newLine.mainLabel = label;
        newLine.mainColor = clr;
        newLine.isAffixLine = true;
        statLines.push(newLine);
    }
}