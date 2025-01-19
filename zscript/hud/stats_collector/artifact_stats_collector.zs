// Reusable class which collects item's stats as printable RwHudStatLine array
class RwHudArtifactStatsCollector {
    array <RwHudStatLine> statLines;
    Inventory lastCollectedItem; // To prevent redundant calculations
    Inventory lastCollectedComparisonItem; // To prevent redundant calculations

    static RwHudArtifactStatsCollector Create() {
        return new('RwHudArtifactStatsCollector');
    }

    void CollectStatsFromAffixableItem(Inventory itm, Inventory itemToCompareWith) {
        if (itm == lastCollectedItem && lastCollectedComparisonItem == itemToCompareWith) return;

        clearAllLines();
        if (RandomizedWeapon(itm)) {
            collectRWWeaponStats(RandomizedWeapon(itm), RandomizedWeapon(itemToCompareWith));
        } else if (RandomizedArmor(itm)) {
            collectRWArmorStats(RandomizedArmor(itm), RandomizedArmor(itemToCompareWith));
        } else if (RwBackpack(itm)) {
            collectRWBackpackStats(RwBackpack(itm), RwBackpack(itemToCompareWith));
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

    void addAffixDescriptionLine(Affix aff) {

        let clr = Font.CR_White;
        if (aff.isSuffix()) {
            if (aff.getAlignment() > 0) {
                clr = Font.CR_TEAL;
            } else if (aff.getAlignment() < 0) {
                clr = Font.CR_CREAM;
            }
        } else {
            if (aff.getAlignment() > 0) {
                clr = Font.CR_GREEN;
            } else if (aff.getAlignment() < 0) {
                clr = Font.CR_RED;
            }
        }

        string label = "* ";
        if (RwSettingsShowAffixNamesInTables) {
            label = label..aff.getName()..": ";
        }
        label = label..aff.getDescription();

        let newLine = new('RwHudStatLine');
        newLine.mainLabel = label;
        newLine.mainColor = clr;
        newLine.isAffixLine = true;
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
            return String.Format("+%.2f", v);
        }
        return String.Format("%.2f", v);
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

// "rightLabel" and "rightColor" are optional and needed for table-like output
class RwHudStatLine {
    string mainLabel, rightLabel;
    int mainColor, rightColor;
    bool isSeparator, isAffixLine;
}
