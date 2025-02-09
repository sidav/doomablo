class RWProtectedToken : RwStatusEffectToken {

    int reductionPercentage;

    Default {
        Inventory.Amount 10;
        RwStatusEffectToken.ReductionPeriodTicks TICRATE;
    }

    override int GetAlignment() {
        return 1;
    }

    override string GetStatusName() {
        return "PROTECTED "..reductionPercentage.."%";
    }

    override Color GetColorForUi() {
        return Font.CR_SAPPHIRE;
    }

    static void ApplyToActor(Actor target, int reductionPercentage, int durationSeconds) {
        target.GiveInventory('RWProtectedToken', durationSeconds);
        let token = target.FindInventory('RWProtectedToken');
        if (token) {
            RWProtectedToken(token).reductionPercentage = reductionPercentage;
        }
    }

    override void ModifyDamage(int damage, Name damageType, out int newdamage, bool passive, Actor inflictor, Actor source, int flags) {
        if (owner.Health <= 0) {
            return;
        }
        // Passive is True if the attack is being received by the owner. False if the attack is being dealt by the owner.
        if (passive) {
            newdamage = math.getIntPercentage(damage, 100 - reductionPercentage);
        }
    }

    override void doEffectOnRwPlayer() {}
    override void doEffectOnMonster() {} // Unimplemented (unneeded?)
    override void doAlways() {}
}