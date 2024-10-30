extend class MyCustomHUD {

    void DrawPickupableBackpackInfo(RWBackpack bkpk, RwPlayer plr) {
        if (plr.CurrentEquippedBackpack == bkpk) return;

        currentLineHeight = 0;
        
        if (plr.CurrentEquippedArmor) {
            PrintLineAt(BuildDefaultPickUpHintStr("switch to"),
            defaultLeftStatsPosX, defaultLeftStatsPosY, itemStatsFont,
            DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, Font.CR_Black);
        } else {
            PrintLineAt(BuildDefaultPickUpHintStr("equip"),
            defaultLeftStatsPosX, defaultLeftStatsPosY, itemStatsFont,
            DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, Font.CR_Black);
        }
    
        currentLineHeight += 1;
        printBackpackStatsTableAt(bkpk, plr.CurrentEquippedBackpack, defaultLeftStatsPosX, defaultLeftStatsPosY, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT);
    }

    void printBackpackStatsTableAt(RWBackpack bkpk, RWBackpack bkpkCmp, int x, int y, int textFlags) {
        let linesX = x+8;
        string compareStr = "";
        let compareClr = Font.CR_White;

        PrintTableLineAt(
            "LVL "..bkpk.generatedQuality.." "..bkpk.nameWithAppliedAffixes, "("..getRarityName(bkpk.appliedAffixes.Size())..")",
            x, y, pickupableStatsTableWidth,
            itemNameFont, textFlags, PickColorForAffixableItem(bkpk)
        );

        if (bkpkCmp && bkpk.stats.maxBull != bkpkCmp.stats.maxBull) {
            compareStr = " ("..intToSignedStr(bkpk.stats.maxBull - bkpkCmp.stats.maxBull)..")";
            compareClr = GetDifferenceColor(bkpk.stats.maxBull - bkpkCmp.stats.maxBull);
        } else {
            compareStr = "";
            compareClr = Font.CR_White;
        }
        PrintTableLineAt("Max bullets:", bkpk.stats.maxBull..compareStr,
                    linesX, y, pickupableStatsTableWidth,
                    itemStatsFont, textFlags, Font.CR_White, compareClr);

        // SHELLS
        if (bkpkCmp && bkpk.stats.maxShel != bkpkCmp.stats.maxShel) {
            compareStr = " ("..intToSignedStr(bkpk.stats.maxShel - bkpkCmp.stats.maxShel)..")";
            compareClr = GetDifferenceColor(bkpk.stats.maxShel - bkpkCmp.stats.maxShel);
        } else {
            compareStr = "";
            compareClr = Font.CR_White;
        }
        PrintTableLineAt("Max shells:", bkpk.stats.maxShel..compareStr,
                    linesX, y, pickupableStatsTableWidth,
                    itemStatsFont, textFlags, Font.CR_White, compareClr);

        // ROCKETS
        if (bkpkCmp && bkpk.stats.maxRckt != bkpkCmp.stats.maxRckt) {
            compareStr = " ("..intToSignedStr(bkpk.stats.maxRckt - bkpkCmp.stats.maxRckt)..")";
            compareClr = GetDifferenceColor(bkpk.stats.maxRckt - bkpkCmp.stats.maxRckt);
        } else {
            compareStr = "";
            compareClr = Font.CR_White;
        }
        PrintTableLineAt("Max Rockets:", bkpk.stats.maxRckt..compareStr,
                    linesX, y, pickupableStatsTableWidth,
                    itemStatsFont, textFlags, Font.CR_White, compareClr);

        // CELLS
        if (bkpkCmp && bkpk.stats.maxCell != bkpkCmp.stats.maxCell) {
            compareStr = " ("..intToSignedStr(bkpk.stats.maxCell - bkpkCmp.stats.maxCell)..")";
            compareClr = GetDifferenceColor(bkpk.stats.maxCell - bkpkCmp.stats.maxCell);
        } else {
            compareStr = "";
            compareClr = Font.CR_White;
        }
        PrintTableLineAt("Max Cells:", bkpk.stats.maxCell..compareStr,
                    linesX, y, pickupableStatsTableWidth,
                    itemStatsFont, textFlags, Font.CR_White, compareClr);

        foreach (aff : bkpk.appliedAffixes) {
            printAffixDescriptionLineAt(aff, x+16, y, textFlags);
        }
    }
}