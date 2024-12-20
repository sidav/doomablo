extend class MyCustomHUD {

    void DrawPickupableWeaponInfo(RandomizedWeapon wpn, RwPlayer plr) {
        RandomizedWeapon wpnComp = RandomizedWeapon(CPlayer.ReadyWeapon);

        let handler = PressToPickupHandler(EventHandler.Find('PressToPickupHandler'));
        let wpn = RandomizedWeapon(handler.currentItemToPickUp);
        if (!wpn || wpnComp == wpn) return;

        currentLineHeight = 0;

        Inventory playerWpnOfSameClass = plr.GetWeaponInInvByClass(wpn.GetClass());
        
        if (playerWpnOfSameClass) {
            PrintLineAt(BuildDefaultPickUpHintStr("switch your "..wpn.rwBaseName.." to"),
            defaultLeftStatsPosX, defaultLeftStatsPosY, itemStatsFont,
            DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, Font.CR_Black);
        } else {
            PrintLineAt(BuildDefaultPickUpHintStr("pick up"),
            defaultLeftStatsPosX, defaultLeftStatsPosY, itemStatsFont,
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

    void printWeaponStatsAt(RandomizedWeapon wpn, RandomizedWeapon wpnComp, int x, int y, int textFlags) {
        let linesX = x+8;
        string compareStr = "";
        let compareClr = Font.CR_White;

        PrintTableLineAt(
            "LVL "..wpn.generatedQuality.." "..wpn.nameWithAppliedAffixes, "("..getRarityName(wpn.appliedAffixes.Size())..")",
            x, y, pickupableStatsTableWidth,
            itemNameFont, textFlags, PickColorForAffixableItem(wpn)
        );

        // Damage
        float wpn1dmgmin = float(wpn.stats.minDamage * (1000 + wpn.stats.additionalDamagePromille)) / 1000.;
        float wpn1dmgmax = float(wpn.stats.maxDamage * (1000 + wpn.stats.additionalDamagePromille)) / 1000.;
        float wpn2dmgmin, wpn2dmgmax;
        if (wpnComp) {
            wpn2dmgmin = double(wpnComp.stats.minDamage * (1000 + wpnComp.stats.additionalDamagePromille)) / 1000.;
            wpn2dmgmax = double(wpnComp.stats.maxDamage * (1000 + wpnComp.stats.additionalDamagePromille)) / 1000.;
        }
        // SHOTGUN
        if (wpn.stats.pellets > 1) {
            // Damage
            if (wpnComp) {
                compareStr = makeDamageDifferenceString(wpn1dmgmin, wpn1dmgmax, wpn2dmgmin, wpn2dmgmax);
                compareClr = GetTwoFloatDifferencesColor(wpn1dmgmin - wpn2dmgmin, wpn1dmgmax - wpn2dmgmax);
            } else {
                compareStr = "";
            }
            PrintTableLineAt("Damage per pellet:", String.Format("%.2f-%.2f", (wpn1dmgmin, wpn1dmgmax))..compareStr, 
                    linesX, y, pickupableStatsTableWidth,
                    itemStatsFont, textFlags, Font.CR_White, compareClr);
            // Pellets
            if (wpnComp && wpn.stats.pellets != wpnComp.stats.pellets) {
                compareStr = " ("..intToSignedStr(wpn.stats.pellets - wpnComp.stats.pellets)..")";
                compareClr = GetDifferenceColor(wpn.stats.pellets - wpnComp.stats.pellets);
            } else {
                compareStr = "";
                compareClr = Font.CR_White;
            }
            PrintTableLineAt("Pellets per shot:", ""..wpn.stats.pellets..compareStr, 
                    linesX, y, pickupableStatsTableWidth,
                    itemStatsFont, textFlags, Font.CR_White, compareClr);
            // Total shot damage
            if (wpnComp) {
                compareStr = makeDamageDifferenceString(
                    wpn1dmgmin, wpn1dmgmax*wpn.stats.pellets,
                    wpn2dmgmin, wpn2dmgmax*wpnComp.stats.pellets
                );
                compareClr = GetTwoFloatDifferencesColor(wpn1dmgmin - wpn2dmgmin, wpn1dmgmax*wpn.stats.pellets - wpn2dmgmax*wpnComp.stats.pellets);
            } else {
                compareStr = "";
            }
            PrintTableLineAt("Total shot damage:", String.Format("%.2f-%.2f", (wpn1dmgmin, wpn1dmgmax*wpn.stats.pellets))..compareStr,
                    linesX, y, pickupableStatsTableWidth,
                    itemStatsFont, textFlags, Font.CR_White, compareClr);    
        // NON-SHOTGUN
        } else {
            if (wpnComp) {
                compareStr = makeDamageDifferenceString(wpn1dmgmin, wpn1dmgmax, wpn2dmgmin, wpn2dmgmax);
                compareClr = GetTwoFloatDifferencesColor(wpn1dmgmin - wpn2dmgmin, wpn1dmgmax - wpn2dmgmax);
            } else {
                compareStr = "";
                compareClr = Font.CR_White;
            }
            PrintTableLineAt("Damage:", String.Format("%.1f-%.1f", (wpn1dmgmin, wpn1dmgmax))..compareStr,
                    linesX, y, pickupableStatsTableWidth,
                    itemStatsFont, textFlags, Font.CR_White, compareClr);
        }

        // CLIP SIZE
        if (wpn.stats.clipSize > 1) {
            if (wpnComp && wpn.stats.clipSize != wpnComp.stats.clipSize && wpnComp.stats.clipSize > 0) {
                compareStr = " ("..intToSignedStr(wpn.stats.clipSize - wpnComp.stats.clipSize)..")";
                compareClr = GetDifferenceColor(wpn.stats.clipSize - wpnComp.stats.clipSize);
            } else {
                compareStr = "";
                compareClr = Font.CR_White;
            }
            PrintTableLineAt("Magazine capacity:", ""..wpn.stats.clipSize..compareStr, 
                    linesX, y, pickupableStatsTableWidth,
                    itemStatsFont, textFlags, Font.CR_White, compareClr);    
        }

        // SPREAD
        if (wpnComp && wpn.stats.horizSpread != wpnComp.stats.horizSpread) {
            compareStr = " ("..floatToSignedStr(wpn.stats.horizSpread - wpnComp.stats.horizSpread)..")";
            compareClr = GetDifferenceColor((wpn.stats.horizSpread - wpnComp.stats.horizSpread) * 100, true);
        } else {
            compareStr = "";
            compareClr = Font.CR_White;
        }
        PrintTableLineAt("Spread:", String.Format("%.2f", (wpn.stats.horizSpread))..compareStr, 
                    linesX, y, pickupableStatsTableWidth,
                    itemStatsFont, textFlags, Font.CR_White, compareClr);

        // Attack range
        if (wpn.stats.isMelee) {
            if (wpnComp && wpn.stats.attackRange != wpnComp.stats.attackRange) {
                compareStr = " ("..intToSignedStr(wpn.stats.attackRange - wpnComp.stats.attackRange)..")";
                compareClr = GetDifferenceColor((wpn.stats.attackRange - wpnComp.stats.attackRange) * 100);
            } else {
                compareStr = "";
                compareClr = Font.CR_White;
            }
            PrintTableLineAt("Reach:", String.Format("%d", (wpn.stats.attackRange))..compareStr, 
                        linesX, y, pickupableStatsTableWidth,
                        itemStatsFont, textFlags, Font.CR_White, compareClr);
        }

        // BFG stats
        if (wpn.GetClass() == 'RwBFG') {
            // Rays num
            if (wpnComp && wpn.stats.NumberOfRays != wpnComp.stats.NumberOfRays && wpnComp.stats.NumberOfRays > 0) {
                compareStr = " ("..intToSignedStr(wpn.stats.NumberOfRays - wpnComp.stats.NumberOfRays)..")";
                compareClr = GetDifferenceColor((wpn.stats.NumberOfRays - wpnComp.stats.NumberOfRays));
            } else {
                compareStr = "";
                compareClr = Font.CR_White;
            }
            PrintTableLineAt("Number of rays:", String.Format("%d", (wpn.stats.NumberOfRays))..compareStr, 
                        linesX, y, pickupableStatsTableWidth,
                        itemStatsFont, textFlags, Font.CR_White, compareClr);

            // Rays angle
            if (wpnComp && wpn.stats.RaysConeAngle != wpnComp.stats.RaysConeAngle && wpnComp.stats.NumberOfRays > 0) {
                compareStr = " ("..floatToSignedStr(wpn.stats.RaysConeAngle - wpnComp.stats.RaysConeAngle)..")";
                compareClr = GetDifferenceColor((wpn.stats.RaysConeAngle - wpnComp.stats.RaysConeAngle));
            } else {
                compareStr = "";
                compareClr = Font.CR_White;
            }
            PrintTableLineAt("Rays angle:", String.Format("%.1f", (wpn.stats.RaysConeAngle))..compareStr, 
                        linesX, y, pickupableStatsTableWidth,
                        itemStatsFont, textFlags, Font.CR_White, compareClr);

            // Rays dmg
            wpn1dmgmin = float(wpn.stats.RayDmgMin * (1000 + wpn.stats.additionalBfgRayDamagePromille)) / 1000.;
            wpn1dmgmax = float(wpn.stats.RayDmgMax * (1000 + wpn.stats.additionalBfgRayDamagePromille)) / 1000.;
            if (wpnComp) {
                wpn2dmgmin = double(wpnComp.stats.RayDmgMin * (1000 + wpnComp.stats.additionalBfgRayDamagePromille)) / 1000.;
                wpn2dmgmax = double(wpnComp.stats.RayDmgMax * (1000 + wpnComp.stats.additionalBfgRayDamagePromille)) / 1000.;
            }
            if (wpnComp && wpnComp.stats.NumberOfRays > 0) {
                if (wpnComp) {
                    compareStr = makeDamageDifferenceString(wpn1dmgmin, wpn1dmgmax, wpn2dmgmin, wpn2dmgmax);
                    compareClr = GetTwoFloatDifferencesColor(wpn1dmgmin - wpn2dmgmin, wpn1dmgmax - wpn2dmgmax);
                } else {
                    compareStr = "";
                }
            } else {
                compareStr = "";
                compareClr = Font.CR_White;
            }
            PrintTableLineAt("Ray Damage:", String.Format("%.2f-%.2f", (wpn1dmgmin, wpn1dmgmax))..compareStr,
                    linesX, y, pickupableStatsTableWidth,
                    itemStatsFont, textFlags, Font.CR_White, compareClr);
        }

        foreach (aff : wpn.appliedAffixes) {
            printAffixDescriptionLineAt(aff, x+16, y, textFlags);
        }
    }

    private string makeDamageDifferenceString(float mind1, float maxd1, float mind2, float maxd2) {
        if (mind1 == mind2 && maxd1 == maxd2) {
            return "";
        }
        return " ("..floatToSignedStr(mind1 - mind2)..", "..floatToSignedStr(maxd1-maxd2)..")";
    }
}