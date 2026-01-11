class RwBackpack : Inventory {

    mixin Affixable;
    string rwbaseName;
    RwBackpackStats stats;

    int rweight; // Just like in the others, this is the weight for random drops
    Property Weight: rweight;

    Default {
		Height 26;
        RwBackpack.Weight 10;
		Inventory.PickupMessage "$GOTBACKPACK";
    }
	States {
        Spawn:
            BPAK A -1;
            Stop;
	}

    // The only difference in variants is only the sprite currently. That's why the names are obscure.
    static class <RwBackpack> GetRandomVariantClass() {
        let v = rnd.randn(3);
        switch (v) {
            case 0: return 'RwBackpack';
            case 1: return 'RwBackpackVariant2';
            case 2: return 'RwBackpackVariant3';
        }
        return 'RwBackpack';
    }

    virtual void setBaseStats() {
		rwbaseName = "Backpack";
		stats = New('RwBackpackStats');
		stats.maxBull = 250;
		stats.maxShel = 60;
		stats.maxRckt = 50;
		stats.maxCell = 300;
    }

    // Needs to be called before generation
    private void prepareForGeneration() {
        stats.maxBull += generatedQuality * 4;
        stats.maxShel += generatedQuality;
        stats.maxRckt += 2 * generatedQuality / 3;
        stats.maxCell += generatedQuality * 3;
    }

    // Needs to be called after generation
    private void finalizeAfterGeneration() {}

    // Needed if the item should be re-generated
    private void RW_Reset() {
        appliedAffixes.Clear();
        stats = New('RwBackpackStats');
        setBaseStats();
        nameWithAppliedAffixes = rwBaseName;
    }

    override void BeginPlay() {
        RW_Reset();
    }

    virtual string GetRandomFluffName() {
        static const string Brand[] =
        {
            "AER",
            "Cheap",
            "Expensive",
            "Generic",
            "Goruck",
            "Maxpedition",
            "Military",
            "Rissa",
            "UAC-issued"
        };
        static const string Packtype[] =
        {
            "Backpack",
			"Bag",
            "Citybag",
            "Daypack",
			"Pack"
        };
        return Brand[rnd.randn(Brand.Size())].." "..Packtype[rnd.randn(Packtype.Size())];
    }

    ////////////////
    // Affix effects

    override void DoEffect() {
        super.DoEffect();

        Affix aff;
        foreach (aff : appliedAffixes) {
            aff.onDoEffect(owner, self);
        }
    }

    override bool HandlePickup(Inventory pickedUp) {
        Affix aff;
        foreach (aff : appliedAffixes) {
            aff.onHandlePickup(pickedUp);
        }
		return false;
    }
}
