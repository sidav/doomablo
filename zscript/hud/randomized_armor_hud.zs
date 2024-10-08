extend class MyCustomHUD {

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
        printArmorStatsTableAt(armr, plr.CurrentEquippedArmor, defaultLeftStatsPosX, defaultLeftStatsPosY, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT);
    }

    const armorStatsTableWidth = 160;
    void printArmorStatsTableAt(RandomizedArmor armr, RandomizedArmor armrCmp, int x, int y, int textFlags) {
        let linesX = x+8;
        string compareStr = "";
        let compareClr = Font.CR_White;

        PrintTableLineAt(
            "LVL "..armr.generatedQuality.." "..armr.nameWithAppliedAffixes, "("..getRarityName(armr.appliedAffixes.Size())..")",
            x, y, armorStatsTableWidth,
            mSmallShadowFont, textFlags, PickColorForAffixableItem(armr)
        );

        if (armrCmp && armr.stats.maxDurability != armrCmp.stats.maxDurability) {
            compareStr = " ("..intToSignedStr(armr.stats.maxDurability - armrCmp.stats.maxDurability)..")";
            compareClr = GetDifferenceColor(armr.stats.maxDurability - armrCmp.stats.maxDurability);
        }
        PrintTableLineAt("Durability:", armr.stats.currDurability.."/"..armr.stats.maxDurability..compareStr, 
                    linesX, y, armorStatsTableWidth,
                    mSmallFont, textFlags, Font.CR_White, compareClr);

        // if (armr.stats.DamageReduction > 0) {
        //     PrintTableLine("Incoming damage", "-"..armr.stats.DamageReduction, armorStatsTableWidth,
        //             mSmallFont, textFlags, Font.CR_White);    
        // }
        if (armrCmp && armr.stats.AbsorbsPercentage != armrCmp.stats.AbsorbsPercentage) {
            compareStr = " ("..intToSignedStr(armr.stats.AbsorbsPercentage - armrCmp.stats.AbsorbsPercentage).."%)";
            compareClr = GetDifferenceColor(armr.stats.AbsorbsPercentage - armrCmp.stats.AbsorbsPercentage);
        } else {
            compareStr = "";
        }
        PrintTableLineAt("Damage absorption", armr.stats.AbsorbsPercentage.."%"..compareStr,
                    linesX, y, armorStatsTableWidth,
                    mSmallFont, textFlags, Font.CR_White, compareClr);

        if (armrCmp && armr.stats.BonusRepair != armrCmp.stats.BonusRepair) {
            compareStr = " ("..intToSignedStr(armr.stats.BonusRepair - armrCmp.stats.BonusRepair)..")";
            compareClr = GetDifferenceColor(armr.stats.BonusRepair - armrCmp.stats.BonusRepair);
        } else {
            compareStr = "";
        }
        PrintTableLineAt("Repair amount", armr.stats.BonusRepair..compareStr,
                    linesX, y, armorStatsTableWidth,
                    mSmallFont, textFlags, Font.CR_White, compareClr);

        foreach (aff : armr.appliedAffixes) {
            printAffixDescriptionLineAt(aff, x+16, y, textFlags);
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