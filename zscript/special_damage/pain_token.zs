class RWPainToken : RWSpecialDamageToken {

    Default {
        Inventory.Amount 5;
        Inventory.MaxAmount 5;
    }

    const EffectEach = TICRATE / 7;

    override void Tick() {
        super.Tick();
        if (!owner || owner.health <= 0 || amount <= 0) {
            Destroy();
            return;
        }
        if ((GetAge() % EffectEach == 0) && rnd.PercentChance(50)) {
            let painState = owner.ResolveState('Pain');
            if (painState) {
                owner.SetState(painState);
            }
        }
        if (GetAge() % TICRATE == 0) {
            amount--;
        }
    }
}