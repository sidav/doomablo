extend class MyCustomHUD {

    const pickupableStatsTableWidth = 185;
    void DrawPickupableItemInfo() {
        let lineHRel = itemStatsFont.mFont.GetHeight();
        let lineHAbs = lineHRel * CleanYFac_1;

        let handler = PressToPickupHandler(EventHandler.Find('PressToPickupHandler'));
        if (handler.currentItemToPickUp == null) {
            return;
        }

        let plr = RwPlayer(CPlayer.mo);
        if (!plr) return;

        if (plr.scrapItemButtonPressedTicks > 0 && AffixableDetector.IsAffixableItem(handler.currentItemToPickUp)) {
            DrawString(itemNameFont, "RECYCLING: "..plr.getScrapProgressPercentage().."%",
                (0, 0), DI_SCREEN_CENTER|DI_TEXT_ALIGN_CENTER, Font.CR_Red);
            return;
        }
        
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
        let plr = RwPlayer(CPlayer.mo);
        let wpn = RandomizedWeapon(CPlayer.ReadyWeapon);
        let arm = RandomizedArmor(plr.CurrentEquippedArmor);

        let headerX = Screen.GetWidth() / (3 * CleanXFac_1);
        let statsX = 26 * Screen.GetWidth() / (100 * CleanXFac_1);

        currentLineHeight = 5;
        Screen.Dim(0x000000, 0.5, 0, 0, Screen.GetWidth(), Screen.GetHeight(), STYLE_Translucent);

        let levelsStr = "Drops and monsters levels: "..plr.minItemQuality.."-"..plr.maxItemQuality;
        // if (plr.ProgressionEnabledUI()) {
            DrawString(itemNameFont,
                levelsStr,
                (0, 5), DI_SCREEN_CENTER_TOP|DI_TEXT_ALIGN_CENTER, Font.CR_WHITE);
        // } else {
        //     DrawString(itemNameFont, 
        //         levelsStr.." (progression disabled)",
        //         (0, 5), DI_SCREEN_CENTER_TOP|DI_TEXT_ALIGN_CENTER, Font.CR_DARKGRAY);
        // }
        PrintEmptyLine(itemNameFont);
        PrintEmptyLine(itemNameFont);

        PrintLineAt("===  CURRENT EQUIPPED WEAPON:  ===", headerX, 0, itemNameFont, fullScreenStatusFlags, Font.CR_WHITE);
        if (wpn) {
            printWeaponStatsAt(wpn, null, statsX, 0, fullScreenStatusFlags);
        } else {
            PrintLineAt("No artifact weapon equipped", headerX, 0, itemNameFont, fullScreenStatusFlags, Font.CR_DARKGRAY);
        }
        PrintEmptyLine(itemStatsFont);
        // let lineH = (currentLineHeight + 10) * CleanYFac_1;
        // Screen.DrawThickLine(0, lineH, Screen.GetWidth(), lineH, 3, 0xAAAAAA, 255);
        

        PrintLineAt("===  CURRENT EQUIPPED ARMOR:  ===", headerX, 0, itemNameFont, fullScreenStatusFlags, Font.CR_WHITE);
        if (arm) {
            printArmorStatsTableAt(arm, null, statsX, 0, fullScreenStatusFlags);
        } else {
            PrintLineAt("No artifact armor equipped", headerX, 0, itemNameFont, fullScreenStatusFlags, Font.CR_DARKGRAY);
        }
        PrintEmptyLine(itemStatsFont);

        let bkpk = RwBackpack(plr.CurrentEquippedBackpack);
        PrintLineAt("===  CURRENT EQUIPPED BACKPACK:  ===", headerX, 0, itemNameFont, fullScreenStatusFlags, Font.CR_WHITE);
        if (bkpk) {
            printBackpackStatsTableAt(bkpk, null, statsX, 0, fullScreenStatusFlags);
        } else {
            PrintLineAt("No backpack equipped", headerX, 0, itemNameFont, fullScreenStatusFlags, Font.CR_DARKGRAY);
        }

    }

    void DrawShortCurrentItemsInfo() {
        let plr = RwPlayer(CPlayer.mo);
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
            DrawString(itemNameFont, 
                "Weapon: "..wpn.nameWithAppliedAffixes,
                (0, -30), DI_SCREEN_CENTER_BOTTOM|DI_TEXT_ALIGN_CENTER, PickColorForAffixableItem(wpn));
        }

		if (armr) {
            DrawInventoryIcon(armr, (20, -22));
            DrawString(mHUDFont, 
                FormatNumber(armr.stats.currDurability, 3),
                (44, -40), DI_SCREEN_LEFT_BOTTOM, PickColorForRwArmorAmount(armr));
            DrawString(itemNameFont, 
                "Armor: "..armr.nameWithAppliedAffixes,
                (0, -20), DI_SCREEN_CENTER_BOTTOM|DI_TEXT_ALIGN_CENTER, PickColorForAffixableItem(armr));
        } else {
            DrawString(itemNameFont, 
                "NO ARMOR",
                (0, -20), DI_SCREEN_CENTER_BOTTOM|DI_TEXT_ALIGN_CENTER, Font.CR_RED);
        }

        let bkpk = RwBackpack(plr.CurrentEquippedBackpack);
        if (bkpk) {
            // DrawInventoryIcon(bkpk, (-12, -1));
            DrawString(itemNameFont, 
                "Backpack: "..bkpk.nameWithAppliedAffixes,
                (0, -10), DI_SCREEN_CENTER_BOTTOM|DI_TEXT_ALIGN_CENTER, PickColorForAffixableItem(bkpk));
        } else {
            DrawString(itemNameFont, 
                "NO BACKPACK",
                (0, -10), DI_SCREEN_CENTER_BOTTOM|DI_TEXT_ALIGN_CENTER, Font.CR_RED);
        }
    }
}