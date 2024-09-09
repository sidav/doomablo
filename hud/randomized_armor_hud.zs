extend class MyCustomHUD {

    void DrawEquippedArmorInfo() {
        let armr = MyPlayer(CPlayer.mo).CurrentEquippedArmor;
        if (armr) {
            DrawString(mSmallFont, 
                "Equipped: "..armr.rwFullName.." ("..armr.stats.currDurability.."%)",
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
        if (armr.appliedAffixes.size() == 0) {
            PrintLine("Common "..armr.rwFullName,
                mSmallShadowFont, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, PickColorForRwArmor(armr));
            printArmorStats(armr);
        } else {
            PrintLine(armr.rwFullName, mSmallShadowFont, 
                DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, PickColorForRwArmor(armr));
            printArmorStats(armr);
            foreach (aff : armr.appliedAffixes) {
                PrintLine("  "..aff.getName()..": "..aff.getDescription(), 
                    mSmallFont, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, Font.CR_White);
            }
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
}