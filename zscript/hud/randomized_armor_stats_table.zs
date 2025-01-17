extend class MyCustomHUD {

    void DrawPickupableArmorInfo(RandomizedArmor armr, RwPlayer plr) {
        if (plr.CurrentEquippedArmor == armr) return;

        currentLineHeight = 0;
        
        if (plr.CurrentEquippedArmor) {
            PrintLineAt(BuildDefaultPickUpHintStr("switch to"),
            defaultLeftStatsPosX, defaultLeftStatsPosY, itemStatsFont,
            DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, Font.CR_Black);
        } else {
            PrintLineAt(BuildDefaultPickUpHintStr("wear"),
            defaultLeftStatsPosX, defaultLeftStatsPosY, itemStatsFont,
            DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, Font.CR_Black);
        }
    
        currentLineHeight += 1;
        printArmorStatsTableAt(armr, plr.CurrentEquippedArmor, defaultLeftStatsPosX, defaultLeftStatsPosY, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT);
    }

    void printArmorStatsTableAt(RandomizedArmor armr, RandomizedArmor armrCmp, int x, int y, int textFlags) {
        let linesX = x+8;
        string compareStr = "";
        let compareClr = Font.CR_White;

        PrintTableLineAt(
            "LVL "..armr.generatedQuality.." "..armr.nameWithAppliedAffixes, "("..getRarityName(armr.appliedAffixes.Size())..")",
            x, y, pickupableStatsTableWidth,
            itemNameFont, textFlags, PickColorForAffixableItem(armr)
        );

        statsCollector.CollectStatsFromAffixableItem(armr, armrCmp);
        printAllCollectorLines(linesX, y, pickupableStatsTableWidth, textFlags);
    }

    static int PickColorForRwArmorAmount(RandomizedArmor a) {
        let perc = math.getIntFractionInPercent(a.stats.currDurability, a.stats.maxDurability);
        if (perc < 33) {
            return Font.CR_RED;
        } else if (perc < 66) {
            return Font.CR_YELLOW;
        } else if (perc < 100) {
            return Font.CR_GREEN;
        }
        return Font.CR_BLUE;
    }
}