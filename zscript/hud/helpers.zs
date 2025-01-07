extend class MyCustomHUD {

    const defaultLeftStatsPosX = 30;
    const defaultLeftStatsPosY = -36;
    const defaultRightStatsPosX = 80;
    const defaultRightStatsPosY = 0;
    int currentLineHeight;

    void PrintLineAt(string line, int x, int y, HUDFont fnt, int flags, int trans) {
        DrawString(fnt, line,
            (x, y+currentLineHeight), flags, trans);
        currentLineHeight += fnt.mFont.GetHeight();
    }

    void PrintEmptyLine(HUDFont fnt) {
        currentLineHeight += fnt.mFont.GetHeight();
    }

    void PrintTableLineAt(string line1, string line2, int x, int y, int desiredWidth, HUDFont fnt, int flags, int leftTrans, int rightTrans = -1) {
        if (rightTrans == -1) {
            rightTrans = leftTrans;
        }
        desiredWidth = max(fnt.mFont.StringWidth(line1)+4, desiredWidth);
        DrawString(fnt, line1,
            (x, y+currentLineHeight), flags, leftTrans);
        DrawString(fnt, line2,
            (x+desiredWidth, y+currentLineHeight), flags, rightTrans);
        currentLineHeight += fnt.mFont.GetHeight();
    }

    // Color for stats comparison
    color GetDifferenceColor(int diff, bool negativeIsBetter = false) {
        if (negativeIsBetter) {
            diff = -diff;
        }
        if (diff < 0) {
            return Font.CR_RED;
        }
        if (diff > 0) {
            return Font.CR_GREEN;
        }
        return Font.CR_BLACK;
    }

    // Color for stats comparison when ranges (e.g. "5-15") are involved
    color GetTwoDifferencesColor(int diff1, int diff2) {
        if ((diff1 > 0 && diff2 > 0) || (diff1 * diff2 == 0 && diff1 + diff2 > 0)) {
            return Font.CR_GREEN;
        }
        if ((diff1 < 0 && diff2 < 0) || (diff1 * diff2 == 0 && diff1 + diff2 < 0)) {
            return Font.CR_RED;
        }
        if (diff1 * diff2 < 0) {
            return Font.CR_YELLOW;
        }
        return Font.CR_WHITE;
    }

    color GetTwoFloatDifferencesColor(float diff1, float diff2) {
        if ((diff1 > 0 && diff2 > 0) || (diff1 * diff2 == 0 && diff1 + diff2 > 0)) {
            return Font.CR_GREEN;
        }
        if ((diff1 < 0 && diff2 < 0) || (diff1 * diff2 == 0 && diff1 + diff2 < 0)) {
            return Font.CR_RED;
        }
        if (diff1 * diff2 < 0) {
            return Font.CR_YELLOW;
        }
        return Font.CR_WHITE;
    }

    const changePickupHintEachTics = 3*TICRATE/2;
    string BuildDefaultPickUpHintStr(string actionStr) {
        if ((level.maptime/changePickupHintEachTics) % 2 == 0) {
            return "Press "..GetKeysStrForCommand("+use").." to "..actionStr..":";
        } else {
            return "Hold "..GetKeysStrForCommand("+user1").." to scrap:";
        }
    }

    string GetKeysStrForCommand(string command, bool onlyFirst = false) {
        array<int> keyIDs;
        bindings.GetAllKeysForCommand(keyIDs, command);
        if (onlyFirst) {
            keyIDs.Resize(1);
            return bindings.NameAllKeys(keyIDs, false);
        }
        let str = bindings.NameAllKeys(keyIDs, false);
        str.Substitute(", ", " or ");
        return str;
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