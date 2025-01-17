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

        statsCollector.CollectStatsFromAffixableItem(wpn, wpnComp);
        printAllCollectorLines(linesX, y, pickupableStatsTableWidth, textFlags);
    }
}