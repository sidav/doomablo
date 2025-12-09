class RwFlask : RwActiveSlotItem abstract {
    RwFlaskStats stats;

    Default {
        Height 26;
        RwActiveSlotItem.Weight 10;
    }
    States {
        Spawn:
          HPP1 A -1;
          Stop;
    }

    override string GetRandomFluffName() {
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

    override bool HandlePickup(Inventory pickedUp) {
      Affix aff;
      foreach (aff : appliedAffixes) {
          aff.onHandlePickup(pickedUp);
      }
      return false;
    }

    // USAGE

    action void RwUse() {
      if (invoker.cooldownTicksRemaining > 0) return;
      if (invoker.currentCharges < invoker.stats.chargeConsumption) return;

      foreach (aff : invoker.appliedAffixes) {
        aff.onBeingUsed(invoker.owner, invoker);
      }

      invoker.currentCharges -= invoker.stats.chargeConsumption;
      invoker.cooldownTicksRemaining = invoker.stats.usageCooldownTicks;
      RWHealingToken.ApplyToActor(invoker.owner, invoker.stats.healAmount, invoker.stats.healsUntilPercentage, invoker.stats.healDurationTicks);

      invoker.owner.A_StartSound("Flasks/Quaff", CHAN_AUTO);
      invoker.owner.Player.bonusCount += 1;
    }

    override int GetMaxCharges() {
      return stats.maxCharges;
    }

    override int GetChargesConsumptionPerUse() {
      return stats.chargeConsumption;
    }
}