class RWArtifactsMenu : ZFGenericMenu {
    const menuW = 960;
    const menuH = 540;
    Font smallFont; // A font to use for text.
    Font descrFont;
    ZFImage background; // A background image.
    ArtifactsMenuHandler handler;

    array<ArtifactButton> artifactButtons;
    array<ZFLabel> DescriptionLabels;
    int currLabelLine;

    override void Init(Menu parent) {
        Super.Init(parent); // Call GenericMenu's 'Init' function to do some required initialization.
        SetBaseResolution ((menuW, menuH));
        smallFont = Font.GetFont("SmallFont"); // Get the smallfont.
        descrFont = Font.GetFont("mdesfont");
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

        let equippedLabel = ZFLabel.Create( (0, 125), (menuW/3, smallFont.GetHeight() * 2),
            text: "Equipped:",
            fnt: smallFont, Alignment: 2, wrap: true, autoSize: true, textScale: 2., textColor: Font.CR_WHITE);
        equippedLabel.Pack(mainFrame);

        let plr = RwPlayer(players[consoleplayer].mo);
        currentHeight = 160;
        // Weapon in hands:
        if (RandomizedWeapon(players[consoleplayer].ReadyWeapon)) {
            addArtifactButton(RandomizedWeapon(players[consoleplayer].ReadyWeapon));
        }
        // Armor
        if (plr.CurrentEquippedArmor) {
            addArtifactButton(plr.CurrentEquippedArmor);
        }
        // Backpack:
        if (plr.CurrentEquippedBackpack) {
            addArtifactButton(plr.CurrentEquippedBackpack);
        }

        // for (let sid = 0; sid < RwPlayerStats.totalStatsCount; sid++) {
        //     addLevelUpButton(sid);
        // }
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

    const descrCenterX = 360;
    void pushDescription(string text, int color, double scale = 1., int alignment = AlignType_HCenter) {
        let lbl = ZFLabel.Create(
            (descrCenterX, 100 + (descrFont.GetHeight() + 3) * currLabelLine), (570, descrFont.GetHeight() + 4),
            text: text, // will be overwritten
            fnt: descrFont, Alignment: alignment, wrap: false, autoSize: false, textScale: scale, textColor: color);
        DescriptionLabels.Push(lbl);
        lbl.Pack(mainFrame);
        currLabelLine++;
    }

    const rightColumnOffset = 100;
    void pushTwoColumnsDescription(string textLeft, string textRight, int color) {
        let yCoord = 100 + (descrFont.GetHeight() + 3) * currLabelLine;
        let leftWidth = 280;
        let lbl = ZFLabel.Create(
            (descrCenterX+rightColumnOffset, yCoord), (leftWidth, descrFont.GetHeight() + 4),
            text: textLeft, // will be overwritten
            fnt: descrFont, Alignment: AlignType_CenterLeft, wrap: false, autoSize: false, textScale: 1., textColor: color);
        DescriptionLabels.Push(lbl);
        lbl.Pack(mainFrame);
        lbl = ZFLabel.Create(
            (descrCenterX+rightColumnOffset+leftWidth, yCoord), (250, descrFont.GetHeight() + 4),
            text: textRight, // will be overwritten
            fnt: descrFont, Alignment: AlignType_CenterLeft, wrap: false, autoSize: false, textScale: 1., textColor: color);
        DescriptionLabels.Push(lbl);
        lbl.Pack(mainFrame);
        currLabelLine++;
    }

    enum AlignType {
		AlignType_Left    = 1,
		AlignType_HCenter = 2,
		AlignType_Right   = 3,

		AlignType_Top     = 1 << 4,
		AlignType_VCenter = 2 << 4,
		AlignType_Bottom  = 3 << 4,

		AlignType_TopLeft   = AlignType_Top | AlignType_Left,
		AlignType_TopCenter = AlignType_Top | AlignType_HCenter,
		AlignType_TopRight  = AlignType_Top | AlignType_Right,

		AlignType_CenterLeft  = AlignType_VCenter | AlignType_Left,
		AlignType_Center      = AlignType_VCenter | AlignType_HCenter,
		AlignType_CenterRight = AlignType_VCenter | AlignType_Right,

		AlignType_BottomLeft   = AlignType_Bottom | AlignType_Left,
		AlignType_BottomCenter = AlignType_Bottom | AlignType_HCenter,
		AlignType_BottomRight  = AlignType_Bottom | AlignType_Right,
	}
}
