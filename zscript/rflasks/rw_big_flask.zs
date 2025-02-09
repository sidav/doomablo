class RwBigFlask : RwFlask {
    States {
        Spawn:
          PRP3 A -1;
          Stop;
    }

    // METHODS FOR AFFIXABLE:

    override void setBaseStats() {
      rwbaseName = "Flask";
      stats = New('RwFlaskStats');
      stats.healsUntilPercentage = 100;

      stats.healAmount = 100;
      stats.healDurationTicks = 30 * TICRATE;

      stats.chargeConsumption = 30;
      stats.maxCharges = 100;

      stats.usageCooldownTicks = 60 * TICRATE;
    }
}