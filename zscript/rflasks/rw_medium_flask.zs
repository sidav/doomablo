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
      stats.healAmount = 40;
      stats.healDurationTicks = 5 * TICRATE;
      stats.maxCharges = 50;
      stats.chargeConsumption = 25;
      stats.usageCooldownTicks = 15 * TICRATE;
      stats.healsUntilPercentage = 100;
    }
}