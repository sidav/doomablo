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
        if (command == "vitality") 
            text = String.Format("Vitality:    %d", plr.stats.vitality);
        if (command == "critchance")
            text = String.Format("Crit chance: %.1f%%", double(plr.stats.critChancePromille)/10);
        if (command == "critdmg")
            text = String.Format("Crit damage: %.1f%%", double(plr.stats.critDamageFactorPromille)/10);
        if (command == "rarefind")
            text = String.Format("Rare find:   +%d", plr.stats.rareFindModifier);
    }

    string getDescription() {
        if (command == "vitality") 
            return "Each point of Vitality increases your maximum HP amount by 1.";
        if (command == "critchance")
            return "Critical hit chance determines the probability to deal increased damage with each hit."
                .." It is a base stat, which can be further modified by items.";
        if (command == "critdmg")
            return "Critical hit damage determines how much percent of damage your critical hits will deal."
                .." It is a base stat, which can be further modified by items.";
        if (command == "rarefind")
            return "Each point of Rare Find stat will progressively raise your chance to find rare items.";
        return "No description";
    }

    void OnClick() {
        let plr = RwPlayer(players[consoleplayer].mo);
        if (plr == null || plr.stats.statPointsAvailable == 0) return;
        
        // TODO: this logic should NOT be in menu!
        plr.stats.statPointsAvailable--;
        if (command == "vitality") 
            plr.stats.vitality++;
        if (command == "critchance")
            plr.stats.critChancePromille += 4;
        if (command == "critdmg")
            plr.stats.critDamageFactorPromille += 5;
        if (command == "rarefind")
            plr.stats.rareFindModifier += 1;

        setText();
    }
}
