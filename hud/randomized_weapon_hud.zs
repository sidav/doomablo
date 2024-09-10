extend class MyCustomHUD {

    int currentHeight;

    void DrawWeaponInHandsInfo() {
        let wpn = RandomizedWeapon(CPlayer.ReadyWeapon);
        if (wpn) {
            DrawString(mSmallFont, 
                "Equipped: "..RandomizedWeapon(CPlayer.ReadyWeapon).rwFullName,
                (0, -20), DI_SCREEN_CENTER_BOTTOM|DI_TEXT_ALIGN_CENTER, PickColorForRwWeapon(wpn));
        }
    }

    void DrawPickupableWeaponInfo() {
        let handler = PressToPickupHandler(EventHandler.Find('PressToPickupHandler'));
        let wpn = RandomizedWeapon(handler.currentItemToPickUp);
        if (!wpn) return;

        currentHeight = 0;

        // let plr = MyPlayer(CPlayer.mo);
        // if (plr.HasEmptyWeaponSlotFor(wpn)) {
        //     PrintLine("Press USE to pick up:", mSmallFont, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_CENTER, Font.CR_White);
        // } else {
        //     PrintLine("Press USE to switch to:", mSmallFont, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_CENTER, Font.CR_White);
        // }

        PrintLine("Press USE to pick up:", mSmallFont, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, Font.CR_Black);
        currentHeight += 1;
        if (wpn.appliedAffixes.size() == 0) {
            PrintLine("Common "..wpn.rwFullName,
                mSmallShadowFont, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, PickColorForRwWeapon(wpn));
            printWeaponStats(wpn);
        } else {
            PrintLine(wpn.rwFullName, mSmallShadowFont, 
                DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, PickColorForRwWeapon(wpn));
            printWeaponStats(wpn);
            foreach (aff : wpn.appliedAffixes) {
                PrintLine("  "..aff.getName()..": "..aff.getDescription(), 
                    mSmallFont, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, Font.CR_White);
            }
        }
    }

    void printWeaponStats(RandomizedWeapon wpn) {
        PrintLine("Damage: "..wpn.stats.minDamage.."-"..wpn.stats.MaxDamage, 
                    mSmallFont, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, Font.CR_White);
        if (wpn.stats.pellets > 1) {
            PrintLine(wpn.stats.pellets.." pellets per shot", 
                    mSmallFont, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, Font.CR_White);    
        }
        PrintLine("Spread "..String.Format("%.2f", (wpn.stats.horizSpread)),
                    mSmallFont, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, Font.CR_White);
    }

    static int PickColorForRwWeapon(RandomizedWeapon w) {
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

    void PrintLine(string line, HUDFont fnt, int flags, int trans) {
        DrawString(fnt, line,
            (80, currentHeight), flags, trans);
        currentHeight += fnt.mFont.GetHeight();
    }
}