class MyPlayer : DoomPlayer
{
    const WEAPON_SLOTS = 4; // this DOES count the fists

    default {
        Player.DisplayName "RW Marine";
        Health 100;
    }

    override void Tick() {
        super.Tick();
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
}