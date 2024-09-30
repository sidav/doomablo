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
        let plr = MyPlayer(CPlayer.mo);
        if (!plr) return;
        RandomizedWeapon wpnComp = RandomizedWeapon(CPlayer.ReadyWeapon);

        let handler = PressToPickupHandler(EventHandler.Find('PressToPickupHandler'));
        let wpn = RandomizedWeapon(handler.currentItemToPickUp);
        if (!wpn || wpnComp == wpn) return;

        currentLineHeight = 0;

        // let plr = MyPlayer(CPlayer.mo);
        // if (plr.HasEmptyWeaponSlotFor(wpn)) {
        //     PrintLine("Press USE to pick up:", mSmallFont, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_CENTER, Font.CR_White);
        // } else {
        //     PrintLine("Press USE to switch to:", mSmallFont, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_CENTER, Font.CR_White);
        // }

        Inventory playerWpnOfSameClass;
        let invlist = plr.inv;
        while(invlist != null) {
            if ( invlist.GetClass() == wpn.GetClass()) {
                playerWpnOfSameClass = Weapon(invlist);
                break;
            }
            invlist=invlist.Inv;
        };
        
        if (playerWpnOfSameClass) {
            PrintLineAt("Press USE to switch your "..wpn.rwBaseName.." to:",
            defaultLeftStatsPosX, defaultLeftStatsPosY, mSmallFont,
            DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, Font.CR_Black);
        } else {
            PrintLineAt("Press USE to pick up:", 
            defaultLeftStatsPosX, defaultLeftStatsPosY, mSmallFont,
            DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, Font.CR_Black);
        }

        // Compare only if the weapon in hands is of the same class.
        if (wpn.GetClass() != wpnComp.GetClass()) {
            wpnComp = null;
        }
        
        printWeaponStatsAt(wpn, wpnComp, defaultLeftStatsPosX, defaultLeftStatsPosY);
    }

    const weaponStatsTableWidth = 170;
    void printWeaponStatsAt(RandomizedWeapon wpn, RandomizedWeapon wpnComp, int x, int y) {
        string compareStr = "";
        let linesX = x+8;

        PrintTableLineAt(
            "LVL "..wpn.generatedQuality.." "..wpn.nameWithAppliedAffixes, "("..getRarityName(wpn.appliedAffixes.Size())..")",
            x, y, weaponStatsTableWidth,
            mSmallShadowFont, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, PickColorForAffixableItem(wpn)
        );

        if (wpn.stats.pellets > 1) {
            if (wpnComp) {
                compareStr = makeDamageDifferenceString(
                    wpn.stats.minDamage, wpn.stats.maxDamage,
                    wpnComp.stats.minDamage, wpnComp.stats.MaxDamage
                );
            } else {
                compareStr = "";
            }
            PrintTableLineAt("Damage per pellet:", wpn.stats.minDamage.."-"..wpn.stats.MaxDamage..compareStr, 
                    linesX, y, weaponStatsTableWidth,
                    mSmallFont, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, Font.CR_White);

            if (wpnComp && wpn.stats.pellets != wpnComp.stats.pellets) {
                compareStr = " ("..intToSignedStr(wpn.stats.pellets - wpnComp.stats.pellets)..")";
            } else {
                compareStr = "";
            }
            PrintTableLineAt("Pellets per shot:", ""..wpn.stats.pellets..compareStr, 
                    linesX, y, weaponStatsTableWidth,
                    mSmallFont, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, Font.CR_White);

            if (wpnComp) {
                compareStr = makeDamageDifferenceString(
                    wpn.stats.minDamage, wpn.stats.MaxDamage*wpn.stats.pellets,
                    wpnComp.stats.minDamage, wpnComp.stats.MaxDamage*wpnComp.stats.pellets
                );
            } else {
                compareStr = "";
            }
            PrintTableLineAt("Total shot damage:", wpn.stats.minDamage.."-"..wpn.stats.MaxDamage*wpn.stats.pellets..compareStr,
                    linesX, y, weaponStatsTableWidth,
                    mSmallFont, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, Font.CR_White);    
        } else {
            if (wpnComp) {
                compareStr = makeDamageDifferenceString(
                    wpn.stats.minDamage, wpn.stats.maxDamage,
                    wpnComp.stats.minDamage, wpnComp.stats.MaxDamage
                );
            } else {
                compareStr = "";
            }
            PrintTableLineAt("Damage:", wpn.stats.minDamage.."-"..wpn.stats.MaxDamage..compareStr,
                    linesX, y, weaponStatsTableWidth,
                    mSmallFont, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, Font.CR_White);
        }
        if (wpn.stats.clipSize > 1) {
            if (wpnComp && wpn.stats.clipSize != wpnComp.stats.clipSize) {
                compareStr = " ("..intToSignedStr(wpn.stats.clipSize - wpnComp.stats.clipSize)..")";
            } else {
                compareStr = "";
            }
            PrintTableLineAt("Magazine capacity:", ""..wpn.stats.clipSize..compareStr, 
                    linesX, y, weaponStatsTableWidth,
                    mSmallFont, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, Font.CR_White);    
        }
        if (wpnComp && wpn.stats.horizSpread != wpnComp.stats.horizSpread) {
            compareStr = " ("..floatToSignedStr(wpn.stats.horizSpread - wpnComp.stats.horizSpread)..")";
        } else {
            compareStr = "";
        }
        PrintTableLineAt("Spread:", String.Format("%.2f", (wpn.stats.horizSpread)), 
                    linesX, y, weaponStatsTableWidth,
                    mSmallFont, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, Font.CR_White);

        foreach (aff : wpn.appliedAffixes) {
            printAffixDescriptionLineAt(aff, x+16, y);
        }
    }

    private string makeDamageDifferenceString(int mind1, int maxd1, int mind2, int maxd2) {
        if (mind1 == mind2 && maxd1 == maxd2) {
            return "";
        }
        if (mind1 != mind2 && maxd1 != maxd2) {
            return " ("..intToSignedStr(mind1 - mind2)..", "..intToSignedStr(maxd1-maxd2)..")";
        }
        return " ("..intToSignedStr(mind1 - mind2)..", "..intToSignedStr(maxd1-maxd2)..")";
        // if (mind1 != mind2) {
        //     return " (min "..intToSignedStr(mind1 - mind2)..")";
        // }
        // return " (max "..intToSignedStr(maxd1 - maxd2)..")";
    }
}