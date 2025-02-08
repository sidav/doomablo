class RwStatusEffectToken : Inventory {

    int ReductionPeriodTicks; // 0 means amount is never reduced
    property ReductionPeriodTicks:ReductionPeriodTicks;

    Default {
        Inventory.MaxAmount 1000;
        RwStatusEffectToken.ReductionPeriodTicks 0;
    }

    // -1 bad, 0 neutral, 1 good
    virtual int GetAlignment() {
        debug.panic("Alignment not set for "..self.GetClassName());
        return 0;
    }

    virtual ui string GetStatusName() {
        return "NOT SET - REPORT THIS";
    }

    virtual ui string GetStatusNumber() {
        return ""..amount;
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
        if (ReductionPeriodTicks > 0 && amount > 0 && GetAge() > 0 && GetAge() % ReductionPeriodTicks == 0) {
            amount--;
        }
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