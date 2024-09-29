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
        let handler = PressToPickupHandler(EventHandler.Find('PressToPickupHandler'));
        let armr = RandomizedArmor(handler.currentItemToPickUp);
        if (!armr) return;

        currentLineHeight = 0;

        // let plr = MyPlayer(CPlayer.mo);
        // if (plr.HasEmptyWeaponSlotFor(armr)) {
        //     PrintLine("Press USE to pick up:", mSmallFont, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_CENTER, Font.CR_White);
        // } else {
        //     PrintLine("Press USE to switch to:", mSmallFont, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_CENTER, Font.CR_White);
        // }

        PrintLine("Press USE to equip:", mSmallFont, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, Font.CR_Black);
        currentLineHeight += 1;

        PrintLine(
            "LVL "..armr.generatedQuality.." "..armr.nameWithAppliedAffixes.." ("..getRarityName(armr.appliedAffixes.Size())..")",
            mSmallShadowFont, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, PickColorForAffixableItem(armr)
        );

        printArmorStats(armr);

        foreach (aff : armr.appliedAffixes) {
            printAffixDescriptionLine(aff);
        }
    }

    const armorStatsTableWidth = 150;
    void printArmorStats(RandomizedArmor armr) {
        PrintTableLine("Durability:", armr.stats.currDurability.."/"..armr.stats.maxDurability, armorStatsTableWidth,
                    mSmallFont, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, Font.CR_White);
        // if (armr.stats.DamageReduction > 0) {
        //     PrintTableLine("Incoming damage", "-"..armr.stats.DamageReduction, armorStatsTableWidth,
        //             mSmallFont, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, Font.CR_White);    
        // }
        PrintTableLine("Damage absorption", armr.stats.AbsorbsPercentage.."%", armorStatsTableWidth,
                    mSmallFont, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, Font.CR_White);
        PrintTableLine("Repair amount", armr.stats.BonusRepair.."", armorStatsTableWidth,
                    mSmallFont, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, Font.CR_White);
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