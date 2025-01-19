class RwBaseMenu : ZFGenericMenu {
    ZFImage background; // A background image.
    const menuW = 960;
    const menuH = 540;
    const buttonMargin = 5;
    string switchTo;

    // Fonts
    Font smallFont;
    Font descriptionFont;

    override void Init(Menu parent) {
        Super.Init(parent); // Call GenericMenu's 'Init' function to do some required initialization.
        SetBaseResolution ((menuW, menuH)); // Set our base resolution to 320x200.
        smallFont = Font.GetFont("SmallFont"); // Get the smallfont.
        descriptionFont = Font.GetFont("mdesfont");
    }

    override void Ticker() {
        super.Ticker();
        if (switchTo.Length() > 0) {
            let t = switchTo;
            switchTo = "";
            Menu.SetMenu(t);
        }
    }

}