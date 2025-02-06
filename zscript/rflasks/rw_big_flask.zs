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
      stats.healAmount = 100;
      stats.healDurationTicks = 20 * TICRATE;
      stats.maxCharges = 100;
      stats.chargeConsumption = 25;
      stats.usageCooldownTicks = 30 * TICRATE;
    }
}