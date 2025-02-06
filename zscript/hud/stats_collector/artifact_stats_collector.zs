// Reusable class which collects item's stats as printable RwHudStatLine array
class RwHudArtifactStatsCollector {
    array <RwHudStatLine> statLines;
    Inventory lastCollectedItem; // To prevent redundant calculations
    Inventory lastCollectedComparisonItem; // To prevent redundant calculations

    static RwHudArtifactStatsCollector Create() {
        return new('RwHudArtifactStatsCollector');
    }

    void CollectStatsFromAffixableItem(Inventory itm, Inventory itemToCompareWith, int lines) {
        if (itm == lastCollectedItem && lastCollectedComparisonItem == itemToCompareWith) return;

        clearAllLines();
        addHeaderLinesForAffixable(itm, lines);
        addSeparatorLine();
        if (RandomizedWeapon(itm)) {
            collectRWWeaponStats(RandomizedWeapon(itm), RandomizedWeapon(itemToCompareWith));
        } else if (RandomizedArmor(itm)) {
            collectRWArmorStats(RandomizedArmor(itm), RandomizedArmor(itemToCompareWith));
        } else if (RwBackpack(itm)) {
            collectRWBackpackStats(RwBackpack(itm), RwBackpack(itemToCompareWith));
        } else if (RwFlask(itm)) {
            collectRWFlaskStats(RwFlask(itm), RwFlask(itemToCompareWith));
        }
        lastCollectedItem = itm;
        lastCollectedComparisonItem = itemToCompareWith;
    }
    
    // Line-adding methods
    void clearAllLines() {
        statLines.Resize(0);
    }

    void addSimpleLine(string label, int color) {
        let newLine = new('RwHudStatLine');
        newLine.mainLabel = label;
        newLine.mainColor = color;
        statLines.push(newLine);
    }

    void addTitleLine(string label, int color) {
        let newLine = new('RwHudStatLine');
        newLine.mainLabel = label;
        newLine.mainColor = color;
        newLine.isTitleLine = true;
        statLines.push(newLine);
    }

    void addTwoLabelsLine(string leftLabel, string rightLabel, int leftColor, int rightColor) {
        let newLine = new('RwHudStatLine');
        newLine.mainLabel = leftLabel;
        newLine.mainColor = leftColor;
        newLine.rightLabel = rightLabel;
        newLine.rightColor = rightColor;
        statLines.push(newLine);
    }

    void addSeparatorLine() {
        let newLine = new('RwHudStatLine');
        newLine.isSeparator = true;
        statLines.push(newLine);
    }

    // Utility methods

    private string makeDamageDifferenceString(float mind1, float maxd1, float mind2, float maxd2) {
        if (mind1 == mind2 && maxd1 == maxd2) {
            return "";
        }
        return " ("..floatToSignedStr(mind1 - mind2)..", "..floatToSignedStr(maxd1-maxd2)..")";
    }

    private string floatToSignedStr(float v) {
        if (v > 0) {
            return String.Format("+%.1f", v);
        }
        return String.Format("%.1f", v);
    }

    string intToSignedStr(int v) {
        if (v > 0) {
            return "+"..v;
        }
        return ""..v;
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
}
