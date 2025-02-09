class RwSmallFlask : RwFlask {
    States {
        Spawn:
          HPP1 A -1;
          Stop;
    }

    // METHODS FOR AFFIXABLE:

    override void setBaseStats() {
      rwbaseName = "Vial";
      stats = New('RwFlaskStats');
      stats.healsUntilPercentage = 100;

      stats.healAmount = 20;
      stats.healDurationTicks = 3 * TICRATE;

      stats.chargeConsumption = 20;
      stats.maxCharges = 30;

      stats.usageCooldownTicks = 10 * TICRATE;
    }
}