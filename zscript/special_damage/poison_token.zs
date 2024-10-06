class RWPoisonToken : RWSpecialDamageToken {

    Default {
        Inventory.Amount 10;
    }

    override void Tick() {
        super.Tick();
        if (gametime.checkPeriod(GetAge(), 2)) {
            if (!owner || owner.health <= 0 || amount <= 0) {
                Destroy();
            }
            if (owner) {
                // debug.print("Damaging: amount "..amount..", damage "..damage());
                owner.damageMobj(null, null, damage(), 'Normal', DMG_NO_PROTECT);
            }
            amount -= 2;
        }
    }

    private int damage() {
        return (amount/3 + 1);
    }

}