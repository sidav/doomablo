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

        if (armrCmp && armr.stats.maxDurability != armrCmp.stats.maxDurability) {
            compareStr = " ("..intToSignedStr(armr.stats.maxDurability - armrCmp.stats.maxDurability)..")";
            compareClr = GetDifferenceColor(armr.stats.maxDurability - armrCmp.stats.maxDurability);
        }
        PrintTableLineAt("Durability:", armr.stats.currDurability.."/"..armr.stats.maxDurability..compareStr, 
                    linesX, y, pickupableStatsTableWidth,
                    itemStatsFont, textFlags, Font.CR_White, compareClr);

        // if (armr.stats.DamageReduction > 0) {
        //     PrintTableLine("Incoming damage", "-"..armr.stats.DamageReduction, pickupableStatsTableWidth,
        //             itemStatsFont, textFlags, Font.CR_White);    
        // }
        if (armrCmp && armr.stats.AbsorbsPercentage != armrCmp.stats.AbsorbsPercentage) {
            compareStr = " ("..intToSignedStr(armr.stats.AbsorbsPercentage - armrCmp.stats.AbsorbsPercentage).."%)";
            compareClr = GetDifferenceColor(armr.stats.AbsorbsPercentage - armrCmp.stats.AbsorbsPercentage);
        } else {
            compareStr = "";
            compareClr = Font.CR_White;
        }
        PrintTableLineAt("Damage absorption", armr.stats.AbsorbsPercentage.."%"..compareStr,
                    linesX, y, pickupableStatsTableWidth,
                    itemStatsFont, textFlags, Font.CR_White, compareClr);

        ////////////////////////////////////////////////////////////////////////////////
        // Stop comparing energy and non-energy armor at this point
        if (armrCmp && (armr.stats.IsEnergyArmor() != armrCmp.stats.IsEnergyArmor())) {
            armrCmp = null;
        }

        if (armr.stats.IsEnergyArmor()) {

            if (armrCmp && armr.stats.delayUntilRecharge != armrCmp.stats.delayUntilRecharge) {
                compareStr = " ("..floatToSignedStr(Gametime.ticksToSeconds(armr.stats.delayUntilRecharge) - Gametime.ticksToSeconds(armrCmp.stats.delayUntilRecharge))..")";
                compareClr = GetDifferenceColor(armr.stats.delayUntilRecharge - armrCmp.stats.delayUntilRecharge, true);
            } else {
                compareStr = "";
                compareClr = Font.CR_White;
            }
            PrintTableLineAt("Delay until recharge", String.Format("%.1f s", Gametime.ticksToSeconds(armr.stats.delayUntilRecharge))..compareStr,
                        linesX, y, pickupableStatsTableWidth,
                        itemStatsFont, textFlags, Font.CR_White, compareClr);


            if (armrCmp && armr.stats.RestorePerSecond() != armrCmp.stats.RestorePerSecond()) {
                compareStr = " ("..floatToSignedStr(armr.stats.RestorePerSecond() - armrCmp.stats.RestorePerSecond())..")";
                compareClr = GetDifferenceColor(10*(armr.stats.RestorePerSecond() - armrCmp.stats.RestorePerSecond()));
            } else {
                compareStr = "";
                compareClr = Font.CR_White;
            }
            PrintTableLineAt("Recharge speed", String.Format("%.1f/s", armr.stats.RestorePerSecond())..compareStr,
                        linesX, y, pickupableStatsTableWidth,
                        itemStatsFont, textFlags, Font.CR_White, compareClr);

        } else {

            if (armrCmp && armr.stats.BonusRepair != armrCmp.stats.BonusRepair) {
                compareStr = " ("..intToSignedStr(armr.stats.BonusRepair - armrCmp.stats.BonusRepair)..")";
                compareClr = GetDifferenceColor(armr.stats.BonusRepair - armrCmp.stats.BonusRepair);
            } else {
                compareStr = "";
                compareClr = Font.CR_White;
            }
            PrintTableLineAt("Repair amount", armr.stats.BonusRepair..compareStr,
                        linesX, y, pickupableStatsTableWidth,
                        itemStatsFont, textFlags, Font.CR_White, compareClr);

        }

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