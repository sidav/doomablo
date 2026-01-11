class RwSmallFlask : RwFlask {
    States {
        Spawn:
          FSKS A -1;
          Stop;
    }

    // METHODS FOR AFFIXABLE:

    override void setBaseStats() {
      rwbaseName = "Vial";
      stats = New('RwFlaskStats');
      stats.healsUntilPercentage = 100;

      stats.healAmount = 100;
      stats.healDurationTicks = 40 * TICRATE;

      stats.chargeConsumption = 30;
      stats.maxCharges = 35;

      stats.usageCooldownTicks = 60 * TICRATE;
    }
}