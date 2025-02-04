class MyCustomHUD : BaseStatusBar
{
	HUDFont mHUDFont;
	HUDFont mIndexFont;
	HUDFont mAmountFont;
	InventoryBarState diparms;

    override void Init()
    {
        // This function is called once, when the
        // HUD is first created. Here you can
        // define various default values.
        // For example, HUD fonts are commonly
        // created here.
		super.Init();
		SetSize(32, 320, 200);
		diparms = InventoryBarState.Create();
		initFonts();
		statsCollector = RwHudArtifactStatsCollector.Create();
    }

    override void Draw(int state, double ticFrac)
    {
        // This is where you draw the things you can
        // see in the HUD. This function is called
        // every frame, so the frequency of its calls
        // depends on the player's framerate.
		Super.Draw(state, ticFrac);
		
		if (state == HUD_StatusBar)
        {
            BeginStatusBar();
            DrawMainBar(TicFrac);
			// DrawString(itemStatsFont, "Don't use this HUD size please", (0, 0), DI_SCREEN_CENTER|DI_TEXT_ALIGN_CENTER);
			// DrawWeaponInHandsInfo();
			// DrawPickupableWeaponInfo();
        }
        else if (state == HUD_Fullscreen)
        {
            BeginHUD();
            DrawFullScreenStuff();
			DrawPickupableItemInfo();
			if (RwPlayer(CPlayer.mo).showStatsButtonPressedTicks > TICRATE/3) {
				DrawFullCurrentItemsInfo();
			} else {
				DrawShortCurrentItemsInfo();
			}
			DrawPlayerStatusEffects();
			DrawCurrentTargetHPBar();
			DrawPlayerExperienceInfo();
        }
    }

    override void Tick()
    {
		super.Tick();
        // Similarly to actors, HUDs have this function,
        // and it's called every tic, i.e. 35 times per
        // second, regardless of framerate.
        // You can't draw anything here, but it's good
        // for things that need to happen on a fixed
        // timed basis.
    }

	protected void DrawFullScreenStuff()
	{
		Vector2 iconbox = (40, 20);
		// Draw health
		let berserk = CPlayer.mo.FindInventory("PowerStrength");
		DrawImage(berserk? "PSTRA0" : "MEDIA0", (20, -2));
		DrawString(mHUDFont, FormatNumber(CPlayer.health, 3), (44, -20));

		Inventory ammotype1, ammotype2;
		[ammotype1, ammotype2] = GetCurrentAmmo();
		int invY = -20;
		if (ammotype1 != null) {
			DrawInventoryIcon(ammotype1, (-14, -4));
			DrawString(mHUDFont, FormatNumber(ammotype1.Amount, 3), (-30, -20), DI_TEXT_ALIGN_RIGHT);
			invY -= 20;
		}
		if (ammotype2 != null && ammotype2 != ammotype1) {
			DrawInventoryIcon(ammotype2, (-14, invY + 17));
			DrawString(mHUDFont, FormatNumber(ammotype2.Amount, 3), (-30, invY), DI_TEXT_ALIGN_RIGHT);
			invY -= 20;
		}
		if (!isInventoryBarVisible() && !Level.NoInventoryBar && CPlayer.mo.InvSel != null) {
			DrawInventoryIcon(CPlayer.mo.InvSel, (-14, invY), DI_DIMDEPLETED);
			DrawString(mHUDFont, FormatNumber(CPlayer.mo.InvSel.Amount, 3), (-30, invY - 21), DI_TEXT_ALIGN_RIGHT);
		}
		DrawFullscreenKeys();

		if (isInventoryBarVisible()) {
			DrawInventoryBar(diparms, (0, 0), 7, DI_SCREEN_CENTER_BOTTOM, HX_SHADOW);
		}
	}
}
