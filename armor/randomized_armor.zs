class RandomizedArmor : Armor {

    mixin Affixable;
    mixin ArmorSuffixable;

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

    override void BeginPlay() {
		stats = New('RwArmorStats');
        setBaseStats();
        Generate();
    }

    override void Tick() {
        super.Tick();
    }

    override void DoEffect() {
        if (owner.FindInventory('BasicArmor') != null) {
            debug.print("Basic armor exists! Tick: "..GetAge());
        }

        RWA_SuffOnDoEffect();
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
        stats.currDurability -= damageToArmor;
        newdamage = damage - damageToArmor;
    }

}
