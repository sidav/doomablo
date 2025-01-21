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
        statsCollector.CollectStatsFromAffixableItem(bkpk, bkpkCmp, 1);
        printAllCollectorLines(x, y, pickupableStatsTableWidth, textFlags);
    }
}