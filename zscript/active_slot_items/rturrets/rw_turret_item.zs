class RwTurretItem : RwActiveSlotItem {
    RwTurretItemStats stats;

    Default {
        Height 26;
        RwActiveSlotItem.Weight 10;
    }
    States {
        Spawn:
          SENB A -1;
          Stop;
    }

    override string GetRandomFluffName() {
      static const string Brand[] =
      {
        "Automated",
        "Robotic",
        "Smart"
      };
      return Brand[rnd.randn(Brand.Size())].." "..rwbaseName;
    }

    override RwActiveSlotItemStats GetStats() {
      return stats;
    }

    override void prepareForGeneration() {
        // let initialMaxDamage = stats.maxDamage;
        stats.minDmg = StatsScaler.ScaleIntValueByLevelRandomized(stats.minDmg, generatedQuality);
        stats.maxDmg = StatsScaler.ScaleIntValueByLevelRandomized(stats.maxDmg, generatedQuality);
        stats.turretHealth = StatsScaler.ScaleIntValueByLevelRandomized(stats.turretHealth, generatedQuality);
    }

    ////////////////
    // Affix effects

    override bool HandlePickup(Inventory pickedUp) {
      Affix aff;
      foreach (aff : appliedAffixes) {
          aff.onHandlePickup(pickedUp);
      }
      return false;
    }

    // USAGE

    action void RwUse() {
      if (invoker.cooldownTicksRemaining > 0) return;
      if (invoker.currentCharges < invoker.stats.chargeConsumption) return;

      foreach (aff : invoker.appliedAffixes) {
        aff.onBeingUsed(invoker.owner, invoker);
      }

      // Spawn the turret
      bool isSpawned;
      Actor spawnedTurret;
      for (let addHeight = 48; addHeight >= 0; addHeight -= 16) {
        [isSpawned, spawnedTurret] = invoker.owner.A_SpawnItem("BaseRwTurretActor", 48, addHeight);
        if (isSpawned) break;
      }
      if (!isSpawned) {
        invoker.owner.A_PrintBold("No room for sentry placement");
        return;
      }
      
      let trt = BaseRwTurretActor(spawnedTurret);

      // Apply the stats to the turret
      trt.BaseName = "LVL "..invoker.generatedQuality.." Sentry";      
      trt.starthealth = invoker.stats.turretHealth;
      trt.A_SetHealth(invoker.stats.turretHealth);
      trt.minDmg = invoker.stats.minDmg;
      trt.maxDmg = invoker.stats.maxDmg;
      trt.additionalDamagePromille = invoker.stats.additionalDamagePromille;
      trt.horizSpread = invoker.stats.turretHSpread;
      trt.lifetimeTics = gametime.secondsToTicks(invoker.stats.turretLifeSeconds);
      // apply this item's affixes for spawned turred (minion)
      foreach (aff : invoker.appliedAffixes) {
        aff.onPlayerMinionSpawned(invoker.owner, invoker, trt);
      }
      RwTurretAffixCaller.AffixateTurretWithItem(trt, invoker);

      // Spend charges
      invoker.currentCharges -= invoker.stats.chargeConsumption;
      invoker.cooldownTicksRemaining = invoker.stats.usageCooldownTicks;
      // Usage flash
      invoker.owner.A_StartSound("Flasks/Quaff", CHAN_AUTO);
      invoker.owner.Player.bonusCount += 1;
    }

    override int GetMaxCharges() {
      return stats.maxCharges;
    }

    override int GetChargesConsumptionPerUse() {
      return stats.chargeConsumption;
    }

    // METHODS FOR AFFIXABLE:
    override void setBaseStats() {
      rwbaseName = "Turret";
      stats = New('RwTurretItemStats');

      stats.TurretHealth = 100;
      stats.minDmg = 3;
      stats.maxDmg = 5;
      stats.turretHSpread = 12.5;
      stats.TurretLifeSeconds = 10;

      stats.chargeConsumption = 1;
      stats.maxCharges = 100;
      stats.usageCooldownTicks = 1 * TICRATE;
    }
}