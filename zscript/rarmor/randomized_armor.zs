class RandomizedArmor : Armor {

    mixin Affixable;

    RwArmorStats stats;
    string rwbaseName;

    // needed by affixes:
    int lastDamageTick;
    int cumulativeRepair; 

	Default
	{
		Radius 20;
		Height 16;
	}

    virtual void setBaseStats() {
        debug.panicUnimplemented(self);
    }

    // Needs to be called before generation
    private void prepareForGeneration() {}

    // Needs to be called after generation
    private void finalizeAfterGeneration() {
        stats.currDurability = stats.maxDurability;
    }

    // Needed if the armor should be re-generated
    private void RW_Reset() {
        appliedAffixes.Clear();
        stats = New('RwArmorStats');
        setBaseStats();
        nameWithAppliedAffixes = rwBaseName;
    }

    override void BeginPlay() {
        RW_Reset();
    }

    override void Tick() {
        super.Tick();
    }

    bool IsDamaged() {
        return stats.currDurability < stats.maxDurability;
    }

    bool IsFullyBroken() {
        return stats.currDurability <= 0;
    }

    bool IsNotBroken() {
        return stats.currDurability > 0;
    }

    void DoDamageToArmor(int damageAmount) {
        if (damageAmount > 0 && stats.currDurability > 0) {
            lastDamageTick = GetAge();
            stats.currDurability = max(0, stats.currDurability - damageAmount);
        }
    }

    void RepairFor(int repairAmount) {
        let before = stats.currDurability;
        stats.currDurability = min(stats.currDurability + repairAmount, stats.maxDurability);
        cumulativeRepair += stats.currDurability - before;
    }

    virtual string GetRandomFluffName() {
        return "EX-ST "..rnd.Rand(100, 200);
    }

    int ticksSinceDamage() {
        return GetAge() - lastDamageTick;
    }

}
