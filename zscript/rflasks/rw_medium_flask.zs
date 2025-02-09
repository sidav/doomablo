class RwMediumFlask : RwFlask {
    States {
        Spawn:
          MRP2 A -1;
          Stop;
    }

    // METHODS FOR AFFIXABLE:

    override void setBaseStats() {
      rwbaseName = "Potion";
      stats = New('RwFlaskStats');
      stats.healsUntilPercentage = 100;

      stats.healAmount = 35;
      stats.healDurationTicks = 7 * TICRATE;

      stats.chargeConsumption = 25;
      stats.maxCharges = 50;

      stats.usageCooldownTicks = 30 * TICRATE;
    }
}