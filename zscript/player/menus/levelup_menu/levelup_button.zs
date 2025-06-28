class LevelUpButton : ZFButton {

    const drawnButtonSize = 30; // It's not the same as "real" button width, as we need the labels to be "hoverable" as well
    int statId;

    static LevelUpButton Make(ZFHandler handler, int x, int y, int idOfStat) {
        // Textures for the button
        let buttonIdle = ZFBoxTextures.CreateSingleTexture("graphics/ZForms/SmallButtonIdle.png", true);
        let buttonHover = ZFBoxTextures.CreateSingleTexture("graphics/ZForms/SmallButtonHovered.png", true);
        let buttonClick = ZFBoxTextures.CreateSingleTexture("graphics/ZForms/SmallButtonClicked.png", true);

        let newButton = new('LevelUpButton');
        newButton.config("Overwritten", handler, '', buttonIdle, buttonHover, buttonClick, holdInterval: TICRATE/3);
        newButton.statId = idOfStat;
        newButton.setText();
        // Real width is the width of the drawn button plus the width of the text.
        newButton.textScale = 2.;
        newButton.setBox((x, y), (drawnButtonSize + 5 + newButton.fnt.StringWidth(newButton.text) * newButton.textScale, drawnButtonSize));
        return newButton;
    }

    override void drawer() {
        let plr = RwPlayer(players[consoleplayer].mo);
        if (plr.stats.canStatBeIncreased(statId)) {
            ZFBoxTextures textures = textures[curButtonState];
            // Notice: overriding drawn button width here
            drawBox((0, 0), (drawnButtonSize, box.size.y), textures, true);
            textColor = Font.CR_GOLD;
        } else {
            textColor = Font.CR_GREEN;
        }
		// draw the text to the right of the drawn button
		Vector2 textSize = (fnt.stringWidth(text), fnt.getHeight()) * textScale;
		Vector2 textPos = (drawnButtonSize + drawnButtonSize/3, (box.size.y - textSize.y) / 2); // (box.size - textSize) / 2;
		drawText(textPos, fnt, text, textColor, textScale);
	}

    void setText() {
        let plr = RwPlayer(players[consoleplayer].mo);
        if (plr == null) return;
        text = plr.stats.getStatButtonText(statId);
    }

    string getDescription() {
        let plr = RwPlayer(players[consoleplayer].mo);
        if (plr == null) return "No description";
        return plr.stats.getStatButtonDescription(statId);
    }

    void OnClick() {
        currentHoldTicsRemaining = 0;
        let plr = RwPlayer(players[consoleplayer].mo);
        if (plr == null || !plr.stats.canStatBeIncreased(statId)) return;
        plr.stats.doIncreaseBaseStat(statId);
        setText();
    }
}
