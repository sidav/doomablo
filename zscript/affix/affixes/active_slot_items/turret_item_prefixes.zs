class RwTurretItemPrefix : RwBaseActiveSlotItemAffix abstract {
    override void InitAndApplyEffectToItem(Inventory item, int quality) {
        initAndapplyEffectToRTurretItm(RwTurretItem(item), quality);
    }
    protected virtual void initAndapplyEffectToRTurretItm(RwTurretItem turr, int quality) {
        debug.panicUnimplemented(self);
    }
    override bool IsCompatibleWithItem(Inventory item) {
        return (RwTurretItem(item) != null);
    }
}

class TurrPrefLessHealth : RwTurretItemPrefix {
    override string getName() {
        return "Fragile";
    }
    override int getAlignment() {
        return -1;
    }
    override string getDescription() {
        return String.format("-%d%% sentry health", (modifierLevel) );
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'TurrPrefMoreHealth';
    }
    override void initAndapplyEffectToRTurretItm(RwTurretItem turr, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(5, 10, 0.1) + remapQualityToRange(quality, 0, 10);
        stat2 = turr.stats.turretHealth;
        turr.stats.turretHealth = math.getIntPercentage(turr.stats.turretHealth, 100 - modifierLevel);
    }
    override bool TryUnapplyingSelfFrom(Inventory item) {
        RwTurretItem(item).stats.turretHealth = stat2;
        return true;
    }
}

class TurrPrefMoreHealth : RwTurretItemPrefix {
    override string getName() {
        return "Sturdy";
    }
    override int getAlignment() {
        return 1;
    }
    override string getDescription() {
        return String.format("+%d%% sentry health", (modifierLevel) );
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'TurrPrefLessHealth';
    }
    override void initAndapplyEffectToRTurretItm(RwTurretItem turr, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(15, 200, 0.1) + remapQualityToRange(quality, 0, 50);
        turr.stats.turretHealth = math.getIntPercentage(turr.stats.turretHealth, 100 + modifierLevel);
    }
}

class TurrPrefLessDmg : RwTurretItemPrefix {
    override string getName() {
        return "Weak";
    }
    override int getAlignment() {
        return -1;
    }
    override string getDescription() {
        return String.format("-%.1f%% sentry damage", (double(modifierLevel) / 10) );
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'TurrPrefMoreDmg';
    }
    override void initAndapplyEffectToRTurretItm(RwTurretItem turr, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(10, 60, 0.1) + remapQualityToRange(quality, 0, 40);
        turr.stats.additionalDamagePromille -= modifierLevel;
    }
    override bool TryUnapplyingSelfFrom(Inventory item) {
        RwTurretItem(item).stats.additionalDamagePromille += modifierLevel;
        return true;
    }
}

class TurrPrefMoreDmg : RwTurretItemPrefix {
    override string getName() {
        return "Strong";
    }
    override int getAlignment() {
        return 1;
    }
    override string getDescription() {
        return String.format("+%.1f%% sentry damage", (double(modifierLevel) / 10) );
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'TurrPrefLessDmg';
    }
    override void initAndapplyEffectToRTurretItm(RwTurretItem turr, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(100, 800, 0.05) + remapQualityToRange(quality, 0, 200);
        turr.stats.additionalDamagePromille += modifierLevel;
    }
}

class TurrPrefLessAccuracy: RwTurretItemPrefix {
    override string getName() {
        return "Unprecise";
    }
    override int getAlignment() {
        return -1;
    }
    override string getDescription() {
        return String.format("+%d%% sentry fire spread", (modifierLevel) );
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'TurrPrefMoreAccuracy';
    }
    float initialSpread;
    override void initAndapplyEffectToRTurretItm(RwTurretItem turr, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(5, 10, 0.1) + remapQualityToRange(quality, 0, 10);
        initialSpread = turr.stats.turretHSpread;
        turr.stats.turretHSpread *= (1. + float(modifierLevel)/100.);
    }
    override bool TryUnapplyingSelfFrom(Inventory item) {
        RwTurretItem(item).stats.turretHSpread = initialSpread;
        return true;
    }
}

class TurrPrefMoreAccuracy: RwTurretItemPrefix {
    override string getName() {
        return "Precise";
    }
    override int getAlignment() {
        return 1;
    }
    override string getDescription() {
        return String.format("-%d%% sentry fire spread", (modifierLevel) );
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'TurrPrefLessAccuracy';
    }
    override void initAndapplyEffectToRTurretItm(RwTurretItem turr, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(5, 45, 0.1) + remapQualityToRange(quality, 0, 15);
        turr.stats.turretHSpread *= (1. - float(modifierLevel)/100.);
    }
}

class TurrPrefLessLifetime: RwTurretItemPrefix {
    override string getName() {
        return "Disposable";
    }
    override int getAlignment() {
        return -1;
    }
    override string getDescription() {
        return String.format("-%d%% sentry lifetime", (modifierLevel) );
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'TurrPrefMoreLifetime';
    }
    override void initAndapplyEffectToRTurretItm(RwTurretItem turr, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(5, 10, 0.1) + remapQualityToRange(quality, 0, 10);
        stat2 = turr.stats.turretLifeTicks;
        turr.stats.turretLifeTicks = math.getIntPercentage(turr.stats.turretLifeTicks, 100 - modifierLevel);
    }
    override bool TryUnapplyingSelfFrom(Inventory item) {
        RwTurretItem(item).stats.turretLifeTicks = stat2;
        return true;
    }
}

class TurrPrefMoreLifetime : RwTurretItemPrefix {
    override string getName() {
        return "Lasting";
    }
    override int getAlignment() {
        return 1;
    }
    override string getDescription() {
        return String.format("+%d%% sentry lifetime", (modifierLevel) );
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'TurrPrefLessLifetime';
    }
    override void initAndapplyEffectToRTurretItm(RwTurretItem turr, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(15, 100, 0.1) + remapQualityToRange(quality, 0, 50);
        stat2 = turr.stats.turretLifeTicks;
        turr.stats.turretLifeTicks = math.getIntPercentage(turr.stats.turretLifeTicks, 100 + modifierLevel);
    }
}