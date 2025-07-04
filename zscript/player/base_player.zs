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
            // debug.warning("Basic armor exists! Amount: "..ba.Amount);
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

    void GetAmmoByCapPercentage(class<Ammo> type, int percentage) {
        let item = FindInventory(type);
        if (item != NULL) {
            let toGive = math.GetIntPercentage(item.MaxAmount, percentage);
            if (toGive == 0) toGive = 1;
            item.amount = min(item.MaxAmount, item.amount + toGive);
        }
    }

    ///////////////////////////
    // Stats/EXP related
    void reapplyPlayerStats() {
        if (stats == null) {
            stats = RwPlayerStats.Create();
        }

        if (!(stats.baseStatsChanged || didEquippedItemsChange())) return;
        stats.baseStatsChanged = false;
        stats.ResetCurrentStats();
        applyPlayerStatsFromEquippedItems();

        // Apply max health
        let initialMaxHp = MaxHealth;
        MaxHealth = stats.GetMaxHealth();
        let diff = MaxHealth - initialMaxHp;
        // Add/remove health if max hp is changed.
        if (diff > 0)
            GiveBody(MaxHealth - initialMaxHp, MaxHealth);
        else if (Health > -diff) // Don't kill the player!
            damageMobj(null, null, -diff, 'Normal', DMG_NO_PROTECT|DMG_NO_ARMOR|DMG_NO_PAIN);
    }

    // We store those to detect eqipped item changes
    private Inventory prevTickArmor, prevTickBackpack, prevTickWeapon, prevTickFlask;
    private bool didEquippedItemsChange() {
        let changed = false;
        if (prevTickWeapon != Player.ReadyWeapon) {
            changed = true;
            prevTickWeapon = Player.ReadyWeapon;
        }
        if (prevTickArmor != CurrentEquippedArmor) {
            changed = true;
            prevTickArmor = CurrentEquippedArmor;
        }
        if (prevTickBackpack != CurrentEquippedBackpack) {
            changed = true;
            prevTickBackpack = CurrentEquippedBackpack;
        }
        if (prevTickFlask != CurrentEquippedFlask) {
            changed = true;
            prevTickFlask = CurrentEquippedFlask;
        }
        return changed;
    }

    // This reapplies the stats modifiers if the equipped items have changed. Don't call this too frequently, it's slow
    private void applyPlayerStatsFromEquippedItems() {
        if (CurrentEquippedArmor != null) {
            foreach (aff : CurrentEquippedArmor.appliedAffixes) {
                aff.onPlayerStatsRecalc(self);
            }
        }
        if (CurrentEquippedBackpack != null) {
            foreach (aff : CurrentEquippedBackpack.appliedAffixes) {
                aff.onPlayerStatsRecalc(self);
            }
        }
        if (CurrentEquippedFlask != null) {
            foreach (aff : CurrentEquippedFlask.appliedAffixes) {
                aff.onPlayerStatsRecalc(self);
            }
        }
        if (Player) {
            let currWpn = RandomizedWeapon(Player.ReadyWeapon);
            if (currWpn != null) {
                foreach (aff : currWpn.appliedAffixes) {
                    aff.onPlayerStatsRecalc(self);
                }
            }
        }
    }

    void ReceiveExperience(double amount) {
        let levelBefore = stats.currentExpLevel;
        stats.AddExperience(amount);
        if (rw_heal_on_levelup && levelBefore < stats.currentExpLevel) {
            GiveBody(stats.GetMaxHealth()/2);
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