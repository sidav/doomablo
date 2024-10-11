extend class MyCustomHUD {

    void DrawPickupableItemInfo() {
        let lineHRel = mSmallFont.mFont.GetHeight();
        let lineHAbs = lineHRel * CleanYFac_1;

        let plr = MyPlayer(CPlayer.mo);
        if (!plr) return;
        let handler = PressToPickupHandler(EventHandler.Find('PressToPickupHandler'));

        
        if (RandomizedWeapon(handler.currentItemToPickUp)) {
            DimScreenForStats();
            DrawPickupableWeaponInfo(RandomizedWeapon(handler.currentItemToPickUp), plr);
        } else if (RandomizedArmor(handler.currentItemToPickUp)) {
            DimScreenForStats();
            DrawPickupableArmorInfo(RandomizedArmor(handler.currentItemToPickUp), plr);
        }
    }

    void DimScreenForStats() {
        let x = (defaultLeftStatsPosX - 5) * CleanXFac_1;
        let y = Screen.GetHeight()/2 + (defaultLeftStatsPosY - 10) * CleanYFac_1;
        let w = 5*Screen.GetWidth()/10;
        let h = 32*Screen.GetHeight()/100;
        Screen.Dim(0x000000, 0.35, x, y, w, h, STYLE_Translucent);
    }

    const fullScreenStatusFlags = DI_SCREEN_LEFT_TOP|DI_TEXT_ALIGN_LEFT;
    void DrawFullCurrentItemsInfo() {
        let plr = MyPlayer(CPlayer.mo);
        let wpn = RandomizedWeapon(CPlayer.ReadyWeapon);
        let arm = RandomizedArmor(plr.CurrentEquippedArmor);

        let headerX = Screen.GetWidth() / (3 * CleanXFac_1);
        let statsX = 26 * Screen.GetWidth() / (100 * CleanXFac_1);

        currentLineHeight = 5;
        Screen.Dim(0x000000, 0.5, 0, 0, Screen.GetWidth(), Screen.GetHeight(), STYLE_Translucent);

        PrintEmptyLine(mSmallFont);
        PrintLineAt("Drops level: "..plr.minItemQuality.."-"..plr.maxItemQuality, 0, 0, mSmallFont, DI_SCREEN_CENTER_TOP|DI_TEXT_ALIGN_CENTER, Font.CR_WHITE);
        PrintEmptyLine(mSmallFont);

        PrintLineAt("===  CURRENT EQUIPPED WEAPON:  ===", headerX, 0, mSmallFont, fullScreenStatusFlags, Font.CR_WHITE);
        if (wpn) {
            printWeaponStatsAt(wpn, null, statsX, 0, fullScreenStatusFlags);
            PrintEmptyLine(mSmallFont);
        } else {
            PrintLineAt("No artifact weapon equipped", headerX, 0, mSmallFont, fullScreenStatusFlags, Font.CR_DARKGRAY);
        }
        let lineH = (currentLineHeight + 10) * CleanYFac_1;
        // Screen.DrawThickLine(0, lineH, Screen.GetWidth(), lineH, 3, 0xAAAAAA, 255);
        

        PrintLineAt("===  CURRENT EQUIPPED ARMOR:  ===", headerX, 0, mSmallFont, fullScreenStatusFlags, Font.CR_WHITE);
        if (arm) {
            printArmorStatsTableAt(arm, null, statsX, 0, fullScreenStatusFlags);
            PrintEmptyLine(mSmallFont);
        } else {
            PrintLineAt("No artifact armor equipped", headerX, 0, mSmallFont, fullScreenStatusFlags, Font.CR_DARKGRAY);
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
                "Weapon: "..wpn.nameWithAppliedAffixes,
                (0, -20), DI_SCREEN_CENTER_BOTTOM|DI_TEXT_ALIGN_CENTER, PickColorForAffixableItem(wpn));
        }

		if (armr) {
            DrawInventoryIcon(armr, (20, -22));
            DrawString(mHUDFont, 
                FormatNumber(armr.stats.currDurability, 3),
                (44, -40), DI_SCREEN_LEFT_BOTTOM, PickColorForRwArmorAmount(armr));
            DrawString(mSmallFont, 
                "Armor: "..armr.nameWithAppliedAffixes,
                (0, -10), DI_SCREEN_CENTER_BOTTOM|DI_TEXT_ALIGN_CENTER, PickColorForAffixableItem(armr));
        } else {
            DrawString(mSmallFont, 
                "NO ARMOR",
                (0, -10), DI_SCREEN_CENTER_BOTTOM|DI_TEXT_ALIGN_CENTER, Font.CR_RED);
        }
    }
}