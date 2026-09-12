extend class RwHudArtifactStatsCollector {

    void collectRWRelicStats(RwRelic rel, RwRelic relCmp) {
        string compareStr = "";
        let compareClr = Font.CR_White;
        
        foreach (aff : rel.appliedAffixes) {
            addAffixDescriptionLine(aff);
        }
    }

}