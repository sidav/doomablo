class RandomizedArmor : Armor {

    mixin Affixable;
    mixin ArmorSuffixable;

    int lastDamageTick;

    RwArmorStats stats;
    string rwbaseName;

	Default
	{
		Radius 20;
		Height 16;
	}

    virtual void setBaseStats() {
        debug.panicUnimplemented(self);
    }

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

    override void DoEffect() {
        RWA_SuffOnDoEffect();
    }

    void RepairFor(int repairAmount) {
        stats.currDurability = min(stats.currDurability + repairAmount, stats.maxDurability);
    }

    virtual string GetRandomFluffName() {
        return "EX-ST "..rnd.Rand(100, 200);
    }

    int ticksSinceDamage() {
        return GetAge() - lastDamageTick;
    }

    override void AbsorbDamage(int damage, Name damageType, out int newdamage, Actor inflictor, Actor source, int flags) {
        damage -= stats.DamageReduction;
        if (damage <= 0) {
            damage = 1;
        }
        let damageToArmor = math.getIntPercentage(damage, stats.AbsorbsPercentage);
        if (damageToArmor > stats.currDurability) {
            damageToArmor = stats.currDurability;
        }
        if (stats.currDurability > 0 && damageToArmor > 0) {
            lastDamageTick = GetAge();
        }
        stats.currDurability -= damageToArmor;
        newdamage = damage - damageToArmor;
    }

}
