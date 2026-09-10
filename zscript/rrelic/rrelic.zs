class RwRelic: Inventory {
    mixin Affixable;
    string rwbaseName;

    int rweight; // Just like in the others, this is the weight for random drops
    Property Weight: rweight;

    Default {
		Height 26;
        RwRelic.Weight 10;
		Inventory.PickupMessage "You have found a relic!";
    }
	States {
        Spawn:
            MMAP ABCD 15;
            Loop;
	}

    // Needs to be called before generation
    private void prepareForGeneration() {
    }

    // Needs to be called after generation
    private void finalizeAfterGeneration() {
    }

    // Needed if the item should be re-generated
    private void RW_Reset() {
        appliedAffixes.Clear();
        rwbaseName = "Tacticomp";
        nameWithAppliedAffixes = rwBaseName;
    }

    override void BeginPlay() {
        RW_Reset();
    }

    virtual string GetRandomFluffName() {
        static const string Brand[] =
        {
            "Positional",
            "Positron",
            "Quantum",
            "Tactical",
            "UAC"
        };
        static const string Packtype[] =
        {
            "Analyzer",
            "Combat HUD"
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

    override void ModifyDamage(int damage, Name damageType, out int newdamage, bool passive, Actor inflictor, Actor source, int flags) {
        newdamage = damage;
        Affix aff;
        foreach (aff : appliedAffixes) {
            aff.onModifyDamage(damage, newdamage, passive, inflictor, source, owner, flags);
            damage = newdamage;
        }
    }

    // Pickup routines
    void rwTouch(Actor toucher) {
      let plrInfo = toucher.player;
      if (plrInfo) {
          let plrActor = RwPlayer(toucher);
          plrActor.PickUpRelic(self);
          onPickup(toucher);
      }
    }

    void OnPickup(in out Actor toucher) {
      DoPickupSpecial(toucher);
      AttachToOwner(toucher);
    }
}