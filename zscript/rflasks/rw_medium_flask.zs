class RwMediumFlask : RwFlask {
    States {
        Spawn:
          FSKM A -1;
          Stop;
    }

    // METHODS FOR AFFIXABLE:

    override void setBaseStats() {
      rwbaseName = "Flask";
      stats = New('RwFlaskStats');
      stats.healsUntilPercentage = 100;

      stats.healAmount = 40;
      stats.healDurationTicks = 5 * TICRATE;

      stats.chargeConsumption = 30;
      stats.maxCharges = 50;

      stats.usageCooldownTicks = 30 * TICRATE;
    }
}