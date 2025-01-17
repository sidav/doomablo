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

    void printAllCollectorLines(int x, int y, int tableWidth, int textFlags) {
        int xOffset = 0;
        RwHudStatLine line;
        foreach (line : statsCollector.statLines) {
            if (line.isSeparator) continue;
            if (line.isAffixLine) xOffset = 5;
            PrintTableLineAt(line.mainLabel, line.rightLabel,
                        x+xOffset, y, tableWidth,
                        itemStatsFont, textFlags, line.mainColor, line.rightColor);
        }
    }
}