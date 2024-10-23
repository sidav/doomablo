extend class MyCustomHUD {

    const HPBarMinWidth = 170;
    const HPBarHeight = 20;
    const OffetFromTop = 25;
    const InsideHpRectOffset = 2;
    const InsideHpRectOffset2 = InsideHpRectOffset*2;

    void DrawCurrentTargetHPBar() {
        let handler = CurrentTargetHandler(EventHandler.Find('CurrentTargetHandler'));
        if (handler.currentTargetMonster == null || handler.currentTargetMonster.Health <= 0) {
            return;
        }

        let plr = RwPlayer(CPlayer.mo);
        if (!plr) return;

        DrawHpBarRect(handler.currentTargetMonster, handler.currentMonsterAffixator);
    }

    void DrawHpBarRect(Actor currentTargetMonster, RwMonsterAffixator currAffixator) {
        let str = currentTargetMonster.GetTag()..String.Format(" (%d/%d)", (currentTargetMonster.health, currentTargetMonster.GetMaxHealth()));
        // str = String.Format("Terrifying Ba'ra-kul, the doomsday harbinger"
        //     ..String.Format(" (%d/%d)", (11*currentTargetMonster.health, 11*currentTargetMonster.GetMaxHealth())));
        let HPBarWidth = max(HPBarMinWidth, monsterNameFont.mFont.StringWidth(str) + 2*InsideHpRectOffset2);

        // The background rectangle
        let w = HPBarWidth * CleanXFac_1;
        let h = HPBarHeight * CleanYFac_1;
        let x = Screen.GetWidth()/2 - w/2;
        let y = OffetFromTop * CleanYFac_1;
        Screen.Dim(0x000000, 0.65, x, y, w, h, STYLE_Translucent);

        // The HP rectangle
        w = math.remapIntRange(currentTargetMonster.health, 0, currentTargetMonster.GetMaxHealth(), 0, (HPBarWidth - InsideHpRectOffset2)) * CleanXFac_1;
        x += InsideHpRectOffset * CleanXFac_1;
        h = (HPBarHeight - InsideHpRectOffset2) * CleanYFac_1;
        y += InsideHpRectOffset * CleanYFac_1;
        Screen.Dim(0xff0000, 0.3, x, y, w, h, STYLE_Translucent);

        // Text
        DrawString(monsterNameFont, str, (0, y/(CleanYFac_1) - 2), DI_SCREEN_CENTER_TOP|DI_TEXT_ALIGN_CENTER, Font.CR_WHITE);
        // Screen.DrawText("SMALLFONT", 0xffffff, Screen.GetWidth()/2, y, str);

        // Affixes
        if (currAffixator) {
            y += (monsterNameFont.mFont.GetHeight() + 2) * CleanYFac_1;
            DrawString(monsterNameFont, currAffixator.descriptionStr, (0, y/(CleanYFac_1) - 2), DI_SCREEN_CENTER_TOP|DI_TEXT_ALIGN_CENTER, Font.CR_RED);
        }
    }
}