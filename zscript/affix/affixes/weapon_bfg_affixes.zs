// BFG-specific affixes. BFG is so unique mechanically that its affixes require a separate file lol
class RwBFGPrefix : RwWeaponPrefix abstract {
    override bool IsCompatibleWithRWeapon(RwWeapon wpn) {
        return wpn.GetClass() == 'RwBfg';
    }
}

class RwBFGSuffix : RwWeaponSuffix abstract {
    override bool IsCompatibleWithRWeapon(RwWeapon wpn) {
        return wpn.GetClass() == 'RwBfg';
    }
}

class WAffLessBFGRays : RwBFGPrefix {
    override string getName() {
        return "Undercharged";
    }
    override string getDescription() {
        return "-"..modifierLevel.." rays";
    }
    override int getAlignment() {
        return -1;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'WAffMoreBFGRays' && a2.GetClass() != 'WSuffBFGNoRays';
    }
    override void initAndApplyEffectToRWeapon(RwWeapon wpn, int quality) {
        let maxChange = wpn.stats.NumberOfRays/2;
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, maxChange/2, 0.1) + remapQualityToRange(quality, 0, maxChange/2);
        wpn.stats.NumberOfRays -= modifierLevel;
    }
}

class WAffMoreBFGRays : RwBFGPrefix {
    override string getName() {
        return "Overcharged";
    }
    override string getDescription() {
        return "+"..modifierLevel.." rays";
    }
    override int getAlignment() {
        return 1;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'WAffLessBFGRays' && a2.GetClass() != 'WSuffBFGNoRays';
    }
    override void initAndApplyEffectToRWeapon(RwWeapon wpn, int quality) {
        let maxChange = 30;
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, maxChange/2, 0.1) + remapQualityToRange(quality, 0, maxChange/2);
        wpn.stats.NumberOfRays += modifierLevel;
    }
}

class WAffNarrowerBFGAngle : RwBFGPrefix {
    override string getName() {
        return "Concentrated";
    }
    override string getDescription() {
        return String.format("-%.1f rays angle", (double(modifierLevel)/10.) );
    }
    override int getAlignment() {
        return -1;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'WAffWiderBFGAngle' && a2.GetClass() != 'WSuffBFGNoRays' && a2.GetClass() != 'WSuffRaysFromTarget';
    }
    override void initAndApplyEffectToRWeapon(RwWeapon wpn, int quality) {
        let maxChange = (wpn.stats.RaysConeAngle / 2)*10;
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(5, maxChange/2, 0.1) + remapQualityToRange(quality, 0, maxChange/2);
        wpn.stats.RaysConeAngle -= double(modifierLevel)/10;
    }
}

class WAffWiderBFGAngle : RwBFGPrefix {
    override string getName() {
        return "Dissipated";
    }
    override string getDescription() {
        return String.format("+%.1f rays angle", (double(modifierLevel)/10.) );
    }
    override int getAlignment() {
        return 1;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'WAffNarrowerBFGAngle' && a2.GetClass() != 'WSuffBFGNoRays' && a2.GetClass() != 'WSuffRaysFromTarget';
    }
    override void initAndApplyEffectToRWeapon(RwWeapon wpn, int quality) {
        let maxChange = wpn.stats.RaysConeAngle*10;
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(5, maxChange/2, 0.1) + remapQualityToRange(quality, 0, maxChange/2);
        wpn.stats.RaysConeAngle += double(modifierLevel)/10;
    }
}

class WAffWorseBFGRayDamage : RwBFGPrefix {
    override string getName() {
        return "Dim";
    }
    override string getNameAsSuffix() {
        return "Dimness";
    }
    override int getAlignment() {
        return -1;
    }
    override string getDescription() {
        return String.format("Ray DMG -%d.%d%%", (modifierLevel / 10, modifierLevel % 10) );
    }
    override bool IsCompatibleWithRWeapon(RwWeapon wpn) {
        return wpn.GetClass() == 'RwBfg' || wpn.GetClass() == 'RwuBFG10k';
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'WAffBetterBFGRayDamage' && a2.GetClass() != 'WSuffBFGNoRays';
    }
    override void initAndApplyEffectToRWeapon(RwWeapon wpn, int quality) {
        let maxChange = 200;
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(10, maxChange/2, 0.1) + remapQualityToRange(quality, 0, maxChange/2);
        wpn.stats.additionalBfgRayDamagePromille = -modifierLevel;
    }
}

class WAffBetterBFGRayDamage : RwBFGPrefix {
    override string getName() {
        return "Bright";
    }
    override string getNameAsSuffix() {
        return "Brightness";
    }
    override int getAlignment() {
        return 1;
    }
    override string getDescription() {
        return String.format("Ray DMG +%d.%d%%", (modifierLevel / 10, modifierLevel % 10) );
    }
    override bool IsCompatibleWithRWeapon(RwWeapon wpn) {
        return wpn.GetClass() == 'RwBfg' || wpn.GetClass() == 'RwuBFG10k';
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'WAffWorseBFGRayDamage' && a2.GetClass() != 'WSuffBFGNoRays';
    }
    override void initAndApplyEffectToRWeapon(RwWeapon wpn, int quality) {
        let maxChange = 200;
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(10, maxChange/2, 0.1) + remapQualityToRange(quality, 0, maxChange/2);
        wpn.stats.additionalBfgRayDamagePromille = modifierLevel;
    }
}

// Suffixes

class WSuffRaysFromTarget : RwBFGSuffix {
    override string getName() {
        return "Radiation Burst";
    }
    override string getDescription() {
        return String.format("x%d.%d rays. Rays are fired from the target", (modifierLevel/10, modifierLevel%10) );
    }
    
    override void initAndApplyEffectToRWeapon(RwWeapon wpn, int quality) {
        let maxChange = 40;
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(15, maxChange/2, 0.1) + remapQualityToRange(quality, 0, maxChange/2);
        wpn.stats.RaysConeAngle = 360.;
        wpn.stats.NumberOfRays = (wpn.stats.NumberOfRays * modifierLevel) / 10;
        wpn.stats.raysWillOriginateFromMissile = true;
    }
}

class WSuffBFGNoRays : RwBFGSuffix {
    override string getName() {
        return "HI-EX Edition";
    }
    override string getDescription() {
        return String.format("x%d.%d damage. Projectile explodes on hit. No rays are fired", (modifierLevel/10, modifierLevel%10) );
    }
    override void initAndApplyEffectToRWeapon(RwWeapon wpn, int quality) {
        let maxChange = 100;
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(15, maxChange/2, 0.1) + remapQualityToRange(quality, 0, maxChange/2);
        wpn.stats.minDamage = wpn.stats.minDamage * modifierLevel / 10;
        wpn.stats.maxDamage = wpn.stats.maxDamage * modifierLevel / 10;
        wpn.stats.NumberOfRays = 0;
        wpn.stats.BaseExplosionRadius = 192;
		wpn.stats.ExplosionRadius = 192;
    }
}
