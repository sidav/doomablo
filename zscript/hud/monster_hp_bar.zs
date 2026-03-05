extend class MyCustomHUD {

    void DrawCurrentTargetHPBar() {
        let handler = CurrentTargetHandler(EventHandler.Find('CurrentTargetHandler'));
        if (handler.currentTargetMonster == null || handler.currentTargetMonster.Health <= 0) {
            return;
        }

        let plr = RwPlayer(CPlayer.mo);
        if (!plr) return;

        DrawHpBarRect(handler.currentTargetMonster, handler.currentMonsterAffixator);

        // Screen.DrawText(monsterNameFont.mFont, Font.CR_WHITE, 
        //     Screen.GetWidth()/2 - monsterNameFont.mFont.StringWidth("DIST 1000"), rwhud_monster_name_y_offset+10, 
        //     "DIST "..plr.Distance2D(handler.currentTargetMonster), DTA_SCALEX, CleanXFac_1, DTA_SCALEY, CleanYFac_1);
    }

    void DrawHpBarRect(Actor currentTargetMonster, RwMonsterAffixator currAffixator) {
        let str = currentTargetMonster.GetTag()..String.Format(" (%d/%d)", (currentTargetMonster.health, currentTargetMonster.GetMaxHealth()));
        let fontHeight = monsterNameFont.mFont.GetHeight();
        let frameXThickness = 8 * CleanXFac_1;
        let frameYThickness = 8 * CleanYFac_1;
        let HpBarWidth = max(150, monsterNameFont.mFont.StringWidth(str) + 2*frameXThickness);
        let HpBarYPosition = 80;

        // Frame coords
        let frameW = HPBarWidth * CleanXFac_1;
        let frameH = 24 * CleanYFac_1;
        let frameX = Screen.GetWidth()/2 - frameW/2;
        let frameY = HpBarYPosition * CleanYFac_1;

        // Hp rectangle coords
        let rectX = frameX + frameXThickness;
        let rectY = frameY + frameYThickness;
        let rectHeight = 8 * CleanYFac_1;
        let rectMaxW = frameW - 2 * frameXThickness;


        // Draw frame background
        Screen.Dim(0x000000, 0.7, rectX, rectY, rectMaxW, rectHeight, STYLE_Translucent);

        // Draw the HP rect itself
        drawTargetHpRectangle(rectX, rectY, rectMaxW, rectHeight, currentTargetMonster);

        // Draw the frame
        let tex = TexMan.CheckForTexture("HPBAR1");
        double texW, texH;
        [texW, texH] = TexMan.GetSize(tex);
        Screen.DrawTexture(tex, false, frameX, frameY, DTA_DestWidth, frameW, DTA_DestHeight, frameH);

        // Text coords
        let strX = Screen.GetWidth()/2 - monsterNameFont.mFont.StringWidth(str);
        let strY = rectY + CleanYFac_1;        
        // Draw text
        drawTextOnTargetHpRectangle(strX, strY, str, currAffixator);

        // Draw affixes text
        if (currAffixator == null) return;
        let affText = currAffixator.getDescriptionString();
        let affStrX = Screen.GetWidth()/2 - monsterNameFont.mFont.StringWidth(affText);
        let affStrY = strY + 2*fontHeight;
        Screen.DrawText(monsterNameFont.mFont, Font.CR_GRAY, affStrX, affStrY, 
            affText, DTA_SCALEX, CleanXFac_1, DTA_SCALEY, CleanYFac_1, DTA_COLOR, 0xFF000000 | 0xAA2200);
        

        return;
    }

    private void drawTargetHpRectangle(int x, int y, int maxWidth, int height, Actor currentTargetMonster) {
        let w = math.remapIntRange(currentTargetMonster.health, 0, currentTargetMonster.GetMaxHealth(), 0, maxWidth);
        let barColor = 0xAA0000;
        if (currentTargetMonster.bFriendly)
            barColor = 0x00AA00;
        Screen.Dim(barColor, 0.8, x, y, w, height, STYLE_Translucent);
    }

    private void drawTextOnTargetHpRectangle(int x, int y, string text, RwMonsterAffixator currAffixator) {
        let clr = Font.CR_WHITE;
        if (currAffixator) {
            clr = PickColorForAffixableItem(currAffixator);
        }
        Screen.DrawText(monsterNameFont.mFont, clr, x, y, text, DTA_SCALEX, CleanXFac_1, DTA_SCALEY, CleanYFac_1);
    }
}