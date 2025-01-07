extend class MyCustomHUD {

    void DrawPlayerExperienceInfo() {
        let plr = RwPlayer(CPlayer.mo);
        if (!plr) return;

        let fontHeight = itemNameFont.mFont.GetHeight();

        DrawString(itemNameFont, "LEVEL: "..plr.getCurrentExpLevel(),
            (-5, 0), DI_SCREEN_RIGHT_TOP|DI_TEXT_ALIGN_RIGHT, Font.CR_GREEN);
        
        DrawString(itemNameFont, "EXP: "..plr.currentExperience.."/"..plr.getRequiredXPForNextLevel()
            .." ("..plr.getXPPercentageForNextLevel().."%)",
            (-5, fontHeight+1), DI_SCREEN_RIGHT_TOP|DI_TEXT_ALIGN_RIGHT, Font.CR_GREEN);

        if (plr.stats.statPointsAvailable > 0) {
            DrawString(itemNameFont, plr.stats.statPointsAvailable.." points available",
                (-5, 2*(fontHeight+1)), DI_SCREEN_RIGHT_TOP|DI_TEXT_ALIGN_RIGHT, Font.CR_GOLD);
        }
    }
}