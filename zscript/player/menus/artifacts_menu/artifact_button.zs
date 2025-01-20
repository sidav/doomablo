class ArtifactButton : ZFButton {

    int drawnButtonW, drawnButtonH;
    bool active;
    ZFBoxTextures bgHover, bgActive;
    Inventory artifact;

    static ArtifactButton Make(ZFHandler handler, int x, int y, Inventory itm) {
        // Textures for the button
        ZFBoxTextures buttonIdle, buttonHover, buttonClick;
        if (itm) {
            buttonIdle = ZFBoxTextures.CreateSingleTexture(GetItemSpriteAsTextureName(itm), true); // ZFBoxTextures.CreateSingleTexture("graphics/ZForms/SmallButtonIdle.png", true);
            buttonHover = ZFBoxTextures.CreateSingleTexture(GetItemSpriteAsTextureName(itm), true);
            buttonClick = ZFBoxTextures.CreateSingleTexture(GetItemSpriteAsTextureName(itm), true);
        }

        let newButton = new('ArtifactButton');
        if (itm) {
            newButton.bgHover = ZFBoxTextures.CreateSingleTexture("graphics/ZForms/PlayerInvMenuBtnHover.png", true);
            newButton.bgActive = ZFBoxTextures.CreateSingleTexture("graphics/ZForms/PlayerInvMenuBtnActive.png", true);
        }
        [newButton.drawnButtonW, newButton.drawnButtonH] = GetItemSpriteSize(itm);
        newButton.drawnButtonW *= 2;
        newButton.drawnButtonH *= 2;
        newButton.config("", handler, '', buttonIdle, buttonHover, buttonClick, holdInterval: TICRATE/3);
        // Real width is the width of the drawn button plus the width of the text.
        x -= newButton.drawnButtonW/2;
        newButton.setBox((x, y), (newButton.drawnButtonW + 5 + newButton.fnt.StringWidth(newButton.text), newButton.drawnButtonH));
        newButton.artifact = itm;
        return newButton;
    }

    override void drawer() {
        ZFBoxTextures textures = textures[curButtonState];
        if (active) {
            drawBox((0, 0), (drawnButtonW, box.size.y), bgActive, true);
        } else if (curButtonState != ButtonState_Inactive) {
            drawBox((0, 0), (drawnButtonW, box.size.y), bgHover, true);
        }
        if (artifact) {
            drawBox((0, 0), (drawnButtonW, box.size.y), textures, true);
        }
        textColor = Font.CR_GOLD;
	}

    string getDescription() {
        return "";
    }

    static string GetItemSpriteAsTextureName(Inventory item) {
        return TexMan.GetName(item.SpawnState.GetSpriteTexture(0));
    }

    static int, int GetItemSpriteSize(Inventory item) {
        int w, h;
        [w, h] = TexMan.GetSize(item.SpawnState.GetSpriteTexture(0));
        return w, h;
    }
}
