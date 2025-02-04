extend class MyCustomHUD {

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
        let borderThickness2 = rwhud_hpbar_border_thickness * 2;
        let str = currentTargetMonster.GetTag()..String.Format(" (%d/%d)", (currentTargetMonster.health, currentTargetMonster.GetMaxHealth()));
        let HPBarWidth = max(rwhud_hpbar_min_width, monsterNameFont.mFont.StringWidth(str) + 2*borderThickness2);

        // The background rectangle
        let w = HPBarWidth * CleanXFac_1;
        let h = rwhud_hpbar_height * CleanYFac_1;
        let x = Screen.GetWidth()/2 - w/2;
        let y = rwhud_hpbar_y_position * CleanYFac_1;
        Screen.Dim(rwhud_monster_hpbar_border_color, 0.65, x, y, w, h, STYLE_Translucent);

        // The HP rectangle
        w = math.remapIntRange(currentTargetMonster.health, 0, currentTargetMonster.GetMaxHealth(), 0, (HPBarWidth - borderThickness2)) * CleanXFac_1;
        x += rwhud_hpbar_border_thickness * CleanXFac_1;
        h = (rwhud_hpbar_height - borderThickness2) * CleanYFac_1;
        y += rwhud_hpbar_border_thickness * CleanYFac_1;
        Screen.Dim(rwhud_monster_hpbar_color, 0.3, x, y, w, h, STYLE_Translucent);

        let clr = Font.CR_WHITE;
        if (currAffixator) {
            clr = PickColorForAffixableItem(currAffixator);
        }

        // Text
        let fontHeight = monsterNameFont.mFont.GetHeight();
        let textYPos = y+(h/2)-(fontHeight/2)-rwhud_hpbar_border_thickness;
        // DrawString(monsterNameFont, str, (0, rwhud_hpbar_y_position * CleanYFac_1), DI_SCREEN_CENTER_TOP|DI_TEXT_ALIGN_CENTER, clr);
        Screen.DrawText(monsterNameFont.mFont, clr, 
            Screen.GetWidth()/2 - monsterNameFont.mFont.StringWidth(str), textYPos+rwhud_monster_name_y_offset, 
            str, DTA_SCALEX, CleanXFac_1, DTA_SCALEY, CleanYFac_1);

        // Affixes
        if (currAffixator) {
            let text = currAffixator.getDescriptionString();
            Screen.DrawText(monsterNameFont.mFont, Font.CR_GRAY,
                Screen.GetWidth()/2 - monsterNameFont.mFont.StringWidth(text), textYPos+rwhud_monster_affixes_y_offset, 
                text, DTA_SCALEX, CleanXFac_1, DTA_SCALEY, CleanYFac_1, DTA_COLOR, 0xFF000000 | rwhud_monster_affixes_text_color);
        }
    }
}