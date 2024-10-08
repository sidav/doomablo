extend class MyCustomHUD {
    void DrawFullCurrentItemsInfo() {
        let plr = MyPlayer(CPlayer.mo);
        let wpn = RandomizedWeapon(CPlayer.ReadyWeapon);
        let arm = RandomizedArmor(plr.CurrentEquippedArmor);

        currentLineHeight = 0;

        if (wpn) {
            PrintLineAt("==========  CURRENT EQUIPPED WEAPON:  ==========",
                        0, 0, mSmallFont, DI_SCREEN_LEFT_TOP|DI_TEXT_ALIGN_LEFT, Font.CR_WHITE);
            printWeaponStatsAt(wpn, null, 0, 0, DI_SCREEN_LEFT_TOP|DI_TEXT_ALIGN_LEFT);

            PrintLineAt("", 0, 0, mSmallFont, DI_SCREEN_LEFT_TOP|DI_TEXT_ALIGN_LEFT, Font.CR_WHITE);
            PrintLineAt("", 0, 0, mSmallFont, DI_SCREEN_LEFT_TOP|DI_TEXT_ALIGN_LEFT, Font.CR_WHITE);
        }

        if (arm) {
            PrintLineAt("==========  CURRENT EQUIPPED ARMOR:  ==========",
                        0, 0, mSmallFont, DI_SCREEN_LEFT_TOP|DI_TEXT_ALIGN_LEFT, Font.CR_WHITE);
            printArmorStatsTableAt(arm, null, 0, 0, DI_SCREEN_LEFT_TOP|DI_TEXT_ALIGN_LEFT);
        }

    }

    void DrawShortCurrentItemsInfo() {
        let plr = MyPlayer(CPlayer.mo);
        let wpn = RandomizedWeapon(CPlayer.ReadyWeapon);
        let armr = RandomizedArmor(plr.CurrentEquippedArmor);

        if (wpn) {
            if (wpn.stats.reloadable())
            {
                DrawInventoryIcon(wpn.ammo1, (-14, -25), DI_SCREEN_RIGHT_BOTTOM);
                DrawString(mHUDFont, 
                    FormatNumber(wpn.currentClipAmmo, 3),
                    (-73, -40), DI_SCREEN_RIGHT_BOTTOM);
            }
            DrawString(mSmallFont, 
                "Equipped: "..wpn.nameWithAppliedAffixes,
                (0, -20), DI_SCREEN_CENTER_BOTTOM|DI_TEXT_ALIGN_CENTER, PickColorForAffixableItem(wpn));
        }

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
}