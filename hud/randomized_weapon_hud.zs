extend class MyCustomHUD {

    int currentHeight;

    void DrawWeaponInHandsInfo() {
        if (CPlayer.ReadyWeapon is 'RandomizedWeapon') {
            DrawString(mSmallFont, 
                "Equipped: "..RandomizedWeapon(CPlayer.ReadyWeapon).rwFullName,
                (0, -20), DI_SCREEN_CENTER_BOTTOM|DI_TEXT_ALIGN_CENTER, Font.CR_Yellow);
        }
    }

    void DrawPickupableWeaponInfo() {
        let plr = MyPlayer(CPlayer.mo);
        let handler = RandomizedWeaponPickupHandler(EventHandler.Find('RandomizedWeaponPickupHandler'));
        let wpn = RandomizedWeapon(handler.currentItemToPickUp);
        if (!wpn) return;

        currentHeight = 0;

        // if (plr.HasEmptyWeaponSlotFor(wpn)) {
        //     DrawLine("Press USE to pick up:", mSmallFont, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_CENTER, Font.CR_White);
        // } else {
        //     DrawLine("Press USE to switch to:", mSmallFont, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_CENTER, Font.CR_White);
        // }

        DrawLine("Press USE to pick up:", mSmallFont, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, Font.CR_Black);
        currentHeight += 1;
        if (wpn.appliedAffixes.size() == 0) {
            DrawLine("Common "..wpn.rwFullName,
                mSmallShadowFont, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, PickColorForRwWeapon(wpn));
        } else {
            DrawLine(wpn.rwFullName, mSmallShadowFont, 
                DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, PickColorForRwWeapon(wpn));
            foreach (aff : wpn.appliedAffixes) {
                DrawLine("  "..aff.getName()..": "..aff.getDescription(), 
                    mSmallFont, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, Font.CR_White);
            }
        }
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

    void DrawLine(string line, HUDFont fnt, int flags, int trans) {
        DrawString(fnt, line,
            (80, currentHeight), flags, trans);
        currentHeight += fnt.mFont.GetHeight();
    }
}