class RWLevelupMenu : ZFGenericMenu {
    const menuW = 480;
    const menuH = 300;
    const buttonMargin = 5;
    Font smallFont; // A font to use for text.
    ZFImage background; // A background image.
    LevelupMenuHandler handler;

    array<LevelUpButton> lvlUpButtons;
    ZFLabel ExpPointsLabel;
    ZFLabel DescriptionLabel;

    override void Init(Menu parent) {
        Super.Init(parent); // Call GenericMenu's 'Init' function to do some required initialization.
        SetBaseResolution ((menuW, menuH)); // Set our base resolution to 320x200.
        smallFont = Font.GetFont("SmallFont"); // Get the smallfont.
        handler = new('LevelupMenuHandler');
        handler.link = self;
        // Add a background.
        background = ZFImage.Create((0, 0),(menuW, menuH),"graphics/ZForms/PlayerStatsMenuPanel.png", ZFImage.AlignType_Center);
        background.Pack(mainFrame); // Add the image element into the main frame.
        
        let TitleLabel = ZFLabel.Create( (35, 25), (menuW - menuW/10, smallFont.GetHeight() * 2),
            text: "CHARACTER SCREEN",
            fnt: smallFont, Alignment: 2, wrap: true, autoSize: true, textColor: Font.CR_WHITE);
        TitleLabel.Pack(mainFrame);

        let plr = RwPlayer(players[consoleplayer].mo);

        let ExpLevelLabel = ZFLabel.Create( (35, 40), (menuW - menuW/10, smallFont.GetHeight() * 2),
            text: "You are of level "..plr.currentExpLevel..", the "..plr.GetFluffNameForPlayerLevel(),
            fnt: smallFont, Alignment: 2, wrap: true, autoSize: true, textColor: Font.CR_WHITE);
        ExpLevelLabel.Pack(mainFrame);

        ExpPointsLabel = ZFLabel.Create( (35, 50), (menuW - menuW/10, smallFont.GetHeight() * 2),
            text: "", // will be overwritten
            fnt: smallFont, Alignment: 2, wrap: true, autoSize: true);
        ExpPointsLabel.Pack(mainFrame);

        DescriptionLabel = ZFLabel.Create( (260, 80), (192, 180),
            text: "", // will be overwritten
            fnt: smallFont, Alignment: 2, wrap: true, autoSize: true, textColor: Font.CR_GRAY);
        DescriptionLabel.Pack(mainFrame);

        currentHeight = 80;
        addLevelUpButton("baseVitality");
        addLevelUpButton("critchance");
        addLevelUpButton("critdmg");
        addLevelUpButton("meleedmg");
        addLevelUpButton("rarefind");
    }

    override void Ticker() {
        let plr = RwPlayer(players[consoleplayer].mo);
        if (plr != null) {
            if (plr.stats.statPointsAvailable > 0) {
                ExpPointsLabel.text = "Stat points available: "..plr.stats.statPointsAvailable;
                ExpPointsLabel.textColor = Font.CR_GOLD;
            } else {
                ExpPointsLabel.text = String.Format("EXP: %.0f/%.0f (%.1f%%)", 
                    (plr.currentExperience, plr.getRequiredXPForNextLevel(), plr.getXPPercentageForNextLevel()));
                ExpPointsLabel.textColor = Font.CR_GRAY;
            }
        }
    }

    int currentHeight;
    private void addLevelUpButton(string command) {
        let newButton = LevelUpButton.Make(handler, 20, currentHeight, command);
        currentHeight += newButton.box.size.y + buttonMargin;
        // Add the button element into the main frame.
        lvlUpButtons.Push(newButton);
        newButton.Pack(mainFrame);
    }
}
