extend class MyCustomHUD {

    void DrawPickupableRelicInfo(RwRelic asi, RwPlayer plr) {
        if (plr.EquippedRelic == asi) return;

        currentLineHeight = 0;
        
        if (plr.EquippedRelic) {
            PrintLineAt(BuildDefaultPickUpHintStr("switch to"),
            defaultLeftStatsPosX, defaultLeftStatsPosY, itemStatsFont,
            DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, Font.CR_Black);
        } else {
            PrintLineAt(BuildDefaultPickUpHintStr("equip"),
            defaultLeftStatsPosX, defaultLeftStatsPosY, itemStatsFont,
            DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, Font.CR_Black);
        }
    
        currentLineHeight += 1;
        printRelicStatsTableAt(asi, plr.EquippedRelic, defaultLeftStatsPosX, defaultLeftStatsPosY, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT);
    }

    void printRelicStatsTableAt(RwRelic asi, RwRelic fskCmp, int x, int y, int textFlags) {
        statsCollector.CollectStatsFromAffixableItem(asi, fskCmp, 1);
        printAllCollectorLines(x, y, pickupableStatsTableWidth, textFlags);
    }
}