class ArtifactsMenuHandler : ZFHandler
{
    // The menu this command handler belongs to.
    // We need this to be able to do anything with our menu.
    RWEquippedArtifactsMenu link;
    RwHudArtifactStatsCollector collector;
    const itemTitleScale = 1.1;

    override void buttonClickCommand(ZFButton caller, string command) {
        let aBtn = artifactButton(caller);
        if (aBtn && aBtn.artifact) {
            link.deactivateArtfctBtns();
            aBtn.active = true;
            link.clearDescriptionLabels();
            collector.CollectStatsFromAffixableItem(aBtn.artifact, null, 2);
            pushAllCollectorLines();
        }
        if (SwitchMenuButton(caller)) {
            SwitchMenuButton(caller).OnClick();
            link.switchTo = SwitchMenuButton(caller).switchTo;
        }
    }

    override void elementHoverChanged(ZFElement caller, string command, bool unhovered) {
        if (LevelUpButton(caller)) {
        }
    }

    void pushAllCollectorLines() {
        for (let i = 0; i < collector.statLines.Size(); i++) {
            let line = collector.statLines[i];
            let scale = 0.75;
            if (line.isTitleLine) {
                scale = itemTitleScale;
            }
            if (line.isSeparator) {
                link.pushSeparator();
                continue;
            }
            if (line.rightLabel.Length() > 0) {
                link.pushTwoColumnsDescription(line.mainLabel, line.rightLabel, line.mainColor);
                continue;
            }
            link.pushDescription(line.mainLabel, line.mainColor, scale);
        }
    }
}