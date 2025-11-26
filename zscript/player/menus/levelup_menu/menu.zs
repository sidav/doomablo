class RWLevelupMenu : RwBaseMenu {
    const buttonMargin = 5;
    LevelupMenuHandler handler;

    array<LevelUpButton> lvlUpButtons;
    ZFLabel ExpPointsLabel;
    ZFLabel AvailableStatPointsLabel;
    ZFLabel DescriptionLabel;

    override void Init(Menu parent) {
        Super.Init(parent); // Call GenericMenu's 'Init' function to do some required initialization.
        handler = new('LevelupMenuHandler');
        handler.link = self;
        // Add a background.
        background = ZFImage.Create((0, 0),(menuW, menuH),"graphics/ZForms/PlayerStatsMenuPanel.png", ZFImage.AlignType_Center);
        background.Pack(mainFrame); // Add the image element into the main frame.
        
        let TitleLabel = ZFLabel.Create( (35, 27), (menuW - menuW/10, smallFont.GetHeight() * 2),
            text: "CHARACTER",
            fnt: smallFont, Alignment: 2, wrap: true, autoSize: true, textScale: 2., textColor: Font.CR_WHITE);
        TitleLabel.Pack(mainFrame);

        // Temporarily disabled.
        // let switchBtn = SwitchMenuButton.Make(handler, 745, 505, "Equipment", 'RWEquippedArtifactsMenu', 1);
        // switchBtn.Pack(mainFrame);

        let plr = RwPlayer(players[consoleplayer].mo);

        let InfernoLabel = ZFLabel.Create( (35, 60), (menuW - menuW/10, smallFont.GetHeight() * 2),
            text: "Inferno level "..plr.infernoLevel..": "..plr.GetFluffNameForInfernoLevel(plr.infernoLevel),
            fnt: smallFont, Alignment: AlignType_Center, wrap: true, autoSize: true, textScale: 2., textColor: Font.CR_RED);
        InfernoLabel.Pack(mainFrame);

        let ExpLevelLabel = ZFLabel.Create( (35, 95), (menuW - menuW/10, smallFont.GetHeight() * 2),
            text: "You are of level "..plr.stats.currentExpLevel..", the "..plr.GetFluffNameForPlayerLevel(),
            fnt: smallFont, Alignment: 2, wrap: true, autoSize: true, textScale: 2., textColor: Font.CR_BLUE);
        ExpLevelLabel.Pack(mainFrame);

        ExpPointsLabel = ZFLabel.Create( (35, 115), (menuW - menuW/10, smallFont.GetHeight() * 2),
            text: "", // will be overwritten
            fnt: smallFont, Alignment: 2, wrap: true, autoSize: true, textScale: 2., textColor: Font.CR_BLUE);
        ExpPointsLabel.Pack(mainFrame);

        AvailableStatPointsLabel = ZFLabel.Create( (20, 150), (4*menuW/6, smallFont.GetHeight() * 2),
            text: "", // will be overwritten
            fnt: smallFont, Alignment: AlignType_Left, wrap: false, autoSize: false, textScale: 2., textColor: Font.CR_SAPPHIRE);
        AvailableStatPointsLabel.Pack(mainFrame);

        DescriptionLabel = ZFLabel.Create( (535, 160), (370, 360),
            text: "", // will be overwritten
            fnt: descriptionFont, Alignment: 2, wrap: true, autoSize: true, textScale: 1., textColor: Font.CR_GRAY);
        DescriptionLabel.Pack(mainFrame);

        currentHeight = 175;
        for (let sid = 0; sid < RwPlayerStats.nonHiddenStatsCount; sid++) {
            addLevelUpButton(sid);
        }
        setBasicDescription();
    }

    override void Ticker() {
        super.Ticker();
        let plr = RwPlayer(players[consoleplayer].mo);
        if (plr != null) {
            ExpPointsLabel.text = plr.stats.GetFullXpString();
            if (plr.stats.statPointsAvailable > 0) {
                AvailableStatPointsLabel.text = "Stat points available: "..plr.stats.statPointsAvailable;
            } else {
                AvailableStatPointsLabel.text = "";
            }
        }
    }

    int currentHeight;
    private void addLevelUpButton(int id) {
        let newButton = LevelUpButton.Make(handler, 20, currentHeight, id);
        currentHeight += newButton.box.size.y + buttonMargin;
        // Add the button element into the main frame.
        lvlUpButtons.Push(newButton);
        newButton.Pack(mainFrame);
    }

    void setBasicDescription() {
        DescriptionLabel.text = 
        "Hover over a stat to see its description.\n"..
        "If you have spare stat points, press the appropriate button to increase your stat.";
    }
}
