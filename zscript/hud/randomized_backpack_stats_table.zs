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

        statsCollector.CollectStatsFromAffixableItem(bkpk, bkpkCmp);
        printAllCollectorLines(linesX, y, pickupableStatsTableWidth, textFlags);
    }
}