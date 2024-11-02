class RwStatusEffectToken : Inventory {

    Default {
        Inventory.MaxAmount 1000;
    }

    virtual ui string GetStatusName() {
        return "NOT SET - REPORT THIS";
    }

    virtual ui Color GetColorForUi() {
        return Font.CR_BLACK;
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
        if (!owner || owner.health <= 0 || amount <= 0) {
            Destroy();
            return;
        }

        if (owner is 'RwPlayer') {
            doEffectOnRwPlayer();
        } else {
            doEffectOnMonster();
        }
        doAlways();
    }

    private virtual void doEffectOnRwPlayer() {
        return;
    }

    private virtual void doEffectOnMonster() {
        return;
    }

    private virtual void doAlways() {
        return;
    }

}