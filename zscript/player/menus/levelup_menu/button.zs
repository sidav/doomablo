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
        if (enabled()) {
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

    bool enabled() {
        let plr = RwPlayer(players[consoleplayer].mo);
        if (plr == null) return false;
        if (command == "basevitality") 
            return plr.stats.canIncreaseBaseVitality();
        if (command == "critchance")
            return plr.stats.canIncreaseBaseCritChancePromille();
        if (command == "critdmg")
            return plr.stats.canIncreaseBaseCritDmgFactorPromille();
        if (command == "meleedmg")
            return plr.stats.canIncreaseBaseMeleeDamageLevel();
        if (command == "rarefind")
            return plr.stats.canIncreaseBaseRareFind();
        return false;
    }

    void setText() {
        text = "Text error; command "..command;
        let plr = RwPlayer(players[consoleplayer].mo);
        if (plr == null) return;
        if (command == "basevitality") 
            text = plr.stats.getVitButtonName();
        if (command == "critchance")
            text = plr.stats.getCritChancePromilleButtonName();
        if (command == "critdmg")
            text = plr.stats.getCritDmgFactorPromilleButtonName();
        if (command == "meleedmg")
            text = plr.stats.getMeleeDamageLevelButtonName();
        if (command == "rarefind")
            text = plr.stats.getRareFindButtonName();
    }

    string getDescription() {
        let plr = RwPlayer(players[consoleplayer].mo);
        if (plr == null) return "No description";

        if (command == "basevitality") 
            return plr.stats.getVitButtonDescription();
        if (command == "critchance")
            return plr.stats.getCritChancePromilleButtonDescription();
        if (command == "critdmg")
            return plr.stats.getCritDmgFactorPromilleButtonDescription();
        if (command == "meleedmg")
            return plr.stats.getMeleeDamageLevelButtonDescription();
        if (command == "rarefind")
            return plr.stats.getRareFindButtonDescription();
        return "No description";
    }

    void OnClick() {
        if (!enabled()) {
            return;
        }
        let plr = RwPlayer(players[consoleplayer].mo);
        if (plr == null || plr.stats.statPointsAvailable == 0) return;
        
        // TODO: this logic should NOT be in menu!
        if (command == "basevitality") 
            plr.stats.doIncreaseBaseVitality();
        if (command == "critchance")
            plr.stats.doIncreaseBaseCritChancePromille();
        if (command == "critdmg")
            plr.stats.doIncreaseBaseCritDmgFactorPromille();
        if (command == "meleedmg")
            plr.stats.doIncreaseBaseMeleeDamageLevel();
        if (command == "rarefind")
            plr.stats.doIncreaseBaseRareFind();

        setText();
    }
}
