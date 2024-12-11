extend class MyCustomHUD {

    void DrawPlayerExperienceInfo() {
        let plr = RwPlayer(CPlayer.mo);
        if (!plr) return;

        DrawString(itemNameFont, "LEVEL: "..plr.getCurrentExpLevel(),
            (-5, 0), DI_SCREEN_RIGHT_TOP|DI_TEXT_ALIGN_RIGHT, Font.CR_GREEN);
        
        DrawString(itemNameFont, "EXP: "..plr.currentExperience.."/"..plr.getRequiredXPForNextLevel(),
            (-5, itemNameFont.mFont.GetHeight()+1), DI_SCREEN_RIGHT_TOP|DI_TEXT_ALIGN_RIGHT, Font.CR_GREEN);
    }
}