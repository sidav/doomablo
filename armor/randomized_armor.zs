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

    // Needed if the armor should be re-generated
    private void RW_Reset() {
        appliedAffixes.Resize(0);
        stats = New('RwArmorStats');
        setBaseStats();
    }

    override void BeginPlay() {
        RW_Reset();
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

    virtual string GetRandomFluffName() {
        static const string specialNames[] =
        {
            "Protector",
            "Defender",
            "Life saver"
        };
        if (rnd.OneChanceFrom(5)) {
            return "EX-ST "..rnd.Rand(100, 200);
        }
        return specialNames[rnd.Rand(0, specialNames.Size()-1)];
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
