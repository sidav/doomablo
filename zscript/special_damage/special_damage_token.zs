class RWSpecialDamageToken : Inventory {

    Default {
        Inventory.MaxAmount 1000;
    }

    override bool HandlePickup(Inventory pickedUp) {
        if (GetClass() == pickedUp.GetClass()) {
            amount += pickedUp.amount;
            if (amount > MaxAmount) {
                amount = MaxAmount;
            }
            pickedUp.bPickupgood = true;
            return true;
        }
		return false;
    }

    override void Tick() {
        super.Tick();
    }

}