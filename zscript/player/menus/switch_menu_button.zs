class SwitchMenuButton : ZFButton {

    const buttonSpriteSize = 25; // It's not the same as "real" button width, as we need the labels to be "hoverable" as well
    int buttonPosition;
    string switchTo;

    static SwitchMenuButton Make(ZFHandler handler, int x, int y, string name, string switchesToMenu, int buttonPosition = -1) {
        // Textures for the button
        let buttonIdle = ZFBoxTextures.CreateSingleTexture("graphics/ZForms/SwitchMenuRightButtonIdle.png", true);
        // let buttonHover = ZFBoxTextures.CreateSingleTexture("graphics/ZForms/SmallButtonHovered.png", true);
        // let buttonClick = ZFBoxTextures.CreateSingleTexture("graphics/ZForms/SmallButtonClicked.png", true);

        let newButton = new('SwitchMenuButton');
        newButton.config(name, handler, '', buttonIdle, buttonIdle, buttonIdle, holdInterval: TICRATE/3);
        newButton.switchTo = switchesToMenu;
        // Real width is the width of the drawn button plus the width of the text.
        newButton.textColor = Font.CR_DARKGREEN;
        newButton.textScale = 2.;
        newButton.setBox((x, y), (buttonSpriteSize + 5 + newButton.fnt.StringWidth(newButton.text) * newButton.textScale, buttonSpriteSize));
        newButton.buttonPosition = buttonPosition;
        return newButton;
    }

    override void drawer() {
        Vector2 textSize = (fnt.stringWidth(text), fnt.getHeight()) * textScale;
        Vector2 textPos;
        ZFBoxTextures texture;
        switch (buttonPosition) {
            case -1:
                texture = textures[curButtonState];
                drawBox((0, 0), (buttonSpriteSize, box.size.y), texture, true);
                // draw the text to the right of the drawn button
                textPos = (buttonSpriteSize + buttonSpriteSize/3, (box.size.y - textSize.y) / 2); // (box.size - textSize) / 2;
                drawText(textPos, fnt, text, textColor, textScale);
                return;
            case 0:
                textPos = (buttonSpriteSize + buttonSpriteSize/3, (box.size.y - textSize.y) / 2); // (box.size - textSize) / 2;
                drawText(textPos, fnt, text, textColor, textScale);
                return;
            case 1:
                // draw the text to the left of the drawn button
                textPos = (0, (box.size.y - textSize.y) / 2); // (box.size - textSize) / 2;
                drawText(textPos, fnt, text, textColor, textScale);
                texture = textures[curButtonState];
                drawBox((textSize.X+5, 0), (buttonSpriteSize, box.size.y), texture, true);
                return;
        }
	}

    void OnClick() {
        curButtonState = ButtonState_Inactive;
    }
}
