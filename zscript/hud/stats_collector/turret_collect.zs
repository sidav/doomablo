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

        // Damage
        float trt1dmgmin, trt1dmgmax;
        [trt1dmgmin, trt1dmgmax] = trt.stats.getFloatFinalDamageRange();
        float trt2dmgmin, trt2dmgmax;
        if (trtCmp) {
            [trt2dmgmin, trt2dmgmax] = trtCmp.stats.getFloatFinalDamageRange();
            compareStr = makeDamageDifferenceString(trt1dmgmin, trt1dmgmax, trt2dmgmin, trt2dmgmax);
            compareClr = GetTwoFloatDifferencesColor(trt1dmgmin - trt2dmgmin, trt1dmgmax - trt2dmgmax);
        } else {
            compareStr = "";
            compareClr = Font.CR_White;
        }
        addTwoLabelsLine("Damage:", String.Format("%.1f-%.1f", (trt1dmgmin, trt1dmgmax))..compareStr,
                Font.CR_White, compareClr);

        // LIFE TIME
        if (trtCmp && trt.stats.turretLifeTicks != trtCmp.stats.turretLifeTicks) {
            compareStr = " ("..floatToSignedStr(Gametime.ticksToSeconds(trt.stats.turretLifeTicks) - Gametime.ticksToSeconds(trtCmp.stats.turretLifeTicks))..")";
            compareClr = GetDifferenceColor(trt.stats.turretLifeTicks - trtCmp.stats.turretLifeTicks);
        } else {
            compareStr = "";
            compareClr = Font.CR_White;
        }
        addTwoLabelsLine("Turret life time:", String.Format("%.1f s", Gametime.ticksToSeconds(trt.stats.turretLifeTicks))..compareStr,
                                Font.CR_White, compareClr);

        // CHARGES
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