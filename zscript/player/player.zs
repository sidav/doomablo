class MyPlayer : DoomPlayer
{
    const WEAPON_SLOTS = 4; // this DOES count the fists

    RandomizedArmor CurrentEquippedArmor;
    int showStatsButtonPressedTicks;
    int minItemQuality, maxItemQuality; // Instead of player level. Used for progression.

    default {
        Player.DisplayName "RW Marine";
        Health 100;
    }

    override void BeginPlay() {
        super.BeginPlay();
        if (CVar.GetCVar('rw_progression_enabled', null).GetBool()) {
            minItemQuality = 1;
            maxItemQuality = 5;
        } else {
            minItemQuality = 1;
            maxItemQuality = 100;
        }
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
}