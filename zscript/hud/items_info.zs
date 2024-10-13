extend class MyCustomHUD {

    void DrawPickupableItemInfo() {
        let lineHRel = mSmallFont.mFont.GetHeight();
        let lineHAbs = lineHRel * CleanYFac_1;

        let handler = PressToPickupHandler(EventHandler.Find('PressToPickupHandler'));
        if (handler.currentItemToPickUp == null) {
            return;
        }

        let plr = MyPlayer(CPlayer.mo);
        if (!plr) return;

        
        if (RandomizedWeapon(handler.currentItemToPickUp)) {
            DimScreenForStats();
            DrawPickupableWeaponInfo(RandomizedWeapon(handler.currentItemToPickUp), plr);
        } else if (RandomizedArmor(handler.currentItemToPickUp)) {
            DimScreenForStats();
            DrawPickupableArmorInfo(RandomizedArmor(handler.currentItemToPickUp), plr);
        } else if (RwBackpack(handler.currentItemToPickUp)) {
            DimScreenForStats();
            DrawPickupableBackpackInfo(RwBackpack(handler.currentItemToPickUp), plr);
        } else {
            debug.panic("Unknown item to draw pickupable stats for: "..handler.currentItemToPickUp.GetClassName());
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

        PrintLineAt("Drops level: "..plr.minItemQuality.."-"..plr.maxItemQuality, 0, 0, mSmallFont, DI_SCREEN_CENTER_TOP|DI_TEXT_ALIGN_CENTER, Font.CR_WHITE);
        PrintEmptyLine(mSmallFont);

        PrintLineAt("===  CURRENT EQUIPPED WEAPON:  ===", headerX, 0, mSmallFont, fullScreenStatusFlags, Font.CR_WHITE);
        if (wpn) {
            printWeaponStatsAt(wpn, null, statsX, 0, fullScreenStatusFlags);
        } else {
            PrintLineAt("No artifact weapon equipped", headerX, 0, mSmallFont, fullScreenStatusFlags, Font.CR_DARKGRAY);
        }
        PrintEmptyLine(mSmallFont);
        // let lineH = (currentLineHeight + 10) * CleanYFac_1;
        // Screen.DrawThickLine(0, lineH, Screen.GetWidth(), lineH, 3, 0xAAAAAA, 255);
        

        PrintLineAt("===  CURRENT EQUIPPED ARMOR:  ===", headerX, 0, mSmallFont, fullScreenStatusFlags, Font.CR_WHITE);
        if (arm) {
            printArmorStatsTableAt(arm, null, statsX, 0, fullScreenStatusFlags);
        } else {
            PrintLineAt("No artifact armor equipped", headerX, 0, mSmallFont, fullScreenStatusFlags, Font.CR_DARKGRAY);
        }
        PrintEmptyLine(mSmallFont);

        let bkpk = RwBackpack(plr.CurrentEquippedBackpack);
        PrintLineAt("===  CURRENT EQUIPPED BACKPACK:  ===", headerX, 0, mSmallFont, fullScreenStatusFlags, Font.CR_WHITE);
        if (bkpk) {
            printBackpackStatsTableAt(bkpk, null, statsX, 0, fullScreenStatusFlags);
        } else {
            PrintLineAt("No backpack equipped", headerX, 0, mSmallFont, fullScreenStatusFlags, Font.CR_DARKGRAY);
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
                (0, -30), DI_SCREEN_CENTER_BOTTOM|DI_TEXT_ALIGN_CENTER, PickColorForAffixableItem(wpn));
        }

		if (armr) {
            DrawInventoryIcon(armr, (20, -22));
            DrawString(mHUDFont, 
                FormatNumber(armr.stats.currDurability, 3),
                (44, -40), DI_SCREEN_LEFT_BOTTOM, PickColorForRwArmorAmount(armr));
            DrawString(mSmallFont, 
                "Armor: "..armr.nameWithAppliedAffixes,
                (0, -20), DI_SCREEN_CENTER_BOTTOM|DI_TEXT_ALIGN_CENTER, PickColorForAffixableItem(armr));
        } else {
            DrawString(mSmallFont, 
                "NO ARMOR",
                (0, -20), DI_SCREEN_CENTER_BOTTOM|DI_TEXT_ALIGN_CENTER, Font.CR_RED);
        }

        let bkpk = RwBackpack(plr.CurrentEquippedBackpack);
        if (bkpk) {
            // DrawInventoryIcon(bkpk, (-12, -1));
            DrawString(mSmallFont, 
                "Backpack: "..bkpk.nameWithAppliedAffixes,
                (0, -10), DI_SCREEN_CENTER_BOTTOM|DI_TEXT_ALIGN_CENTER, PickColorForAffixableItem(bkpk));
        } else {
            DrawString(mSmallFont, 
                "NO BACKPACK",
                (0, -10), DI_SCREEN_CENTER_BOTTOM|DI_TEXT_ALIGN_CENTER, Font.CR_RED);
        }
    }
}