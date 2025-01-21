extend class RwHudArtifactStatsCollector {

    void collectRWWeaponStats(RandomizedWeapon wpn, RandomizedWeapon wpnComp) {
        string compareStr = "";
        let compareClr = Font.CR_White;
        // Damage
        float wpn1dmgmin, wpn1dmgmax;
        [wpn1dmgmin, wpn1dmgmax] = wpn.stats.getFloatFinalDamageRange();
        float wpn2dmgmin, wpn2dmgmax;
        if (wpnComp) {
            [wpn2dmgmin, wpn2dmgmax] = wpnComp.stats.getFloatFinalDamageRange();
        }
        // SHOTGUN
        if (wpn.stats.pellets > 1) {
            // Damage
            if (wpnComp) {
                compareStr = makeDamageDifferenceString(wpn1dmgmin, wpn1dmgmax, wpn2dmgmin, wpn2dmgmax);
                compareClr = GetTwoFloatDifferencesColor(wpn1dmgmin - wpn2dmgmin, wpn1dmgmax - wpn2dmgmax);
            } else {
                compareStr = "";
            }
            addTwoLabelsLine("Damage per pellet:", String.Format("%.1f-%.1f", (wpn1dmgmin, wpn1dmgmax))..compareStr, 
                    Font.CR_White, compareClr);
            // Pellets
            if (wpnComp && wpn.stats.pellets != wpnComp.stats.pellets) {
                compareStr = " ("..intToSignedStr(wpn.stats.pellets - wpnComp.stats.pellets)..")";
                compareClr = GetDifferenceColor(wpn.stats.pellets - wpnComp.stats.pellets);
            } else {
                compareStr = "";
                compareClr = Font.CR_White;
            }
            addTwoLabelsLine("Pellets per shot:", ""..wpn.stats.pellets..compareStr, 
                    Font.CR_White, compareClr);
            // Total shot damage
            if (wpnComp) {
                compareStr = makeDamageDifferenceString(
                    wpn1dmgmin, wpn1dmgmax*wpn.stats.pellets,
                    wpn2dmgmin, wpn2dmgmax*wpnComp.stats.pellets
                );
                compareClr = GetTwoFloatDifferencesColor(wpn1dmgmin - wpn2dmgmin, wpn1dmgmax*wpn.stats.pellets - wpn2dmgmax*wpnComp.stats.pellets);
            } else {
                compareStr = "";
            }
            addTwoLabelsLine("Total shot damage:", String.Format("%.1f-%.1f", (wpn1dmgmin, wpn1dmgmax*wpn.stats.pellets))..compareStr,
                    Font.CR_White, compareClr);    
        // NON-SHOTGUN
        } else {
            if (wpnComp) {
                compareStr = makeDamageDifferenceString(wpn1dmgmin, wpn1dmgmax, wpn2dmgmin, wpn2dmgmax);
                compareClr = GetTwoFloatDifferencesColor(wpn1dmgmin - wpn2dmgmin, wpn1dmgmax - wpn2dmgmax);
            } else {
                compareStr = "";
                compareClr = Font.CR_White;
            }
            addTwoLabelsLine("Damage:", String.Format("%.1f-%.1f", (wpn1dmgmin, wpn1dmgmax))..compareStr,
                    Font.CR_White, compareClr);
        }

        // CLIP SIZE
        if (wpn.stats.clipSize > 1) {
            if (wpnComp && wpn.stats.clipSize != wpnComp.stats.clipSize && wpnComp.stats.clipSize > 0) {
                compareStr = " ("..intToSignedStr(wpn.stats.clipSize - wpnComp.stats.clipSize)..")";
                compareClr = GetDifferenceColor(wpn.stats.clipSize - wpnComp.stats.clipSize);
            } else {
                compareStr = "";
                compareClr = Font.CR_White;
            }
            addTwoLabelsLine("Magazine capacity:", ""..wpn.stats.clipSize..compareStr, 
                    Font.CR_White, compareClr);
        }

        // SPREAD
        if (wpnComp && wpn.stats.horizSpread != wpnComp.stats.horizSpread) {
            compareStr = " ("..floatToSignedStr(wpn.stats.horizSpread - wpnComp.stats.horizSpread)..")";
            compareClr = GetDifferenceColor((wpn.stats.horizSpread - wpnComp.stats.horizSpread) * 100, true);
        } else {
            compareStr = "";
            compareClr = Font.CR_White;
        }
        addTwoLabelsLine("Spread:", String.Format("%.1f", (wpn.stats.horizSpread))..compareStr, 
                    Font.CR_White, compareClr);

        // Attack range
        if (wpn.stats.isMelee) {
            if (wpnComp && wpn.stats.attackRange != wpnComp.stats.attackRange) {
                compareStr = " ("..intToSignedStr(wpn.stats.attackRange - wpnComp.stats.attackRange)..")";
                compareClr = GetDifferenceColor((wpn.stats.attackRange - wpnComp.stats.attackRange) * 100);
            } else {
                compareStr = "";
                compareClr = Font.CR_White;
            }
            addTwoLabelsLine("Reach:", String.Format("%d", (wpn.stats.attackRange))..compareStr, 
                        Font.CR_White, compareClr);
        }

        // BFG stats
        if (wpn.GetClass() == 'RwBFG') {
            // Rays num
            if (wpnComp && wpn.stats.NumberOfRays != wpnComp.stats.NumberOfRays && wpnComp.stats.NumberOfRays > 0) {
                compareStr = " ("..intToSignedStr(wpn.stats.NumberOfRays - wpnComp.stats.NumberOfRays)..")";
                compareClr = GetDifferenceColor((wpn.stats.NumberOfRays - wpnComp.stats.NumberOfRays));
            } else {
                compareStr = "";
                compareClr = Font.CR_White;
            }
            addTwoLabelsLine("Number of rays:", String.Format("%d", (wpn.stats.NumberOfRays))..compareStr, 
                        Font.CR_White, compareClr);

            // Rays angle
            if (wpnComp && wpn.stats.RaysConeAngle != wpnComp.stats.RaysConeAngle && wpnComp.stats.NumberOfRays > 0) {
                compareStr = " ("..floatToSignedStr(wpn.stats.RaysConeAngle - wpnComp.stats.RaysConeAngle)..")";
                compareClr = GetDifferenceColor((wpn.stats.RaysConeAngle - wpnComp.stats.RaysConeAngle));
            } else {
                compareStr = "";
                compareClr = Font.CR_White;
            }
            addTwoLabelsLine("Rays angle:", String.Format("%.1f", (wpn.stats.RaysConeAngle))..compareStr, 
                        Font.CR_White, compareClr);

            // Rays dmg
            wpn1dmgmin = float(wpn.stats.RayDmgMin * (1000 + wpn.stats.additionalBfgRayDamagePromille)) / 1000.;
            wpn1dmgmax = float(wpn.stats.RayDmgMax * (1000 + wpn.stats.additionalBfgRayDamagePromille)) / 1000.;
            if (wpnComp) {
                wpn2dmgmin = double(wpnComp.stats.RayDmgMin * (1000 + wpnComp.stats.additionalBfgRayDamagePromille)) / 1000.;
                wpn2dmgmax = double(wpnComp.stats.RayDmgMax * (1000 + wpnComp.stats.additionalBfgRayDamagePromille)) / 1000.;
            }
            if (wpnComp && wpnComp.stats.NumberOfRays > 0) {
                if (wpnComp) {
                    compareStr = makeDamageDifferenceString(wpn1dmgmin, wpn1dmgmax, wpn2dmgmin, wpn2dmgmax);
                    compareClr = GetTwoFloatDifferencesColor(wpn1dmgmin - wpn2dmgmin, wpn1dmgmax - wpn2dmgmax);
                } else {
                    compareStr = "";
                }
            } else {
                compareStr = "";
                compareClr = Font.CR_White;
            }
            addTwoLabelsLine("Ray Damage:", String.Format("%.1f-%.1f", (wpn1dmgmin, wpn1dmgmax))..compareStr,
                    Font.CR_White, compareClr);
        }

        addSeparatorLine();

        foreach (aff : wpn.appliedAffixes) {
            addAffixDescriptionLine(aff);
        }
    }

}