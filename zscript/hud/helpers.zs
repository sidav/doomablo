extend class MyCustomHUD {

    const defaultLeftStatsPosX = 30;
    const defaultLeftStatsPosY = -36;
    const defaultRightStatsPosX = 80;
    const defaultRightStatsPosY = 0;
    int currentLineHeight;
    // A width of stats TEXT TABLE (width between left and right labels, like Damage.............1-5).
    const pickupableStatsTableWidth = 185;
    const leftOffsetForStats = 6;
    const leftOffsetForAffixes = 10;

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
            return "Press "..GetKeysStrForCommand("+use", true).." to "..actionStr..":";
        } else {
            return "Hold "..GetKeysStrForCommand("+user1", true).." to scrap:";
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
        RwHudStatLine line;
        let fontToUse = itemStatsFont;
        foreach (line : statsCollector.statLines) {
            if (line.isSeparator) continue;
            let xOffset = leftOffsetForStats;
            if (line.isTitleLine) {
                xOffset = 0;
                fontToUse = itemNameFont;
            }
            if (line.isAffixLine) xOffset = leftOffsetForAffixes;
            PrintTableLineAt(line.mainLabel, line.rightLabel,
                        x+xOffset, y, tableWidth,
                        fontToUse, textFlags, line.mainColor, line.rightColor);
        }
    }

    private void DimScreenForPickupableStats() {
        maybeRecalcDimRectSize();
        let x = (defaultLeftStatsPosX - 5) * CleanXFac_1;
        let y = Screen.GetHeight()/2 + (defaultLeftStatsPosY - 10) * CleanYFac_1;
        let w = dimRectWidth;
        let h = dimRectHeight;
        Screen.Dim(0x000000, 0.35, x, y, w, h, STYLE_Translucent);
    }

    private int dimRectWidth; // "caches" the value, so that it won't be recalculated each frame
    private int dimRectHeight;
    private void maybeRecalcDimRectSize() {
        if (!statsCollector.justUpdated) return; // no recalc needed, the value already is in dimRectWidth. 

        int maxW = pickupableStatsTableWidth;
        let fontData = itemStatsFont.mFont;
        foreach (line : statsCollector.statLines) {
            if (line.isSeparator) continue;

            let currentW = 0;
            if (line.isTitleLine)
                currentW = itemNameFont.mFont.StringWidth(line.mainLabel.."__");
            else if (line.isAffixLine)
                currentW = itemStatsFont.mFont.StringWidth(line.mainLabel.."__") + leftOffsetForAffixes;
            else
                currentW = pickupableStatsTableWidth + itemStatsFont.mFont.StringWidth(line.rightLabel.."__") + leftOffsetForStats;

            currentW *= CleanXFac_1; // Scale/aspect correction
            if (currentW > maxW) maxW = currentW;
        }
        dimRectWidth = maxW;

        dimRectHeight = itemStatsFont.mFont.GetHeight() * (statsCollector.statLines.size() + 2);
        dimRectHeight *= CleanYFac_1;
    }
}