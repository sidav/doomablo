extend class MyCustomHUD {
	// HUDFont mBigFont;
	HUDFont itemStatsFont;
	HUDFont itemNameFont;

    void initFonts() {
        // Font fnt = "BIGFONT";
		// mBigFont = HUDFont.Create(fnt, fnt.GetCharWidth("0"), Mono_CellLeft, 2, 2);
		Font fnt = "SMALLFONT";
		itemStatsFont = HUDFont.Create(fnt, -1, false);
        fnt = "SMALLFONT";
		itemNameFont = HUDFont.Create(fnt, 0, false, 2, 2);
		
		// Create the font used for the fullscreen HUD
		fnt = "HUDFONT_DOOM";
		mHUDFont = HUDFont.Create(fnt, fnt.GetCharWidth("0"), Mono_CellLeft, 1, 1);
		// fnt = "INDEXFONT_DOOM";
		// mIndexFont = HUDFont.Create(fnt, fnt.GetCharWidth("0"), Mono_CellLeft);
		// mAmountFont = HUDFont.Create("INDEXFONT");
		// diparms = InventoryBarState.Create();
    }
}