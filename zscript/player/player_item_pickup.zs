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
        weap.printPickupMessage(true, weap.pickupMessage());
    }

    void PickUpArmor(RwArmor armr) {
        // First, check if we already have armor
        let hasEmptySlot = CurrentEquippedArmor == null;
        // Picking up the weapon.
        if (!hasEmptySlot) {
            CurrentEquippedArmor.DetachFromOwner();
            DropInventory(CurrentEquippedArmor);
        }
        AddInventory(armr);
        CurrentEquippedArmor = armr;
        armr.printPickupMessage(true, armr.pickupMessage());
    }

    void PickUpBackpack(RwBackpack bkpk) {
        let hasEmptySlot = CurrentEquippedBackpack == null;
        if (!hasEmptySlot) {
            CurrentEquippedBackpack.DetachFromOwner();
            DropInventory(CurrentEquippedBackpack);
        }
        AddInventory(bkpk);
        CurrentEquippedBackpack = bkpk;
        bkpk.printPickupMessage(true, bkpk.pickupMessage());
    }

    void PickUpActiveSlotItem(RwActiveSlotItem itm) {
        let hasEmptySlot = EquippedActiveSlotItem == null;
        if (!hasEmptySlot) {
            EquippedActiveSlotItem.DetachFromOwner();
            DropInventory(EquippedActiveSlotItem);
        }
        AddInventory(itm);
        EquippedActiveSlotItem = itm;
        itm.printPickupMessage(true, itm.pickupMessage());
    }
}