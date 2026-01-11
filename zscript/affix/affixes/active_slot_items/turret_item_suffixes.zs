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

class TurrSuffVampiric : RwTurretItemSuffix {
    override string getName() {
        return "Vampire";
    }
    override int getAlignment() {
        return 1;
    }
    override string getDescription() {
        return String.format("Regains %d%% health on kill", (modifierLevel) );
    }
    override void initAndapplyEffectToRTurretItm(RwTurretItem turr, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, 5, 0.1) + remapQualityToRange(quality, 1, 5);
    }
    override void onModifyDamage(int damage, out int newdamage, bool passive, Actor inflictor, Actor source, Actor owner, int flags) {
        if (!(owner is 'BaseRwTurretActor')) return; // Applied only for turrets
        if (!passive && source && source != owner) {
            if (source.health <= damage) {
                owner.GiveBody(math.getIntPercentage(owner.StartHealth, modifierLevel));
            }
        }
    }
}


class TurrSuffProlonged : RwTurretItemSuffix {
    override string getName() {
        return "Feed";
    }
    override int getAlignment() {
        return 1;
    }
    override string getDescription() {
        return String.format("+%d seconds of lifetime on kill", (modifierLevel) );
    }
    override void initAndapplyEffectToRTurretItm(RwTurretItem turr, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, 5, 0.1) + remapQualityToRange(quality, 0, 5);
    }
    override void onModifyDamage(int damage, out int newdamage, bool passive, Actor inflictor, Actor source, Actor owner, int flags) {
        if (!(owner is 'BaseRwTurretActor')) return; // Applied only for turrets
        if (!passive && source && source != owner) {
            if (source.health <= damage)
                BaseRwTurretActor(owner).lifetimeTics += modifierLevel * TICRATE;
        }
    }
}

class TurrSuffHealPlayerOnKill : RwTurretItemSuffix {
    override string getName() {
        return "Lifelink";
    }
    override int getAlignment() {
        return 1;
    }
    override string getDescription() {
        return String.format("Heals you %.1f HP on kill", (float(modifierLevel)/10) );
    }
    override void initAndapplyEffectToRTurretItm(RwTurretItem turr, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(5, 25, 0.1) + remapQualityToRange(quality, 0, 10);
    }
    int fractionAccumulator;
    override void onModifyDamage(int damage, out int newdamage, bool passive, Actor inflictor, Actor source, Actor owner, int flags) {
        if (!(owner is 'BaseRwTurretActor')) return; // Applied only for turrets
        if (!passive && source && source != owner) {
            if (source.health <= damage)
                BaseRwTurretActor(owner).Creator.GiveBody(
                    math.AccumulatedFixedPointAdd(0, modifierLevel, 10, fractionAccumulator)
                );
        }
    }
}
