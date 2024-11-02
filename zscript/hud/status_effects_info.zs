extend class MyCustomHUD {

    const statusTableWidth = 100;
    void DrawPlayerStatusEffects() {
        let plr = RwPlayer(CPlayer.mo);
        if (!plr) return;
        currentLineHeight = 0;

        Inventory itm;
        let invlist = plr.inv;
        while(invlist != null) {
            if (invlist != null && invlist is 'RwStatusEffectToken') {
                DrawStatusEffectLine(RwStatusEffectToken(invlist));
            }
            invlist=invlist.Inv;
        };        
    }

    void DrawStatusEffectLine(RwStatusEffectToken se) {
        let flags = DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT;
        PrintTableLineAt(se.GetStatusName(), ""..se.Amount, 0, 0, statusTableWidth, itemStatsFont, flags, se.GetColorForUi());
    }
}