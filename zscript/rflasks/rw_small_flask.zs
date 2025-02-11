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

      stats.healAmount = 120;
      stats.healDurationTicks = 40 * TICRATE;

      stats.chargeConsumption = 25;
      stats.maxCharges = 30;

      stats.usageCooldownTicks = 60 * TICRATE;
    }
}