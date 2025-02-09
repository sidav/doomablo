class RwFlask : Inventory {
    mixin Affixable;
    RwFlaskStats stats;
    string rwbaseName;

    // Current vars
    int currentCharges, cooldownTicksRemaining;

    Default {
        Height 26;
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
        "Ashen",
        "Crystal",
        "Estus",
        "Fulminating",
        "Glowing",
        "Quartz",
        "Refreshing",
        "Rejuvenating",
        "Shining",
        "Sparkling",
        "Soul-bound",
        "Warm"
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

    // Refill on kill is inside RWOnWeaponDamageDealtHandler
    override void ModifyDamage(int damage, Name damageType, out int newdamage, bool passive, Actor inflictor, Actor source, int flags) {
      newdamage = damage;
      Affix aff;
      foreach (aff : appliedAffixes) {
          aff.onModifyDamage(damage, newdamage, passive, inflictor, source, owner, flags);
          damage = newdamage;
      }
    }

    void Refill(int amount) {
      currentCharges += amount;
      currentCharges = min(currentCharges, stats.maxCharges);
    }

    action void RwUse() {
      if (invoker.cooldownTicksRemaining > 0) return;
      if (invoker.currentCharges < invoker.stats.chargeConsumption) return;

      foreach (aff : invoker.appliedAffixes) {
        aff.onBeingUsed(invoker.owner, invoker);
      }

      invoker.currentCharges -= invoker.stats.chargeConsumption;
      invoker.cooldownTicksRemaining = invoker.stats.usageCooldownTicks;
      RWHealingToken.ApplyToActor(invoker.owner, invoker.stats.healAmount, invoker.stats.healsUntilPercentage, invoker.stats.healDurationTicks);

      A_StartSound("Flasks/Quaff", CHAN_ITEM, volume: 1.25);
      invoker.owner.Player.bonusCount += 1;
    }
}