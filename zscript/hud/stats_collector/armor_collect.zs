extend class RwHudArtifactStatsCollector {

    void collectRWArmorStats(RwArmor armr, RwArmor armrCmp) {
        string compareStr = "";
        let compareClr = Font.CR_White;
        if (armrCmp && armr.stats.maxDurability != armrCmp.stats.maxDurability) {
            compareStr = " ("..intToSignedStr(armr.stats.maxDurability - armrCmp.stats.maxDurability)..")";
            compareClr = GetDifferenceColor(armr.stats.maxDurability - armrCmp.stats.maxDurability);
        }
        addTwoLabelsLine("Durability:", armr.stats.currDurability.."/"..armr.stats.maxDurability..compareStr, 
                    Font.CR_White, compareClr);

        if (armrCmp && armr.stats.AbsorbsPercentage != armrCmp.stats.AbsorbsPercentage) {
            compareStr = " ("..intToSignedStr(armr.stats.AbsorbsPercentage - armrCmp.stats.AbsorbsPercentage).."%)";
            compareClr = GetDifferenceColor(armr.stats.AbsorbsPercentage - armrCmp.stats.AbsorbsPercentage);
        } else {
            compareStr = "";
            compareClr = Font.CR_White;
        }
        addTwoLabelsLine("Damage absorption", armr.stats.AbsorbsPercentage.."%"..compareStr,
                    Font.CR_White, compareClr);

        ////////////////////////////////////////////////////////////////////////////////
        // Stop comparing energy and non-energy armor at this point
        if (armrCmp && (armr.stats.IsEnergyArmor() != armrCmp.stats.IsEnergyArmor())) {
            armrCmp = null;
        }

        if (armr.stats.IsEnergyArmor()) {

            if (armrCmp && armr.stats.delayUntilRecharge != armrCmp.stats.delayUntilRecharge) {
                compareStr = " ("..floatToSignedStr(Gametime.ticksToSeconds(armr.stats.delayUntilRecharge) - Gametime.ticksToSeconds(armrCmp.stats.delayUntilRecharge))..")";
                compareClr = GetDifferenceColor(armr.stats.delayUntilRecharge - armrCmp.stats.delayUntilRecharge, true);
            } else {
                compareStr = "";
                compareClr = Font.CR_White;
            }
            addTwoLabelsLine("Delay until recharge", String.Format("%.1f s", Gametime.ticksToSeconds(armr.stats.delayUntilRecharge))..compareStr,
                        Font.CR_White, compareClr);


            if (armrCmp && armr.stats.RestorePerSecond() != armrCmp.stats.RestorePerSecond()) {
                compareStr = " ("..floatToSignedStr(armr.stats.RestorePerSecond() - armrCmp.stats.RestorePerSecond())..")";
                compareClr = GetDifferenceColor(100*(armr.stats.RestorePerSecond() - armrCmp.stats.RestorePerSecond()));
            } else {
                compareStr = "";
                compareClr = Font.CR_White;
            }
            addTwoLabelsLine("Recharge speed", String.Format("%.1f/s", armr.stats.RestorePerSecond())..compareStr,
                        Font.CR_White, compareClr);

        } else {

            if (armrCmp && armr.stats.RepairFromBonusx1000 != armrCmp.stats.RepairFromBonusx1000) {
                compareStr = " ("..StringsHelper.FixedPointIntAsSignedString(armr.stats.RepairFromBonusx1000 - armrCmp.stats.RepairFromBonusx1000, 1000)..")";
                compareClr = GetDifferenceColor(armr.stats.RepairFromBonusx1000 - armrCmp.stats.RepairFromBonusx1000);
            } else {
                compareStr = "";
                compareClr = Font.CR_White;
            }
            addTwoLabelsLine("Repair amount", StringsHelper.FixedPointIntAsString(armr.stats.RepairFromBonusx1000, 1000)..compareStr,
                        Font.CR_White, compareClr);

        }

        addSeparatorLine();

        foreach (aff : armr.appliedAffixes) {
            addAffixDescriptionLine(aff);
        }
    }

}