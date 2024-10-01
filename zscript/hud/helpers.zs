extend class MyCustomHUD {

    const defaultLeftStatsPosX = 40;
    const defaultLeftStatsPosY = -36;
    const defaultRightStatsPosX = 80;
    const defaultRightStatsPosY = 0;
    int currentLineHeight;

    void PrintLineAt(string line, int x, int y, HUDFont fnt, int flags, int trans) {
        DrawString(fnt, line,
            (x, y+currentLineHeight), flags, trans);
        currentLineHeight += fnt.mFont.GetHeight();
    }

    void PrintTableLineAt(string line1, string line2, int x, int y, int desiredWidth, HUDFont fnt, int flags, int trans) {
        desiredWidth = max(fnt.mFont.StringWidth(line1)+4, desiredWidth);
        DrawString(fnt, line1,
            (x, y+currentLineHeight), flags, trans);
        DrawString(fnt, line2,
            (x+desiredWidth, y+currentLineHeight), flags, trans);
        currentLineHeight += fnt.mFont.GetHeight();
    }

    string intToSignedStr(int v) {
        if (v > 0) {
            return "+"..v;
        }
        return ""..v;
    }

    string floatToSignedStr(float v) {
        if (v > 0) {
            return String.Format("+%.2f", v);
        }
        return String.Format("%.2f", v);
    }
}