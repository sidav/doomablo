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
      stats.healAmount = 15;
      stats.healDurationTicks = 3 * TICRATE;
      stats.maxCharges = 30;
      stats.chargeConsumption = 25;
      stats.usageCooldownTicks = 10 * TICRATE;
    }
}