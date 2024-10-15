extend class MyCustomHUD {

    void DrawPickupableWeaponInfo(RandomizedWeapon wpn, RwPlayer plr) {
        RandomizedWeapon wpnComp = RandomizedWeapon(CPlayer.ReadyWeapon);

        let handler = PressToPickupHandler(EventHandler.Find('PressToPickupHandler'));
        let wpn = RandomizedWeapon(handler.currentItemToPickUp);
        if (!wpn || wpnComp == wpn) return;

        currentLineHeight = 0;

        // let plr = RwPlayer(CPlayer.mo);
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
        if (wpnComp) {
            let wpnClass = wpn.GetClass();
            let wpnCompClass = wpnComp.GetClass();
            // Explicitly allow comparing Shotgun and SSG
            bool allowCompare = (wpnClass == wpnCompClass) ||
                (wpnClass == 'RwSuperShotgun' && wpnCompClass == 'RwShotgun') ||
                (wpnClass == 'RwShotgun' && wpnCompClass == 'RwSuperShotgun');

            if (!allowCompare) {
                wpnComp = null;
            }
        }
        
        printWeaponStatsAt(wpn, wpnComp, defaultLeftStatsPosX, defaultLeftStatsPosY, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT);
    }

    const weaponStatsTableWidth = 170;
    void printWeaponStatsAt(RandomizedWeapon wpn, RandomizedWeapon wpnComp, int x, int y, int textFlags) {
        let linesX = x+8;
        string compareStr = "";
        let compareClr = Font.CR_White;

        PrintTableLineAt(
            "LVL "..wpn.generatedQuality.." "..wpn.nameWithAppliedAffixes, "("..getRarityName(wpn.appliedAffixes.Size())..")",
            x, y, weaponStatsTableWidth,
            mSmallShadowFont, textFlags, PickColorForAffixableItem(wpn)
        );

        if (wpn.stats.pellets > 1) {
            if (wpnComp) {
                compareStr = makeDamageDifferenceString(
                    wpn.stats.minDamage, wpn.stats.maxDamage,
                    wpnComp.stats.minDamage, wpnComp.stats.MaxDamage
                );
                compareClr = GetTwoDifferencesColor(
                    wpn.stats.minDamage - wpnComp.stats.minDamage,
                    wpn.stats.maxDamage - wpnComp.stats.MaxDamage
                );
            } else {
                compareStr = "";
            }
            PrintTableLineAt("Damage per pellet:", wpn.stats.minDamage.."-"..wpn.stats.MaxDamage..compareStr, 
                    linesX, y, weaponStatsTableWidth,
                    mSmallFont, textFlags, Font.CR_White, compareClr);

            if (wpnComp && wpn.stats.pellets != wpnComp.stats.pellets) {
                compareStr = " ("..intToSignedStr(wpn.stats.pellets - wpnComp.stats.pellets)..")";
                compareClr = GetDifferenceColor(wpn.stats.pellets - wpnComp.stats.pellets);
            } else {
                compareStr = "";
                compareClr = Font.CR_White;
            }
            PrintTableLineAt("Pellets per shot:", ""..wpn.stats.pellets..compareStr, 
                    linesX, y, weaponStatsTableWidth,
                    mSmallFont, textFlags, Font.CR_White, compareClr);

            if (wpnComp) {
                compareStr = makeDamageDifferenceString(
                    wpn.stats.minDamage, wpn.stats.MaxDamage*wpn.stats.pellets,
                    wpnComp.stats.minDamage, wpnComp.stats.MaxDamage*wpnComp.stats.pellets
                );
                compareClr = GetTwoDifferencesColor(
                    wpn.stats.minDamage - wpnComp.stats.minDamage,
                    wpn.stats.MaxDamage*wpn.stats.pellets - wpnComp.stats.MaxDamage*wpnComp.stats.pellets
                );
            } else {
                compareStr = "";
            }
            PrintTableLineAt("Total shot damage:", wpn.stats.minDamage.."-"..wpn.stats.MaxDamage*wpn.stats.pellets..compareStr,
                    linesX, y, weaponStatsTableWidth,
                    mSmallFont, textFlags, Font.CR_White, compareClr);    
        } else {
            if (wpnComp) {
                compareStr = makeDamageDifferenceString(
                    wpn.stats.minDamage, wpn.stats.maxDamage,
                    wpnComp.stats.minDamage, wpnComp.stats.MaxDamage
                );
                compareClr = GetTwoDifferencesColor(
                    wpn.stats.minDamage - wpnComp.stats.minDamage,
                    wpn.stats.maxDamage - wpnComp.stats.MaxDamage
                );
            } else {
                compareStr = "";
                compareClr = Font.CR_White;
            }
            PrintTableLineAt("Damage:", wpn.stats.minDamage.."-"..wpn.stats.MaxDamage..compareStr,
                    linesX, y, weaponStatsTableWidth,
                    mSmallFont, textFlags, Font.CR_White, compareClr);
        }
        if (wpn.stats.clipSize > 1) {
            if (wpnComp && wpn.stats.clipSize != wpnComp.stats.clipSize && wpnComp.stats.clipSize > 0) {
                compareStr = " ("..intToSignedStr(wpn.stats.clipSize - wpnComp.stats.clipSize)..")";
                compareClr = GetDifferenceColor(wpn.stats.clipSize - wpnComp.stats.clipSize);
            } else {
                compareStr = "";
                compareClr = Font.CR_White;
            }
            PrintTableLineAt("Magazine capacity:", ""..wpn.stats.clipSize..compareStr, 
                    linesX, y, weaponStatsTableWidth,
                    mSmallFont, textFlags, Font.CR_White, compareClr);    
        }
        if (wpnComp && wpn.stats.horizSpread != wpnComp.stats.horizSpread) {
            compareStr = " ("..floatToSignedStr(wpn.stats.horizSpread - wpnComp.stats.horizSpread)..")";
            compareClr = GetDifferenceColor((wpn.stats.horizSpread - wpnComp.stats.horizSpread) * 100, true);
        } else {
            compareStr = "";
            compareClr = Font.CR_White;
        }
        PrintTableLineAt("Spread:", String.Format("%.2f", (wpn.stats.horizSpread))..compareStr, 
                    linesX, y, weaponStatsTableWidth,
                    mSmallFont, textFlags, Font.CR_White, compareClr);

        foreach (aff : wpn.appliedAffixes) {
            printAffixDescriptionLineAt(aff, x+16, y, textFlags);
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