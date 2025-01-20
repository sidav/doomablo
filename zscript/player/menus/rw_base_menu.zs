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
        SetBaseResolution ((menuW, menuH));
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