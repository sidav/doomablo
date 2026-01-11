extend class MyCustomHUD {
    // ASI means "active slot item" there

    void DrawPickupableASIInfo(RwActiveSlotItem asi, RwPlayer plr) {
        if (plr.EquippedActiveSlotItem == asi) return;

        currentLineHeight = 0;
        
        if (plr.EquippedActiveSlotItem) {
            PrintLineAt(BuildDefaultPickUpHintStr("switch to"),
            defaultLeftStatsPosX, defaultLeftStatsPosY, itemStatsFont,
            DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, Font.CR_Black);
        } else {
            PrintLineAt(BuildDefaultPickUpHintStr("equip"),
            defaultLeftStatsPosX, defaultLeftStatsPosY, itemStatsFont,
            DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, Font.CR_Black);
        }
    
        currentLineHeight += 1;
        printASIStatsTableAt(asi, plr.EquippedActiveSlotItem, defaultLeftStatsPosX, defaultLeftStatsPosY, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT);
    }

    void printASIStatsTableAt(RwActiveSlotItem asi, RwActiveSlotItem fskCmp, int x, int y, int textFlags) {
        statsCollector.CollectStatsFromAffixableItem(asi, fskCmp, 1);
        printAllCollectorLines(x, y, pickupableStatsTableWidth, textFlags);
    }
}