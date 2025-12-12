class RwTurretItemSuffix : RwBaseActiveSlotItemAffix abstract {
    override void InitAndApplyEffectToItem(Inventory item, int quality) {
        initAndapplyEffectToRTurretItm(RwTurretItem(item), quality);
    }
    protected virtual void initAndapplyEffectToRTurretItm(RwTurretItem turr, int quality) {
        debug.panicUnimplemented(self);
    }
    override bool IsCompatibleWithItem(Inventory item) {
        return (RwTurretItem(item) != null);
    }
    override bool isSuffix() {
        return true;
    }
    override int getAlignment() {
        return 1;
    }
    override int minRequiredRarity() {
        return 3; // Most suffixes require at least "rare"
    }
    override int selectionProbabilityPercentage() {
        return 50;
    }
}

class TurrSuffArmorRepair : RwTurretItemSuffix {
    override string getName() {
        return "Emergency";
    }
    override int getAlignment() {
        return 1;
    }
    override string getDescription() {
        return String.format("Repairs %d%% of your armor on use", (modifierLevel) );
    }
    override void initAndapplyEffectToRTurretItm(RwTurretItem turr, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(5, 15, 0.1) + remapQualityToRange(quality, 1, 10);
    }
    override void onBeingUsed(Actor owner, Inventory affixedItem) {
        let plr = RwPlayer(owner);
        if (plr && plr.currentEquippedArmor) {
            plr.currentEquippedArmor.repairFor(math.GetIntPercentage(plr.currentEquippedArmor.stats.maxDurability, modifierLevel));
        }
    }
}
