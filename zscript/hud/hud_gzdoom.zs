// This contains methods from DoomStatusBar which are NOT changed in this mod.
// It's needed because:
// We need to call Super.Draw() whithout causing base Doom HUD being drawn
// and therefore we inherit our class from BaseStatusBar and not from DoomStatusBar
// But BaseStatusBar doesn't have all the stuff from DoomStatusBar, so I just copy-pasted them from gzdoom source here
extend class MyCustomHUD {
	protected void DrawMainBar (double TicFrac)
	{
		DrawImage("STBAR", (0, 168), DI_ITEM_OFFSETS);
		DrawImage("STTPRCNT", (90, 171), DI_ITEM_OFFSETS);
		DrawImage("STTPRCNT", (221, 171), DI_ITEM_OFFSETS);
		
		Inventory a1 = GetCurrentAmmo();
		if (a1 != null) DrawString(mHUDFont, FormatNumber(a1.Amount, 3), (44, 171), DI_TEXT_ALIGN_RIGHT|DI_NOSHADOW);
		DrawString(mHUDFont, FormatNumber(CPlayer.health, 3), (90, 171), DI_TEXT_ALIGN_RIGHT|DI_NOSHADOW);
		DrawString(mHUDFont, FormatNumber(GetArmorAmount(), 3), (221, 171), DI_TEXT_ALIGN_RIGHT|DI_NOSHADOW);

		DrawBarKeys();
		DrawBarAmmo();
		
		if (deathmatch || teamplay)
		{
			DrawString(mHUDFont, FormatNumber(CPlayer.FragCount, 3), (138, 171), DI_TEXT_ALIGN_RIGHT);
		}
		else
		{
			DrawBarWeapons();
		}
		
		if (multiplayer)
		{
			DrawImage("STFBANY", (143, 168), DI_ITEM_OFFSETS|DI_TRANSLATABLE);
		}
		
		if (CPlayer.mo.InvSel != null && !Level.NoInventoryBar)
		{
			DrawInventoryIcon(CPlayer.mo.InvSel, (160, 198), DI_DIMDEPLETED);
			if (CPlayer.mo.InvSel.Amount > 1)
			{
				DrawString(mAmountFont, FormatNumber(CPlayer.mo.InvSel.Amount), (175, 198-mIndexFont.mFont.GetHeight()), DI_TEXT_ALIGN_RIGHT, Font.CR_GOLD);
			}
		}
		else
		{
			DrawTexture(GetMugShot(5), (143, 168), DI_ITEM_OFFSETS);
		}
		if (isInventoryBarVisible())
		{
			DrawInventoryBar(diparms, (48, 169), 7, DI_ITEM_LEFT_TOP);
		}
		
	}
	
	protected virtual void DrawBarKeys()
	{
		bool locks[6];
		String image;
		for(int i = 0; i < 6; i++) locks[i] = CPlayer.mo.CheckKeys(i + 1, false, true);
		// key 1
		if (locks[1] && locks[4]) image = "STKEYS6";
		else if (locks[1]) image = "STKEYS0";
		else if (locks[4]) image = "STKEYS3";
		DrawImage(image, (239, 171), DI_ITEM_OFFSETS);
		// key 2
		if (locks[2] && locks[5]) image = "STKEYS7";
		else if (locks[2]) image = "STKEYS1";
		else if (locks[5]) image = "STKEYS4";
		else image = "";
		DrawImage(image, (239, 181), DI_ITEM_OFFSETS);
		// key 3
		if (locks[0] && locks[3]) image = "STKEYS8";
		else if (locks[0]) image = "STKEYS2";
		else if (locks[3]) image = "STKEYS5";
		else image = "";
		DrawImage(image, (239, 191), DI_ITEM_OFFSETS);
	}
	
	protected virtual void DrawBarAmmo()
	{
		int amt1, maxamt;
		[amt1, maxamt] = GetAmount("Clip");
		DrawString(mIndexFont, FormatNumber(amt1, 3), (288, 173), DI_TEXT_ALIGN_RIGHT);
		DrawString(mIndexFont, FormatNumber(maxamt, 3), (314, 173), DI_TEXT_ALIGN_RIGHT);
		
		[amt1, maxamt] = GetAmount("Shell");
		DrawString(mIndexFont, FormatNumber(amt1, 3), (288, 179), DI_TEXT_ALIGN_RIGHT);
		DrawString(mIndexFont, FormatNumber(maxamt, 3), (314, 179), DI_TEXT_ALIGN_RIGHT);
		
		[amt1, maxamt] = GetAmount("RocketAmmo");
		DrawString(mIndexFont, FormatNumber(amt1, 3), (288, 185), DI_TEXT_ALIGN_RIGHT);
		DrawString(mIndexFont, FormatNumber(maxamt, 3), (314, 185), DI_TEXT_ALIGN_RIGHT);
		
		[amt1, maxamt] = GetAmount("Cell");
		DrawString(mIndexFont, FormatNumber(amt1, 3), (288, 191), DI_TEXT_ALIGN_RIGHT);
		DrawString(mIndexFont, FormatNumber(maxamt, 3), (314, 191), DI_TEXT_ALIGN_RIGHT);
	}
	
	protected virtual void DrawBarWeapons()
	{
		DrawImage("STARMS", (104, 168), DI_ITEM_OFFSETS);
		DrawImage(CPlayer.HasWeaponsInSlot(2)? "STYSNUM2" : "STGNUM2", (111, 172), DI_ITEM_OFFSETS);
		DrawImage(CPlayer.HasWeaponsInSlot(3)? "STYSNUM3" : "STGNUM3", (123, 172), DI_ITEM_OFFSETS);
		DrawImage(CPlayer.HasWeaponsInSlot(4)? "STYSNUM4" : "STGNUM4", (135, 172), DI_ITEM_OFFSETS);
		DrawImage(CPlayer.HasWeaponsInSlot(5)? "STYSNUM5" : "STGNUM5", (111, 182), DI_ITEM_OFFSETS);
		DrawImage(CPlayer.HasWeaponsInSlot(6)? "STYSNUM6" : "STGNUM6", (123, 182), DI_ITEM_OFFSETS);
		DrawImage(CPlayer.HasWeaponsInSlot(7)? "STYSNUM7" : "STGNUM7", (135, 182), DI_ITEM_OFFSETS);
	}
	
	protected virtual void DrawFullscreenKeys()
	{
		// Draw the keys. This does not use a special draw function like SBARINFO because the specifics will be different for each mod
		// so it's easier to copy or reimplement the following piece of code instead of trying to write a complicated all-encompassing solution.
		Vector2 keypos = (-10, 2);
		int rowc = 0;
		double roww = 0;
		for(let i = CPlayer.mo.Inv; i != null; i = i.Inv)
		{
			if (i is "Key" && i.Icon.IsValid())
			{
				DrawTexture(i.Icon, keypos, DI_SCREEN_RIGHT_TOP|DI_ITEM_LEFT_TOP);
				Vector2 size = TexMan.GetScaledSize(i.Icon);
				keypos.Y += size.Y + 2;
				roww = max(roww, size.X);
				if (++rowc == 3)
				{
					keypos.Y = 2;
					keypos.X -= roww + 2;
					roww = 0;
					rowc = 0;
				}
			}
		}
	}
}