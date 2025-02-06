extend class RwPlayer {
    clearscope Weapon GetWeaponInInvByClass(class < Weapon > wClass) {
        let invlist = inv;
        while(invlist != null) {
            if (invlist != null && invlist.GetClass() == wClass) {
                return Weapon(invlist);
            }
            invlist=invlist.Inv;
        };
        return null;
    }

    void PickUpWeapon(Weapon weap) {
        // First, check if we have weapon of the same class
        Weapon currentWeapon = GetWeaponInInvByClass(weap.GetClass());
        // Picking up the weapon.
        if (currentWeapon) {
            currentWeapon.DetachFromOwner();
            DropInventory(currentWeapon);
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

    void PickUpFlask(RwFlask fsk) {
        let hasEmptySlot = CurrentEquippedFlask == null;
        if (!hasEmptySlot) {
            CurrentEquippedFlask.DetachFromOwner();
            DropInventory(CurrentEquippedFlask);
        }
        AddInventory(fsk);
        CurrentEquippedFlask = fsk;
    }

    // OLD CODE

    // bool HasEmptyWeaponSlotFor(Weapon weap) {        
    //     return (GetWeaponInstanceInSlot(weap.SlotNumber) == null) && HasEmptyWeaponSlot();
    // }

    // Weapon GetWeaponInstanceInSlot(int slot) {
    //     let invlist = inv;
    //     while(invlist != null) {
    //         if ( Weapon(invlist) != null && Weapon(invlist).SlotNumber == slot) {
    //             return Weapon(invlist);
    //         }
    //         invlist=invlist.Inv;
    //     };
    //     return null;
    // }

    // bool HasEmptyWeaponSlot() {
    //     // let pinfo = player;
    //     let totalWeapons = 0;
    //     let invlist = inv;
    //     while(invlist != null) {
    //         if( Weapon(invlist) ) {
    //             totalWeapons++;
    //         }
    //         invlist=invlist.Inv;
    //     };
    //     // console.printf("Total weapons counted: "..totalWeapons);
    //     return totalWeapons < WEAPON_SLOTS;
    // }

    // void PickUpWeapon(Weapon weap) {
    //     // First, check if we have empty slots
    //     let hasEmptySlot = HasEmptyWeaponSlotFor(weap);
    //     // Picking up the weapon.
    //     if (!hasEmptySlot) {
    //         Weapon currentWeapon = GetWeaponInstanceInSlot(weap.SlotNumber);
    //         if (currentWeapon) {
    //             currentWeapon.DetachFromOwner();
    //             DropInventory(currentWeapon);
    //         }
    //     }
    //     AddInventory(weap);
    //     player.PendingWeapon = weap;
    // }
}