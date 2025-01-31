extend class MyCustomHUD {

    void DrawPlayerExperienceInfo() {
        let plr = RwPlayer(CPlayer.mo);
        if (!plr) return;

        let fontHeight = itemNameFont.mFont.GetHeight();

        DrawString(itemNameFont, "LEVEL: "..plr.stats.getCurrentExpLevel(),
            (-5, 0), DI_SCREEN_RIGHT_TOP|DI_TEXT_ALIGN_RIGHT, Font.CR_GREEN);
        
        DrawString(itemNameFont, plr.stats.GetFullXpString(),
            (-5, fontHeight+1), DI_SCREEN_RIGHT_TOP|DI_TEXT_ALIGN_RIGHT, Font.CR_GREEN);

        if (plr.stats.statPointsAvailable > 1) {
            DrawString(itemNameFont, plr.stats.statPointsAvailable.." stat points available",
                (-5, 2*(fontHeight+1)), DI_SCREEN_RIGHT_TOP|DI_TEXT_ALIGN_RIGHT, Font.CR_GOLD);
        } else if (plr.stats.statPointsAvailable == 1) {
            DrawString(itemNameFont, "Stat point available",
                (-5, 2*(fontHeight+1)), DI_SCREEN_RIGHT_TOP|DI_TEXT_ALIGN_RIGHT, Font.CR_GOLD);
        }
    }
}