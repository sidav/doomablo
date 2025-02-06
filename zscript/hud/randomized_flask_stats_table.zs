extend class MyCustomHUD {

    void DrawPickupableFlaskInfo(RwFlask fsk, RwPlayer plr) {
        if (plr.CurrentEquippedFlask == fsk) return;

        currentLineHeight = 0;
        
        if (plr.CurrentEquippedFlask) {
            PrintLineAt(BuildDefaultPickUpHintStr("switch to"),
            defaultLeftStatsPosX, defaultLeftStatsPosY, itemStatsFont,
            DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, Font.CR_Black);
        } else {
            PrintLineAt(BuildDefaultPickUpHintStr("equip"),
            defaultLeftStatsPosX, defaultLeftStatsPosY, itemStatsFont,
            DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, Font.CR_Black);
        }
    
        currentLineHeight += 1;
        printFlaskStatsTableAt(fsk, plr.CurrentEquippedFlask, defaultLeftStatsPosX, defaultLeftStatsPosY, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT);
    }

    void printFlaskStatsTableAt(RwFlask fsk, RwFlask fskCmp, int x, int y, int textFlags) {
        statsCollector.CollectStatsFromAffixableItem(fsk, fskCmp, 1);
        printAllCollectorLines(x, y, pickupableStatsTableWidth, textFlags);
    }
}