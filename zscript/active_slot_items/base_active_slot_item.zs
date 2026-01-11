class RwActiveSlotItem : Inventory abstract {
    mixin Affixable;
    string rwbaseName;

    // Current vars
    int currentCharges, cooldownTicksRemaining;

    int rweight;
    Property Weight: rweight;
    Default {
        RwActiveSlotItem.Weight 10;
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
    private virtual void prepareForGeneration() {
    }

    // Needs to be called after generation
    private void finalizeAfterGeneration() {}

    virtual string GetRandomFluffName() {
      debug.panicUnimplemented(self);
      return "Error";
    }

    // TODO: move it to affixable?
    override void Touch(Actor toucher) {
      return;
    }

    void rwTouch(Actor toucher) {
      let plrInfo = toucher.player;
      if (plrInfo) {
          let plrActor = RwPlayer(toucher);
          plrActor.PickUpActiveSlotItem(self);
          onPickup(toucher);
      }
    }

    void OnPickup(in out Actor toucher) {
      DoPickupSpecial(toucher);
      AttachToOwner(toucher);
    }

    // Needed to use polymorphism for the stats
    virtual clearscope RwActiveSlotItemStats GetStats() {
      debug.panicUnimplemented(self);
      return null;
    }

    // USAGE

    override void DoEffect() {
      super.DoEffect();

      if (cooldownTicksRemaining > 0) {
        cooldownTicksRemaining--;
        if (owner && cooldownTicksRemaining == 0 && (currentCharges >= GetChargesConsumptionPerUse())) {
          owner.A_StartSound("Flasks/Ready", CHAN_AUTO);
        }
      }

      Affix aff;
      foreach (aff : appliedAffixes) {
          aff.onDoEffect(owner, self);
      }
    }

    void Refill(int amount) {
      bool enoughBefore = currentCharges >= GetChargesConsumptionPerUse();
      currentCharges += amount;
      currentCharges = min(currentCharges, GetMaxCharges());
      if (owner && !enoughBefore && currentCharges >= GetChargesConsumptionPerUse() && cooldownTicksRemaining == 0) {
          owner.A_StartSound("Flasks/Ready", CHAN_AUTO);
      }
    }

    // Refill on kill is inside RWOnWeaponDamageDealtHandler
    override void ModifyDamage(int damage, Name damageType, out int newdamage, bool passive, Actor inflictor, Actor source, int flags) {
      newdamage = damage;
      Affix aff;
      foreach (aff : appliedAffixes) {
          aff.onModifyDamage(damage, newdamage, passive, inflictor, source, owner, flags);
          damage = newdamage;
      }
    }

    clearscope virtual int GetMaxCharges() {
      debug.panicUnimplemented(self);
      return 0;
    }

    clearscope virtual int GetChargesConsumptionPerUse() {
      debug.panicUnimplemented(self);
      return 0;
    }
}