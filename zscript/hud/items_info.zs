extend class MyCustomHUD {

    const pickupableStatsTableWidth = 185;
    RwHudArtifactStatsCollector statsCollector;
    void DrawPickupableItemInfo() {
        let lineHRel = itemStatsFont.mFont.GetHeight();
        let lineHAbs = lineHRel * CleanYFac_1;

        let itemUnderCrosshair = PressToPickupHandler.GetItemUnderCrosshair();
        if (itemUnderCrosshair == null) {
            return;
        }

        let plr = RwPlayer(CPlayer.mo);
        if (!plr) return;

        if (plr.scrapItemButtonPressedTicks > 0 && AffixableDetector.IsAffixableItem(itemUnderCrosshair)) {
            DrawString(itemNameFont, "RECYCLING: "..plr.getScrapProgressPercentage().."%",
                (0, 0), DI_SCREEN_CENTER|DI_TEXT_ALIGN_CENTER, Font.CR_Red);
            return;
        }
        
        if (RwWeapon(itemUnderCrosshair)) {
            DimScreenForStats();
            DrawPickupableWeaponInfo(RwWeapon(itemUnderCrosshair), plr);
        } else if (RwArmor(itemUnderCrosshair)) {
            DimScreenForStats();
            DrawPickupableArmorInfo(RwArmor(itemUnderCrosshair), plr);
        } else if (RwBackpack(itemUnderCrosshair)) {
            DimScreenForStats();
            DrawPickupableBackpackInfo(RwBackpack(itemUnderCrosshair), plr);
        } else if (RwActiveSlotItem(itemUnderCrosshair)) {
            DimScreenForStats();
            DrawPickupableASIInfo(RwActiveSlotItem(itemUnderCrosshair), plr);
        } else {
            debug.panic("Unknown item to draw pickupable stats for: "..itemUnderCrosshair.GetClassName());
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
        let wpn = RwWeapon(CPlayer.ReadyWeapon);
        let arm = RwArmor(plr.CurrentEquippedArmor);

        let headerX = Screen.GetWidth() / (3 * CleanXFac_1);
        let statsX = 26 * Screen.GetWidth() / (100 * CleanXFac_1);

        currentLineHeight = 5;
        Screen.Dim(0x000000, 0.5, 0, 0, Screen.GetWidth(), Screen.GetHeight(), STYLE_Translucent);

        DrawString(itemNameFont,
            "Inferno level "..plr.infernoLevel..": "..plr.GetFluffNameForInfernoLevel(plr.infernoLevel),
                (0, 5), DI_SCREEN_CENTER_TOP|DI_TEXT_ALIGN_CENTER, Font.CR_WHITE);

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
        PrintEmptyLine(itemStatsFont);

        let asi = RwActiveSlotItem(plr.EquippedActiveSlotItem);
        PrintLineAt("===  CURRENT EQUIPPED ACTIVE ITEM:  ===", headerX, 0, itemNameFont, fullScreenStatusFlags, Font.CR_WHITE);
        if (asi) {
            printASIStatsTableAt(asi, null, statsX, 0, fullScreenStatusFlags);
        } else {
            PrintLineAt("No active slot item equipped", headerX, 0, itemNameFont, fullScreenStatusFlags, Font.CR_DARKGRAY);
        }

    }

    void DrawShortCurrentItemsInfo() {
        let plr = RwPlayer(CPlayer.mo);
        let wpn = RwWeapon(CPlayer.ReadyWeapon);
        let armr = RwArmor(plr.CurrentEquippedArmor);

        if (wpn) {
            if (wpn.stats.reloadable())
            {
                DrawInventoryIcon(wpn.ammo1, (-14, -25), DI_SCREEN_RIGHT_BOTTOM);
                DrawString(mHUDFont, 
                    FormatNumber(wpn.currentClipAmmo, 3),
                    (-73, -40), DI_SCREEN_RIGHT_BOTTOM);
            }
        }
        drawAmmoTotals(-75);

        if (RwSettingsShowEquippedItemsShortInfo) {
            if (wpn) {
                DrawString(itemNameFont, 
                    "Weapon: "..wpn.nameWithAppliedAffixes,
                    (0, -30), DI_SCREEN_CENTER_BOTTOM|DI_TEXT_ALIGN_CENTER, PickColorForAffixableItem(wpn));
            }

            if (armr) {
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

    // TODO: think of a better way of doing that. :|
    array< Class<Ammo> > allUsedAmmo;
    array<string> allAmmoStrings;
    void drawAmmoTotals(int y) { // y is negative; 0 is lowest pixel row.
        if (allUsedAmmo.size() == 0) {
            allUsedAmmo.push('Clip');
            allUsedAmmo.push('Shell');
            allUsedAmmo.push('RocketAmmo');
            allUsedAmmo.push('Cell');
        }
        while (allAmmoStrings.Size() < allUsedAmmo.Size()) allAmmoStrings.push("");
        let plr = RwPlayer(CPlayer.mo);
        // First, collect/set all strings and decide which one is the widest;
        int longestStringWidth = 0;
        for(let i = allUsedAmmo.Size() - 1; i >= 0; i--)
		{
			let type = allUsedAmmo[i];
			let ammoitem = CPlayer.mo.FindInventory(type);
            let inv = GetDefaultByType(type);
			int maxammo = ammoitem? ammoitem.MaxAmount : inv.MaxAmount;
			int ammo = ammoitem? ammoitem.Amount : 0;

			allAmmoStrings[i] = String.Format("%3d/%3d", ammo, maxammo);
			int sWidth = ConFont.StringWidth(allAmmoStrings[i]) + 5;
            if (sWidth > longestStringWidth) longestStringWidth = sWidth;
		}
        // Second, draw the strings and icons
        let fontHeight = ConFont.GetHeight();
        for(let i = allUsedAmmo.Size() - 1; i >= 0; i--)
		{
			let type = allUsedAmmo[i];
			let ammoitem = CPlayer.mo.FindInventory(type);
			let inv = GetDefaultByType(type);

			let AltIcon = inv.AltHUDIcon;
			int maxammo = ammoitem? ammoitem.MaxAmount : inv.MaxAmount;
            int ammo = ammoitem? ammoitem.Amount : 0;

			let icon = !AltIcon.isNull()? AltIcon : inv.Icon;
			if (!icon.isValid()) continue;

			double trans = 0.33;
            // The line for weapon in hands is more opaque
            RwWeapon currentWeapon = RwWeapon(Players[0].ReadyWeapon);
            if (currentWeapon && currentWeapon.ammotype1 is type) {
                trans = 0.75;
            }

			int fontcolor=( !maxammo ? Font.CR_GRAY :    
							 ammo < ( (maxammo * hud_ammo_red) / 100) ? Font.CR_RED :   
							 ammo < ( (maxammo * hud_ammo_yellow) / 100) ? Font.CR_GOLD : Font.CR_GREEN );

            DrawString(ammoTotalsFont, allAmmoStrings[i], (-longestStringWidth, y), DI_SCREEN_RIGHT_BOTTOM, fontcolor, alpha: trans);
			DrawImageToBox(icon, -longestStringWidth-18, y, 16, 8, trans);

            y -= (fontHeight + 2);
		}
    }

    // Used to draw ammo icons
    void DrawImageToBox(TextureID tex, int x, int y, int w, int h, double trans = 0.75)
	{
		double scale1, scale2;

		if (tex)
		{
			let texsize = TexMan.GetScaledSize(tex);

			if (w < texsize.X) scale1 = w / texsize.X;
			else scale1 = 1.0;
			if (h < texsize.Y) scale2 = h / texsize.Y;
			else scale2 = 1.0;
			scale1 = min(scale1, scale2);
			if (scale2 < scale1) scale1=scale2;

			x += w >> 1;
			y += h;

			w = (int)(texsize.X * scale1);
			h = (int)(texsize.Y * scale1);

			DrawTexture(tex, 
                (x, y), 
                DI_SCREEN_RIGHT_BOTTOM, 
                trans, 
                (w, h));

		}
	}
}