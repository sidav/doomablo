// Suffixes are unique things gameplay-wise, so they require this separate definition.
// TODO: optimization of this logic...

mixin class ArmorSuffixable {

    const TPS = 35; // ticks per second

    // call this inside "DoEffect" method for armor
    action void RWA_SuffOnDoEffect() {
        let age = GetAge();
        if (age % TPS != 0) {
            return; // Currently, the effects are applied each second only. This may change though
        }

        // First: self-repair
        if (invoker.stats.currDurability < invoker.stats.maxDurability) {
            let aff = invoker.findAppliedAffix('ASuffSelfrepair');
            if (aff != null) {
                if (age % (TPS * ASuffSelfrepair(aff).modifierLevel) == 0) {
                    invoker.stats.currDurability++;
                }
                return; // There may be no other affix anyway
            }
        }

        // Second: heal the owner
        if (invoker.stats.currDurability > 0 && invoker.owner.health < 100) {
            let aff = invoker.findAppliedAffix('ASuffHealing');
            if (aff != null) {
                if (age % (TPS * ASuffHealing(aff).modifierLevel) == 0) {
                    invoker.owner.GiveBody(1, 100);
                    invoker.stats.currDurability--;
                }
                return; // There may be no other affix anyway
            }
        }

    }

}
