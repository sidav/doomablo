// BFG-specific affixes. BFG is so unique mechanically that its affixes require a separate file lol

class WAffLessBFGRays : RwWeaponPrefix {
    override string getName() {
        return "Undercharged";
    }
    override string getDescription() {
        return "-"..modifierLevel.." rays";
    }
    override int getAlignment() {
        return -1;
    }
    override bool IsCompatibleWithRWeapon(RwWeapon wpn) {
        return wpn.GetClass() == 'RwBfg';
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

class WAffMoreBFGRays : RwWeaponPrefix {
    override string getName() {
        return "Overcharged";
    }
    override string getDescription() {
        return "+"..modifierLevel.." rays";
    }
    override int getAlignment() {
        return 1;
    }
    override bool IsCompatibleWithRWeapon(RwWeapon wpn) {
        return wpn.GetClass() == 'RwBfg';
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

class WAffNarrowerBFGAngle : RwWeaponPrefix {
    override string getName() {
        return "Concentrated";
    }
    override string getDescription() {
        return String.format("-%.1f rays angle", (double(modifierLevel)/10.) );
    }
    override int getAlignment() {
        return -1;
    }
    override bool IsCompatibleWithRWeapon(RwWeapon wpn) {
        return wpn.GetClass() == 'RwBfg';
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'WAffWiderBFGAngle' && a2.GetClass() != 'WSuffBFGNoRays' && a2.GetClass() != 'WSuffBFG10K';
    }
    override void initAndApplyEffectToRWeapon(RwWeapon wpn, int quality) {
        let maxChange = (wpn.stats.RaysConeAngle / 2)*10;
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(5, maxChange/2, 0.1) + remapQualityToRange(quality, 0, maxChange/2);
        wpn.stats.RaysConeAngle -= double(modifierLevel)/10;
    }
}

class WAffWiderBFGAngle : RwWeaponPrefix {
    override string getName() {
        return "Dissipated";
    }
    override string getDescription() {
        return String.format("+%.1f rays angle", (double(modifierLevel)/10.) );
    }
    override int getAlignment() {
        return 1;
    }
    override bool IsCompatibleWithRWeapon(RwWeapon wpn) {
        return wpn.GetClass() == 'RwBfg';
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'WAffNarrowerBFGAngle' && a2.GetClass() != 'WSuffBFGNoRays' && a2.GetClass() != 'WSuffBFG10K';
    }
    override void initAndApplyEffectToRWeapon(RwWeapon wpn, int quality) {
        let maxChange = wpn.stats.RaysConeAngle*10;
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(5, maxChange/2, 0.1) + remapQualityToRange(quality, 0, maxChange/2);
        wpn.stats.RaysConeAngle += double(modifierLevel)/10;
    }
}

class WAffWorseBFGRayDamage : RwWeaponPrefix {
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
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'WAffBetterBFGRayDamage' && a2.GetClass() != 'WSuffBFGNoRays';
    }
    override bool IsCompatibleWithRWeapon(RwWeapon wpn) {
        return wpn.GetClass() == 'RwBfg';
    }
    override void initAndApplyEffectToRWeapon(RwWeapon wpn, int quality) {
        let maxChange = 200;
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(10, maxChange/2, 0.1) + remapQualityToRange(quality, 0, maxChange/2);
        wpn.stats.additionalBfgRayDamagePromille = -modifierLevel;
    }
}

class WAffBetterBFGRayDamage : RwWeaponPrefix {
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
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'WAffWorseBFGRayDamage' && a2.GetClass() != 'WSuffBFGNoRays';
    }
    override bool IsCompatibleWithRWeapon(RwWeapon wpn) {
        return wpn.GetClass() == 'RwBfg';
    }
    override void initAndApplyEffectToRWeapon(RwWeapon wpn, int quality) {
        let maxChange = 200;
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(10, maxChange/2, 0.1) + remapQualityToRange(quality, 0, maxChange/2);
        wpn.stats.additionalBfgRayDamagePromille = modifierLevel;
    }
}

// Suffixes

class WSuffBFG10K : RwWeaponSuffix {
    override string getName() {
        return "10k Type";
    }
    override string getDescription() {
        return String.format("x%d.%d rays. Rays are fired from the target", (modifierLevel/10, modifierLevel%10) );
    }
    override bool IsCompatibleWithRWeapon(RwWeapon wpn) {
        return wpn.GetClass() == 'RwBfg';
    }
    override void initAndApplyEffectToRWeapon(RwWeapon wpn, int quality) {
        let maxChange = 40;
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(15, maxChange/2, 0.1) + remapQualityToRange(quality, 0, maxChange/2);
        wpn.stats.RaysConeAngle = 360.;
        wpn.stats.NumberOfRays = (wpn.stats.NumberOfRays * modifierLevel) / 10;
        wpn.stats.raysWillOriginateFromMissile = true;
    }
}

class WSuffBFGNoRays : RwWeaponSuffix {
    override string getName() {
        return "HI-EX Edition";
    }
    override string getDescription() {
        return String.format("x%d.%d damage. Projectile explodes on hit. No rays are fired", (modifierLevel/10, modifierLevel%10) );
    }
    override bool IsCompatibleWithRWeapon(RwWeapon wpn) {
        return wpn.GetClass() == 'RwBfg';
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
