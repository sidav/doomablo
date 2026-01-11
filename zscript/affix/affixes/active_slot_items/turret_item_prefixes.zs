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
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(10, 200, 0.1) + remapQualityToRange(quality, 0, 50);
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
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(50, 200, 0.05) + remapQualityToRange(quality, 0, 100);
        turr.stats.additionalDamagePromille += modifierLevel;
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
        stat2 = turr.stats.turretLifeSeconds;
        turr.stats.turretLifeSeconds = math.getIntPercentage(turr.stats.turretLifeSeconds, 100 - modifierLevel);
    }
    override bool TryUnapplyingSelfFrom(Inventory item) {
        RwTurretItem(item).stats.turretLifeSeconds = stat2;
        return true;
    }
}

class TurrPrefMoreLifetime : RwTurretItemPrefix {
    override string getName() {
        return "Strong";
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
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(5, 10, 0.1) + remapQualityToRange(quality, 0, 10);
        stat2 = turr.stats.turretLifeSeconds;
        turr.stats.turretLifeSeconds = math.getIntPercentage(turr.stats.turretLifeSeconds, 100 + modifierLevel);
    }
}