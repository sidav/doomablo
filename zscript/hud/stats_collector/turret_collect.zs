extend class RwHudArtifactStatsCollector {

    void collectRWTurretStats(RwTurretItem trt, RwTurretItem trtCmp) {
        string compareStr = "";
        let compareClr = Font.CR_White;

        if (trtCmp && trt.stats.turretHealth != trtCmp.stats.turretHealth) {
            compareStr = " ("..intToSignedStr(trt.stats.turretHealth - trtCmp.stats.turretHealth)..")";
            compareClr = GetDifferenceColor(trt.stats.turretHealth - trtCmp.stats.turretHealth);
        } else {
            compareStr = "";
            compareClr = Font.CR_White;
        }
        addTwoLabelsLine("Turret health:", trt.stats.turretHealth.." HP "..compareStr,
                    Font.CR_White, compareClr);


        if (trtCmp && trt.stats.turretLifeSeconds != trtCmp.stats.turretLifeSeconds) {
            compareStr = " ("..floatToSignedStr(Gametime.ticksToSeconds(trt.stats.turretLifeSeconds) - Gametime.ticksToSeconds(trtCmp.stats.turretLifeSeconds))..")";
            compareClr = GetDifferenceColor(trt.stats.turretLifeSeconds - trtCmp.stats.turretLifeSeconds, true);
        } else {
            compareStr = "";
            compareClr = Font.CR_White;
        }
        addTwoLabelsLine("Turret life time:", String.Format("%.1f s", Gametime.ticksToSeconds(trt.stats.turretLifeSeconds))..compareStr,
                                Font.CR_White, compareClr);

        if (trtCmp && trt.stats.maxCharges != trtCmp.stats.maxCharges) {
            compareStr = " ("..intToSignedStr(trt.stats.maxCharges - trtCmp.stats.maxCharges)..")";
            compareClr = GetDifferenceColor(trt.stats.maxCharges - trtCmp.stats.maxCharges);
        } else {
            compareStr = "";
            compareClr = Font.CR_White;
        }
        addTwoLabelsLine("Charges:", trt.currentCharges.."/"..trt.stats.maxCharges..compareStr,
                                Font.CR_White, compareClr);

        if (trtCmp && trt.stats.chargeConsumption != trtCmp.stats.chargeConsumption) {
            compareStr = " ("..intToSignedStr(trt.stats.chargeConsumption - trtCmp.stats.chargeConsumption)..")";
            compareClr = GetDifferenceColor(trt.stats.chargeConsumption - trtCmp.stats.chargeConsumption, true);
        } else {
            compareStr = "";
            compareClr = Font.CR_White;
        }
        addTwoLabelsLine("Charges consumption:", ""..trt.stats.chargeConsumption..compareStr,
                                Font.CR_White, compareClr);

        addSeparatorLine();
        foreach (aff : trt.appliedAffixes) {
            addAffixDescriptionLine(aff);
        }
    }

}