class RwPlayer : DoomPlayer // Base class; should not be created directly
{
    const WEAPON_SLOTS = 4; // this DOES count the fists

    RandomizedArmor CurrentEquippedArmor;
    RwBackpack CurrentEquippedBackpack;

    int showStatsButtonPressedTicks;
    int scrapItemButtonPressedTicks;

    int minItemQuality, maxItemQuality; // Instead of player level. Used for progression.

    // Health pickups do not trigger HandlePickup(), so that's a workaround for that if needed:
    int previousHealth, lastHealedBy; // May be needed for altering picked up health amount by other items

    default {
        Player.DisplayName "Report a bug if you see this";
        Health 100;
    }

    override void BeginPlay() {
        super.BeginPlay();
        ResetMaxAmmoToDefault();
        minItemQuality = 1;
        maxItemQuality = 100;
    }

    override void Tick() {
        super.Tick();

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
}