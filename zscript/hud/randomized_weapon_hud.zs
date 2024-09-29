extend class MyCustomHUD {

    void DrawWeaponInHandsInfo() {
        let wpn = RandomizedWeapon(CPlayer.ReadyWeapon);
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
    }

    void DrawPickupableWeaponInfo() {
        let handler = PressToPickupHandler(EventHandler.Find('PressToPickupHandler'));
        let wpn = RandomizedWeapon(handler.currentItemToPickUp);
        if (!wpn) return;

        currentLineHeight = 0;

        // let plr = MyPlayer(CPlayer.mo);
        // if (plr.HasEmptyWeaponSlotFor(wpn)) {
        //     PrintLine("Press USE to pick up:", mSmallFont, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_CENTER, Font.CR_White);
        // } else {
        //     PrintLine("Press USE to switch to:", mSmallFont, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_CENTER, Font.CR_White);
        // }

        PrintLine("Press USE to pick up:", mSmallFont, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, Font.CR_Black);
        currentLineHeight += 1;

        PrintLine(
            "LVL "..wpn.generatedQuality.." "..wpn.nameWithAppliedAffixes.." ("..getRarityName(wpn.appliedAffixes.Size())..")",
            mSmallShadowFont, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, PickColorForAffixableItem(wpn)
        );
        
        printWeaponStats(wpn);
        
        foreach (aff : wpn.appliedAffixes) {
            printAffixDescriptionLine(aff);
        }
    }

    const weaponStatsTableWidth = 150;
    void printWeaponStats(RandomizedWeapon wpn) {
        if (wpn.stats.pellets > 1) {
            PrintTableLine("Damage per pellet:", wpn.stats.minDamage.."-"..wpn.stats.MaxDamage, weaponStatsTableWidth,
                    mSmallFont, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, Font.CR_White);
            PrintTableLine("Pellets per shot:", ""..wpn.stats.pellets, weaponStatsTableWidth,
                    mSmallFont, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, Font.CR_White);
            PrintTableLine("Total shot damage:", wpn.stats.minDamage.."-"..wpn.stats.MaxDamage*wpn.stats.pellets, weaponStatsTableWidth,
                    mSmallFont, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, Font.CR_White);    
        } else {
            PrintTableLine("Damage:", wpn.stats.minDamage.."-"..wpn.stats.MaxDamage, weaponStatsTableWidth,
                    mSmallFont, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, Font.CR_White);
        }
        if (wpn.stats.clipSize > 1) {
            PrintTableLine("Magazine capacity:", ""..wpn.stats.clipSize, weaponStatsTableWidth,
                    mSmallFont, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, Font.CR_White);    
        }
        PrintTableLine("Spread:", String.Format("%.2f", (wpn.stats.horizSpread)), weaponStatsTableWidth,
                    mSmallFont, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, Font.CR_White);
    }
}