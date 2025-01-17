extend class RwHudArtifactStatsCollector {

    void collectRWBackpackStats(RWBackpack bkpk, RWBackpack bkpkCmp) {
        string compareStr = "";
        let compareClr = Font.CR_White;

        if (bkpkCmp && bkpk.stats.maxBull != bkpkCmp.stats.maxBull) {
            compareStr = " ("..intToSignedStr(bkpk.stats.maxBull - bkpkCmp.stats.maxBull)..")";
            compareClr = GetDifferenceColor(bkpk.stats.maxBull - bkpkCmp.stats.maxBull);
        } else {
            compareStr = "";
            compareClr = Font.CR_White;
        }
        addTwoLabelsLine("Max bullets:", bkpk.stats.maxBull..compareStr,
                    Font.CR_White, compareClr);

        // SHELLS
        if (bkpkCmp && bkpk.stats.maxShel != bkpkCmp.stats.maxShel) {
            compareStr = " ("..intToSignedStr(bkpk.stats.maxShel - bkpkCmp.stats.maxShel)..")";
            compareClr = GetDifferenceColor(bkpk.stats.maxShel - bkpkCmp.stats.maxShel);
        } else {
            compareStr = "";
            compareClr = Font.CR_White;
        }
        addTwoLabelsLine("Max shells:", bkpk.stats.maxShel..compareStr,
                    Font.CR_White, compareClr);

        // ROCKETS
        if (bkpkCmp && bkpk.stats.maxRckt != bkpkCmp.stats.maxRckt) {
            compareStr = " ("..intToSignedStr(bkpk.stats.maxRckt - bkpkCmp.stats.maxRckt)..")";
            compareClr = GetDifferenceColor(bkpk.stats.maxRckt - bkpkCmp.stats.maxRckt);
        } else {
            compareStr = "";
            compareClr = Font.CR_White;
        }
        addTwoLabelsLine("Max Rockets:", bkpk.stats.maxRckt..compareStr,
                    Font.CR_White, compareClr);

        // CELLS
        if (bkpkCmp && bkpk.stats.maxCell != bkpkCmp.stats.maxCell) {
            compareStr = " ("..intToSignedStr(bkpk.stats.maxCell - bkpkCmp.stats.maxCell)..")";
            compareClr = GetDifferenceColor(bkpk.stats.maxCell - bkpkCmp.stats.maxCell);
        } else {
            compareStr = "";
            compareClr = Font.CR_White;
        }
        addTwoLabelsLine("Max Cells:", bkpk.stats.maxCell..compareStr,
                    Font.CR_White, compareClr);

        addSeparatorLine();

        foreach (aff : bkpk.appliedAffixes) {
            addAffixDescriptionLine(aff);
        }
    }

}