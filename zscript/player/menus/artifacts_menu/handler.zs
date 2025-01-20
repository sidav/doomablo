class ArtifactsMenuHandler : ZFHandler
{
    // The menu this command handler belongs to.
    // We need this to be able to do anything with our menu.
    RWArtifactsMenu link;
    RwHudArtifactStatsCollector collector;

    override void buttonClickCommand(ZFButton caller, string command) {
        let aBtn = artifactButton(caller);
        if (aBtn && aBtn.artifact) {
            link.deactivateArtfctBtns();
            aBtn.active = true;
            collector.CollectStatsFromAffixableItem(aBtn.artifact, null);
            if (RandomizedWeapon(aBtn.artifact)) {
                setDescriptionForWeapon(RandomizedWeapon(aBtn.artifact));
            } else if (RandomizedArmor(aBtn.artifact)) {
                setDescriptionForArmor(RandomizedArmor(aBtn.artifact));
            } else if (RwBackpack(aBtn.artifact)) {
                setDescriptionForBackpack(RwBackpack(aBtn.artifact));
            }
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
            if (line.isSeparator) {
                link.pushSeparator();
                continue;
            }
            if (line.rightLabel.Length() > 0) {
                link.pushTwoColumnsDescription(line.mainLabel, line.rightLabel, line.mainColor);
                continue;
            }
            link.pushDescription(line.mainLabel, line.mainColor, 0.75);
        }
    }

    void setDescriptionForWeapon(RandomizedWeapon wpn) {
        link.clearDescriptionLabels();
        // MyCustomHUD.PickColorForAffixableItem()
        link.pushDescription(wpn.nameWithAppliedAffixes, 
            MyCustomHUD.PickColorForAffixableItem(wpn), 1.25);
        link.pushDescription("Level "..wpn.generatedQuality.." "..MyCustomHUD.getRarityName(wpn.appliedAffixes.Size()).." "..wpn.rwbaseName,
            MyCustomHUD.PickColorForAffixableItem(wpn), 0.75);

        link.pushSeparator();
        pushAllCollectorLines();
    }

    void setDescriptionForArmor(RandomizedArmor armr) {
        link.clearDescriptionLabels();
        // MyCustomHUD.PickColorForAffixableItem()
        link.pushDescription(armr.nameWithAppliedAffixes, 
            MyCustomHUD.PickColorForAffixableItem(armr), 1.25);
        link.pushDescription("Level "..armr.generatedQuality.." "..MyCustomHUD.getRarityName(armr.appliedAffixes.Size()).." "..armr.rwbaseName,
            MyCustomHUD.PickColorForAffixableItem(armr), 0.75);

        link.pushSeparator();
        pushAllCollectorLines();
    }

    void setDescriptionForBackpack(RwBackpack bkpk) {
        link.clearDescriptionLabels();
        // MyCustomHUD.PickColorForAffixableItem()
        link.pushDescription(bkpk.nameWithAppliedAffixes, 
            MyCustomHUD.PickColorForAffixableItem(bkpk), 1.25);
        link.pushDescription("Level "..bkpk.generatedQuality.." "..MyCustomHUD.getRarityName(bkpk.appliedAffixes.Size()).." "..bkpk.rwbaseName,
            MyCustomHUD.PickColorForAffixableItem(bkpk), 0.75);

        link.pushSeparator();
        pushAllCollectorLines();
    }
}