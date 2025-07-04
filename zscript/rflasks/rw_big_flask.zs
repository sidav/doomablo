class RwBigFlask : RwFlask {
    States {
        Spawn:
          FSKB A -1;
          Stop;
    }

    // METHODS FOR AFFIXABLE:

    override void setBaseStats() {
      rwbaseName = "Bottle";
      stats = New('RwFlaskStats');
      stats.healsUntilPercentage = 100;

      stats.healAmount = 15;
      stats.healDurationTicks = 3 * TICRATE;

      stats.chargeConsumption = 15;
      stats.maxCharges = 100;

      stats.usageCooldownTicks = 8 * TICRATE;
    }
}