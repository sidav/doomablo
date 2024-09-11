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
                (0, -10), DI_SCREEN_CENTER_BOTTOM|DI_TEXT_ALIGN_CENTER, PickColorForRwArmor(armr));
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

        currentHeight = 0;

        // let plr = MyPlayer(CPlayer.mo);
        // if (plr.HasEmptyWeaponSlotFor(armr)) {
        //     PrintLine("Press USE to pick up:", mSmallFont, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_CENTER, Font.CR_White);
        // } else {
        //     PrintLine("Press USE to switch to:", mSmallFont, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_CENTER, Font.CR_White);
        // }

        PrintLine("Press USE to equip:", mSmallFont, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, Font.CR_Black);
        currentHeight += 1;

        PrintLine(armr.nameWithAppliedAffixes, mSmallShadowFont, 
            DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, PickColorForRwArmor(armr));

        printArmorStats(armr);

        foreach (aff : armr.appliedAffixes) {
            PrintLine("  "..aff.getName()..": "..aff.getDescription(), 
                mSmallFont, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, Font.CR_White);
        }
    }

    void printArmorStats(RandomizedArmor armr) {
        PrintLine("Durability: "..armr.stats.currDurability.."/"..armr.stats.maxDurability, 
                    mSmallFont, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, Font.CR_White);
        if (armr.stats.DamageReduction > 0) {
            PrintLine("-"..armr.stats.DamageReduction.." incoming damage", 
                    mSmallFont, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, Font.CR_White);    
        }
        PrintLine("Absorbs "..armr.stats.AbsorbsPercentage.."% of damage", 
                    mSmallFont, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, Font.CR_White);
    }

    static int PickColorForRwArmor(RandomizedArmor w) {
        int affcount = w.appliedAffixes.Size();
        switch (affcount) {
            case 0: return Font.CR_White;
            case 1: return Font.CR_Green;
            case 2: return Font.CR_Yellow;
            case 3: return Font.CR_Blue;
            case 4: return Font.CR_CYAN;
            case 5: return Font.CR_PURPLE;
            default: return Font.CR_Black;
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