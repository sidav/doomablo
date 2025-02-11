extend class RwHudArtifactStatsCollector {

    void collectRWFlaskStats(RWFlask fsk, RWFlask fskCmp) {
        string compareStr = "";
        let compareClr = Font.CR_White;

        if (fskCmp && fsk.stats.healAmount != fskCmp.stats.healAmount) {
            compareStr = " ("..intToSignedStr(fsk.stats.healAmount - fskCmp.stats.healAmount)..")";
            compareClr = GetDifferenceColor(fsk.stats.healAmount - fskCmp.stats.healAmount);
        } else {
            compareStr = "";
            compareClr = Font.CR_White;
        }
        addTwoLabelsLine("Total healing:", fsk.stats.healAmount.." HP "..compareStr,
                    Font.CR_White, compareClr);


        if (fskCmp && fsk.stats.healDurationTicks != fskCmp.stats.healDurationTicks) {
            compareStr = " ("..floatToSignedStr(Gametime.ticksToSeconds(fsk.stats.healDurationTicks) - Gametime.ticksToSeconds(fskCmp.stats.healDurationTicks))..")";
            compareClr = GetDifferenceColor(fsk.stats.healDurationTicks - fskCmp.stats.healDurationTicks, true);
        } else {
            compareStr = "";
            compareClr = Font.CR_White;
        }
        addTwoLabelsLine("Healing duration:", String.Format("%.1f s", Gametime.ticksToSeconds(fsk.stats.healDurationTicks))..compareStr,
                                Font.CR_White, compareClr);


        if (fskCmp && fsk.stats.usageCooldownTicks != fskCmp.stats.usageCooldownTicks) {
            compareStr = " ("..floatToSignedStr(Gametime.ticksToSeconds(fsk.stats.usageCooldownTicks) - Gametime.ticksToSeconds(fskCmp.stats.usageCooldownTicks))..")";
            compareClr = GetDifferenceColor(fsk.stats.usageCooldownTicks - fskCmp.stats.usageCooldownTicks, true);
        } else {
            compareStr = "";
            compareClr = Font.CR_White;
        }
        addTwoLabelsLine("Usage cooldown:", String.Format("%.1f s", Gametime.ticksToSeconds(fsk.stats.usageCooldownTicks))..compareStr,
                                Font.CR_White, compareClr);

        if (fskCmp && fsk.stats.maxCharges != fskCmp.stats.maxCharges) {
            compareStr = " ("..intToSignedStr(fsk.stats.maxCharges - fskCmp.stats.maxCharges)..")";
            compareClr = GetDifferenceColor(fsk.stats.maxCharges - fskCmp.stats.maxCharges);
        } else {
            compareStr = "";
            compareClr = Font.CR_White;
        }
        addTwoLabelsLine("Charges:", fsk.currentCharges.."/"..fsk.stats.maxCharges..compareStr,
                                Font.CR_White, compareClr);

        if (fskCmp && fsk.stats.chargeConsumption != fskCmp.stats.chargeConsumption) {
            compareStr = " ("..intToSignedStr(fsk.stats.chargeConsumption - fskCmp.stats.chargeConsumption)..")";
            compareClr = GetDifferenceColor(fsk.stats.chargeConsumption - fskCmp.stats.chargeConsumption, true);
        } else {
            compareStr = "";
            compareClr = Font.CR_White;
        }
        addTwoLabelsLine("Charges consumption:", ""..fsk.stats.chargeConsumption..compareStr,
                                Font.CR_White, compareClr);

        addSeparatorLine();
        foreach (aff : fsk.appliedAffixes) {
            addAffixDescriptionLine(aff);
        }
    }

}