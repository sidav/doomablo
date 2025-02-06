class RwFlask : Inventory {
    mixin Affixable;
    RwFlaskStats stats;
    string rwbaseName;

    // Current vars
    int currentCharges, cooldownTicksRemaining;

    Default {
        Height 26;
        FloatBobStrength 0.75;
        +FLOATBOB
    }
    States {
        Spawn:
          HPP1 A -1;
          Stop;
    }

    override void BeginPlay() {
      RW_Reset();
    }

    // METHODS FOR AFFIXABLE:

    private void RW_Reset() {
      appliedAffixes.Clear();
      setBaseStats();
      nameWithAppliedAffixes = rwBaseName;
    }

    virtual void setBaseStats() {
      debug.panicUnimplemented(self);
    }

    // Needs to be called before generation
    private void prepareForGeneration() {
    }

    // Needs to be called after generation
    private void finalizeAfterGeneration() {}

    virtual string GetRandomFluffName() {
      static const string Brand[] =
      {
        "Estus",
        "Rejuvenating",
        "Soul-bound"
      };
      return Brand[rnd.randn(Brand.Size())].." "..rwbaseName;
    }

    ////////////////
    // Affix effects

    override void DoEffect() {
      super.DoEffect();

      if (cooldownTicksRemaining > 0) {
        cooldownTicksRemaining--;
      }

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

    // TODO: move it to affixable?
    override void Touch(Actor toucher) {
      return;
    }

    void rwTouch(Actor toucher) {
      let plrInfo = toucher.player;
      if (plrInfo) {
          let plrActor = RwPlayer(toucher);
          plrActor.PickUpFlask(self);
          onPickup(toucher);
      }
    }

    void OnPickup(in out Actor toucher) {
      DoPickupSpecial(toucher);
      AttachToOwner(toucher);
    }

    // USAGE

    clearscope int getChargesPercentage() {
      return math.getIntPercentage(currentCharges, stats.maxCharges);
    }

    action void RwUse() {
      debug.print("I'm used!");
    }
}