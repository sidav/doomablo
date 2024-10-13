class RwBackpack : Inventory {

    mixin Affixable;
    string rwbaseName;
    RwBackpackStats stats;

    virtual void setBaseStats() {
		rwbaseName = "Backpack";
		stats = New('RwBackpackStats');
		stats.maxBull = 200;
		stats.maxShel = 50;
		stats.maxRckt = 50;
		stats.maxCell = 300;
    }

    // Needs to be called after generation
    private void finalizeAfterGeneration() {
        return;
    }

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

    Default
	{
		Height 26;
		// Inventory.PickupMessage "$GOTBACKPACK";
	}
	States
	{
	Spawn:
		BPAK A -1;
		Stop;
	}
}
