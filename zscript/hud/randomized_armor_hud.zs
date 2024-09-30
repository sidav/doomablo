extend class MyCustomHUD {

    void DrawEquippedArmorInfo() {
        let armr = MyPlayer(CPlayer.mo).CurrentEquippedArmor;
        if (armr) {
            if (armr.stats.currDurability > 0)
            {
                DrawInventoryIcon(armr, (20, -22));
                DrawString(mHUDFont, 
                    FormatNumber(armr.stats.currDurability, 3),
                    (44, -40), DI_SCREEN_LEFT_BOTTOM, PickColorForRwArmorAmount(armr));
            }
            DrawString(mSmallFont, 
                "Equipped: "..armr.nameWithAppliedAffixes,
                (0, -10), DI_SCREEN_CENTER_BOTTOM|DI_TEXT_ALIGN_CENTER, PickColorForAffixableItem(armr));
        } else {
            DrawString(mSmallFont, 
                "NO ARMOR",
                (0, -10), DI_SCREEN_CENTER_BOTTOM|DI_TEXT_ALIGN_CENTER, Font.CR_RED);
        }
    }

    void DrawPickupableArmorInfo() {
        let plr = MyPlayer(CPlayer.mo);
        if (!plr) return;

        let handler = PressToPickupHandler(EventHandler.Find('PressToPickupHandler'));
        let armr = RandomizedArmor(handler.currentItemToPickUp);
        if (!armr || plr.CurrentEquippedArmor == armr) return;

        currentLineHeight = 0;
        
        if (plr.CurrentEquippedArmor) {
            PrintLineAt("Press USE to switch to:",
            defaultLeftStatsPosX, defaultLeftStatsPosY, mSmallFont,
            DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, Font.CR_Black);
        } else {
            PrintLineAt("Press USE to equip:", 
            defaultLeftStatsPosX, defaultLeftStatsPosY, mSmallFont,
            DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, Font.CR_Black);
        }
    
        currentLineHeight += 1;
        printArmorStatsTableAt(armr, plr.CurrentEquippedArmor, defaultLeftStatsPosX, defaultLeftStatsPosY);
    }

    const armorStatsTableWidth = 160;
    void printArmorStatsTableAt(RandomizedArmor armr, RandomizedArmor armrCmp, int x, int y) {
        string compareStr = "";
        let linesX = x+8;

        PrintTableLineAt(
            "LVL "..armr.generatedQuality.." "..armr.nameWithAppliedAffixes, "("..getRarityName(armr.appliedAffixes.Size())..")",
            x, y, armorStatsTableWidth,
            mSmallShadowFont, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, PickColorForAffixableItem(armr)
        );

        if (armrCmp && armr.stats.maxDurability != armrCmp.stats.maxDurability) {
            compareStr = " ("..intToSignedStr(armr.stats.maxDurability - armrCmp.stats.maxDurability)..")";
        }
        PrintTableLineAt("Durability:", armr.stats.currDurability.."/"..armr.stats.maxDurability..compareStr, 
                    linesX, y, armorStatsTableWidth,
                    mSmallFont, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, Font.CR_White);

        // if (armr.stats.DamageReduction > 0) {
        //     PrintTableLine("Incoming damage", "-"..armr.stats.DamageReduction, armorStatsTableWidth,
        //             mSmallFont, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, Font.CR_White);    
        // }
        if (armrCmp && armr.stats.AbsorbsPercentage != armrCmp.stats.AbsorbsPercentage) {
            compareStr = " ("..intToSignedStr(armr.stats.AbsorbsPercentage - armrCmp.stats.AbsorbsPercentage).."%)";
        } else {
            compareStr = "";
        }
        PrintTableLineAt("Damage absorption", armr.stats.AbsorbsPercentage.."%"..compareStr,
                    linesX, y, armorStatsTableWidth,
                    mSmallFont, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, Font.CR_White);

        if (armrCmp && armr.stats.BonusRepair != armrCmp.stats.BonusRepair) {
            compareStr = " ("..intToSignedStr(armr.stats.BonusRepair - armrCmp.stats.BonusRepair)..")";
        } else {
            compareStr = "";
        }
        PrintTableLineAt("Repair amount", armr.stats.BonusRepair..compareStr,
                    linesX, y, armorStatsTableWidth,
                    mSmallFont, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, Font.CR_White);

        foreach (aff : armr.appliedAffixes) {
            printAffixDescriptionLineAt(aff, x+16, y);
        }
    }

    static int PickColorForRwArmorAmount(RandomizedArmor a) {
        let perc = math.getPercentageFromInt(a.stats.currDurability, a.stats.maxDurability);
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