class LevelUpButton : ZFButton {

    const drawnButtonWidth = 20; // It's not the same as "real" button width, as we need the labels to be "hoverable" as well

    static LevelUpButton Make(ZFHandler handler, int x, int y, string command) {
        // Textures for the button
        let buttonIdle = ZFBoxTextures.CreateSingleTexture("graphics/ZForms/SmallButtonIdle.png", true);
        let buttonHover = ZFBoxTextures.CreateSingleTexture("graphics/ZForms/SmallButtonHovered.png", true);
        let buttonClick = ZFBoxTextures.CreateSingleTexture("graphics/ZForms/SmallButtonClicked.png", true);

        let newButton = new('LevelUpButton');
        newButton.config("Overwritten", handler, command, buttonIdle, buttonHover, buttonClick);
        newButton.setText();
        // Real width is the width of the drawn button plus the width of the text.
        newButton.setBox((x, y), (drawnButtonWidth + 5 + newButton.fnt.StringWidth(newButton.text), 20));
        return newButton;
    }

    override void drawer() {
        let plr = RwPlayer(players[consoleplayer].mo);
        if (plr != null && plr.stats.statPointsAvailable > 0) {
            ZFBoxTextures textures = textures[curButtonState];
            // Notice: overriding drawn button width here
            drawBox((0, 0), (drawnButtonWidth, box.size.y), textures, true);
            textColor = Font.CR_GOLD;
        } else {
            textColor = Font.CR_GREEN;
        }
		// draw the text to the right of the drawn button
		Vector2 textSize = (fnt.stringWidth(text), fnt.getHeight()) * textScale;
		Vector2 textPos = (drawnButtonWidth + drawnButtonWidth/3, (box.size.y - textSize.y) / 2); // (box.size - textSize) / 2;
		drawText(textPos, fnt, text, textColor, textScale);
	}

    void setText() {
        // EventHandler.SendNetworkEvent("playerstatupgrade:"..command, 1, 23, -1);
        text = "Text error; command "..command;
        let plr = RwPlayer(players[consoleplayer].mo);
        if (plr == null) return;
        if (command == "baseVitality") 
            text = plr.stats.getVitButtonName();
        if (command == "critchance")
            text = plr.stats.getCritChancePromilleButtonName();
        if (command == "critdmg")
            text = plr.stats.getCritDmgFactorPromilleButtonName();
        if (command == "rarefind")
            text = plr.stats.getRareFindButtonName();
    }

    string getDescription() {
        let plr = RwPlayer(players[consoleplayer].mo);
        if (plr == null) return "No description";

        if (command == "baseVitality") 
            return plr.stats.getVitButtonDescription();
        if (command == "critchance")
            return plr.stats.getCritChancePromilleButtonDescription();
        if (command == "critdmg")
            return plr.stats.getCritDmgFactorPromilleButtonDescription();
        if (command == "rarefind")
            return plr.stats.getRareFindButtonDescription();
        return "No description";
    }

    void OnClick() {
        let plr = RwPlayer(players[consoleplayer].mo);
        if (plr == null || plr.stats.statPointsAvailable == 0) return;
        
        // TODO: this logic should NOT be in menu!
        if (command == "baseVitality") 
            plr.stats.doIncreaseBaseVitality();
        if (command == "critchance")
            plr.stats.doIncreaseBaseCritChancePromille();
        if (command == "critdmg")
            plr.stats.doIncreaseBaseCritDmgFactorPromille();
        if (command == "rarefind")
            plr.stats.doIncreaseBaseRareFind();

        setText();
    }
}
