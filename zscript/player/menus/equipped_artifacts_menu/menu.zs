class RWEquippedArtifactsMenu : RwBaseMenu {
    ArtifactsMenuHandler handler;

    array<ArtifactButton> artifactButtons;
    array<ZFLabel> DescriptionLabels;
    int currLabelLine;

    override void Init(Menu parent) {
        Super.Init(parent); // Call GenericMenu's 'Init' function to do some required initialization.
        handler = new('ArtifactsMenuHandler');
        handler.collector = RwHudArtifactStatsCollector.Create();
        handler.link = self;
        // Add a background.
        background = ZFImage.Create((0, 0),(menuW, menuH),"graphics/ZForms/PlayerInvMenuPanel.png", ZFImage.AlignType_Center);
        background.Pack(mainFrame); // Add the image element into the main frame.
        
        let TitleLabel = ZFLabel.Create( (0, 30), (menuW - menuW/10, smallFont.GetHeight() * 2),
            text: "ARTIFACTS",
            fnt: smallFont, Alignment: AlignType_HCenter, wrap: true, autoSize: true, textScale: 2., textColor: Font.CR_WHITE);
        TitleLabel.Pack(mainFrame);

        // Disabled on purpose (for now)
        // let switchBtn = SwitchMenuButton.Make(handler, 745, 505, "Stats", 'RWLevelupMenu', 1);
        // switchBtn.Pack(mainFrame);

        let equippedLabel = ZFLabel.Create( (0, 125), (menuW/3, smallFont.GetHeight() * 2),
            text: "Equipped:",
            fnt: smallFont, Alignment: 2, wrap: true, autoSize: true, textScale: 2., textColor: Font.CR_WHITE);
        equippedLabel.Pack(mainFrame);

        let plr = RwPlayer(players[consoleplayer].mo);
        currentHeight = 160;
        // Weapon in hands:
        if (RwWeapon(players[consoleplayer].ReadyWeapon)) {
            addArtifactButton(RwWeapon(players[consoleplayer].ReadyWeapon));
        }
        // Armor
        if (plr.CurrentEquippedArmor) {
            addArtifactButton(plr.CurrentEquippedArmor);
        }
        // Backpack:
        if (plr.CurrentEquippedBackpack) {
            addArtifactButton(plr.CurrentEquippedBackpack);
        }
        // Flask:
        if (plr.EquippedActiveSlotItem) {
            addArtifactButton(plr.EquippedActiveSlotItem);
        }

        setBasicDescription();
    }

    override void Ticker() {
        super.Ticker();
    }

    int currentHeight;
    const buttonMargin = 6;
    private void addArtifactButton(Inventory itm) {
        let newButton = ArtifactButton.Make(handler, 150, currentHeight, itm);
        currentHeight += newButton.box.size.y + buttonMargin;
        // Add the button element into the main frame.
        artifactButtons.Push(newButton);
        newButton.Pack(mainFrame);
    }

    void deactivateArtfctBtns() {
        for (let i = 0; i < artifactButtons.Size(); i++) {
            artifactButtons[i].active = false;
        }
    }

    void clearDescriptionLabels() {
        for (let i = 0; i < DescriptionLabels.Size(); i++) {
            DescriptionLabels[i].Unpack();
        }
        currLabelLine = 0;
        DescriptionLabels.Resize(0);
    }

    void pushSeparator() {
        pushDescription("-----------------------------------", Font.CR_DARKGRAY);
    }

    const descrCenterX = 375;
    void pushDescription(string text, int color, double scale = 1., int alignment = AlignType_HCenter) {
        let lbl = ZFLabel.Create(
            (descrCenterX, 100 + (descriptionFont.GetHeight() + 3) * currLabelLine), (570, descriptionFont.GetHeight() + 4),
            text: text, // will be overwritten
            fnt: descriptionFont, Alignment: alignment, wrap: false, autoSize: false, textScale: scale, textColor: color);
        DescriptionLabels.Push(lbl);
        lbl.Pack(mainFrame);
        currLabelLine++;
    }

    const rightColumnOffset = 100;
    void pushTwoColumnsDescription(string textLeft, string textRight, int color) {
        let yCoord = 100 + (descriptionFont.GetHeight() + 3) * currLabelLine;
        let leftWidth = 280;
        let lbl = ZFLabel.Create(
            (descrCenterX+rightColumnOffset, yCoord), (leftWidth, descriptionFont.GetHeight() + 4),
            text: textLeft, // will be overwritten
            fnt: descriptionFont, Alignment: AlignType_CenterLeft, wrap: false, autoSize: false, textScale: 1., textColor: color);
        DescriptionLabels.Push(lbl);
        lbl.Pack(mainFrame);
        lbl = ZFLabel.Create(
            (descrCenterX+rightColumnOffset+leftWidth, yCoord), (250, descriptionFont.GetHeight() + 4),
            text: textRight, // will be overwritten
            fnt: descriptionFont, Alignment: AlignType_CenterLeft, wrap: false, autoSize: false, textScale: 1., textColor: color);
        DescriptionLabels.Push(lbl);
        lbl.Pack(mainFrame);
        currLabelLine++;
    }

    void setBasicDescription() {
        static const string descr[] = {
            "Select an item to take a look at its stats.",
            "",
            "Items' base stats are always shown as final,",
            "so they already do include the effects",
            "of item's applied affixes."
        };
        for (int i = 0; i < descr.Size(); i++) {
            pushDescription(descr[i], Font.CR_GRAY);
        }
    }
}
