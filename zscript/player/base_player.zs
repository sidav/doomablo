class RwPlayer : DoomPlayer
{
    const WEAPON_SLOTS = 4; // this DOES count the fists

    RandomizedArmor CurrentEquippedArmor;
    RwBackpack CurrentEquippedBackpack;

    int showStatsButtonPressedTicks;
    int minItemQuality, maxItemQuality; // Instead of player level. Used for progression.

    // Health pickups do not trigger HandlePickup(), so that's a workaround for that if needed:
    int previousHealth, lastHealedBy; // May be needed for altering picked up health amount by other items

    default {
        Player.DisplayName "Random Drops";
        Health 100;
    }

    virtual bool ProgressionEnabled() {
        return false;
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

         // Health pickups do not trigger HandlePickup(), so that's a workaround:
        if (previousHealth < Health) {
            lastHealedBy = Health - previousHealth;
        } else {
            lastHealedBy = 0;
        }
        previousHealth = health;
    }

    Weapon GetWeaponInstanceInSlot(int slot) {
        let invlist = inv;
        while(invlist != null) {
            if ( Weapon(invlist) != null && Weapon(invlist).SlotNumber == slot) {
                return Weapon(invlist);
            }
            invlist=invlist.Inv;
        };
        return null;
    }

    bool HasEmptyWeaponSlot() {
        // let pinfo = player;
        let totalWeapons = 0;
        let invlist = inv;
        while(invlist != null) {
            if( Weapon(invlist) ) {
                totalWeapons++;
            }
            invlist=invlist.Inv;
        };
        // console.printf("Total weapons counted: "..totalWeapons);
        return totalWeapons < WEAPON_SLOTS;
    }

    void ResetMaxAmmoToDefault() {
        SetAmmoCapacity('Clip', 100);
        SetAmmoCapacity('Shell', 40);
        SetAmmoCapacity('Rocketammo', 30);
        SetAmmoCapacity('Cell', 100);
    }

    bool HasEmptyWeaponSlotFor(Weapon weap) {        
        return (GetWeaponInstanceInSlot(weap.SlotNumber) == null) && HasEmptyWeaponSlot();
    }

    void PickUpWeapon(Weapon weap) {
        // First, check if we have empty slots
        let hasEmptySlot = HasEmptyWeaponSlotFor(weap);
        // Picking up the weapon.
        if (!hasEmptySlot) {
            Weapon currentWeapon = GetWeaponInstanceInSlot(weap.SlotNumber);
            if (currentWeapon) {
                currentWeapon.DetachFromOwner();
                DropInventory(currentWeapon);
            }
        }
        AddInventory(weap);
        player.PendingWeapon = weap;
    }

    void PickUpArmor(RandomizedArmor armr) {
        // First, check if we already have armor
        let hasEmptySlot = CurrentEquippedArmor == null;
        // Picking up the weapon.
        if (!hasEmptySlot) {
            CurrentEquippedArmor.DetachFromOwner();
            DropInventory(CurrentEquippedArmor);
        }
        AddInventory(armr);
        CurrentEquippedArmor = armr;
    }

    void PickUpBackpack(RwBackpack bkpk) {
        let hasEmptySlot = CurrentEquippedBackpack == null;
        if (!hasEmptySlot) {
            CurrentEquippedBackpack.DetachFromOwner();
            DropInventory(CurrentEquippedBackpack);
        }
        AddInventory(bkpk);
        CurrentEquippedBackpack = bkpk;        
    }
}