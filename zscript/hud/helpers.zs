extend class MyCustomHUD {

    int currentLineHeight;

    void PrintLine(string line, HUDFont fnt, int flags, int trans) {
        DrawString(fnt, line,
            (80, currentLineHeight), flags, trans);
        currentLineHeight += fnt.mFont.GetHeight();
    }

    void PrintTableLine(string line1, string line2, int desiredWidth, HUDFont fnt, int flags, int trans) {
        desiredWidth = max(fnt.mFont.StringWidth(line1)+4, desiredWidth);
        DrawString(fnt, line1,
            (80, currentLineHeight), flags, trans);
        DrawString(fnt, line2,
            (80+desiredWidth, currentLineHeight), flags, trans);
        currentLineHeight += fnt.mFont.GetHeight();
    }
}