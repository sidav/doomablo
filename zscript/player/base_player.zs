class RwPlayer : DoomPlayer // Base class; should not be created directly
{
    const WEAPON_SLOTS = 4; // this DOES count the fists

    RwPlayerStats stats;

    RandomizedArmor CurrentEquippedArmor;
    RwBackpack CurrentEquippedBackpack;
    RwFlask CurrentEquippedFlask;

    int showStatsButtonPressedTicks;
    int scrapItemButtonPressedTicks;

    int infernoLevel; // Determines the levels of the generated monsters. Also determines the goodness of the drops you get.
    const maxInfernoLevel = 100;

    // Health pickups do not trigger HandlePickup(), so that's a workaround for that if needed:
    int previousHealth, lastHealedBy; // May be needed for altering picked up health amount by other items

    default {
        Player.DisplayName "Report a bug if you see this";
        Health 100;
    }

    override void BeginPlay() {
        super.BeginPlay();
        ResetMaxAmmoToDefault();
        infernoLevel = 1;
        reapplyPlayerStats();
    }

    override void Tick() {
        super.Tick();
        reapplyPlayerStats();

        let ba = FindInventory('BasicArmor');
        if (ba != null) {
            // debug.print("Basic armor exists! Amount: "..ba.Amount);
            if (CurrentEquippedArmor != null) {
                CurrentEquippedArmor.RepairFor(ba.Amount);
            }
            ba.Destroy();
        }
        if (Player.cmd.buttons & BT_RELOAD) {
            showStatsButtonPressedTicks++;
        } else {
            showStatsButtonPressedTicks = 0;
        };

        // "Scrap item" button
        if (Player.cmd.buttons & BT_USER1) {
            onScrapItemButtonPressed();
        } else {
            scrapItemButtonPressedTicks = 0;
        }
        if (Player.cmd.buttons & BT_USER2) {
            if (CurrentEquippedFlask != null) {
                CurrentEquippedFlask.RwUse();
            }
        }
        if (Player.cmd.buttons & BT_USER3) {
            Menu.SetMenu('RWEquippedArtifactsMenu');
        }
        if (Player.cmd.buttons & BT_USER4) {
            Menu.SetMenu('RWLevelupMenu');
        }

        // Health pickups do not trigger HandlePickup(), so that's a workaround:
        if (previousHealth < Health) {
            lastHealedBy = Health - previousHealth;
        } else {
            lastHealedBy = 0;
        }
        previousHealth = health;
    }

    void ResetMaxAmmoToDefault() {
        SetAmmoCapacity('Clip', 100);
        SetAmmoCapacity('Shell', 40);
        SetAmmoCapacity('Rocketammo', 30);
        SetAmmoCapacity('Cell', 100);
    }

    // Stats/EXP related
    void reapplyPlayerStats() {
        if (stats == null) {
            stats = RwPlayerStats.Create();
        }
        if (!stats.statsChanged) return;
        stats.statsChanged = false;

        // Apply max health
        let initialMaxHp = MaxHealth;
        MaxHealth = stats.GetMaxHealth();
        GiveBody(MaxHealth - initialMaxHp, MaxHealth);
    }

    void ReceiveExperience(double amount) {
        let levelBefore = stats.currentExpLevel;
        stats.AddExperience(amount);
        if (rw_heal_on_levelup && levelBefore < stats.currentExpLevel) {
            GiveBody(stats.GetMaxHealth(), stats.GetMaxHealth());
        }
    }

    // Progression-related
    const infernoLevelRangeSize = 5;
    clearscope int, int getDropsRangeForInfernoLevel() {
        return infernoLevel, clamp(infernoLevel+infernoLevelRangeSize-1, 1, 100);
    }

    clearscope int rollForDropLevel() {
        return rnd.multipliedWeightedRand(infernoLevel, min(100, infernoLevel + infernoLevelRangeSize-1), 1.0/2.0);
    }
}