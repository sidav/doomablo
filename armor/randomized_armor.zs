class RandomizedArmor : Armor {

    RwArmorStats stats;
    string rwFullName; // Needed for HUD
    string rwbaseName;

	Default
	{
		Radius 20;
		Height 16;
	}

    array <Affix> appliedAffixes;

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

        // if (stats.ArmorRegenEachTicks > 0 && GetAge() % stats.ArmorRegenEachTicks == 0) {
        //     stats.CurrentAmount++;
        // }
        // if (stats.HealthRegenEachTicks > 0 && GetAge() % stats.HealthRegenEachTicks == 0) {
        //     owner.GiveBody(1, 100);
        // }
    }

    override void AbsorbDamage(int damage, Name damageType, out int newdamage, Actor inflictor, Actor source, int flags) {
        damage -= stats.DamageReduction;
        if (damage <= 0) {
            damage = 1;
        }
        let damageToArmor = math.getIntPercentage(damage, stats.AbsorbsPercentage);
        if (damageToArmor > stats.CurrentAmount) {
            damageToArmor = stats.CurrentAmount;
        }
        stats.CurrentAmount -= damageToArmor;
        newdamage = damage - damageToArmor;
    }

}
