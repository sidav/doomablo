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

class TurrSuffAggroesMonsters : RwTurretItemSuffix {
    override string getName() {
        return "Hatred";
    }
    override int getAlignment() {
        return 0;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'TurrSuffMonstersWontAttackTurret';
    }
    override string getDescription() {
        return String.format("Enemies prefer attacking the turret", (modifierLevel) );
    }
    override void initAndapplyEffectToRTurretItm(RwTurretItem turr, int quality) {}
    
    override void onDoEffect(Actor turret) {
        if (!(turret is 'BaseRwTurretActor')) return; // Applied only for turrets

        if (turret.GetAge() % TICRATE == 0) {
            // Iterate through all monsters
            let ti = ThinkerIterator.Create('Actor');
            Actor mo;
            while (mo = Actor(ti.next())) {
                if (mo && mo.bIsMonster && mo.Health > 0 && BaseRwTurretActor(mo.target) == null && mo.CheckSight(turret, SF_IGNOREWATERBOUNDARY)) {
                    mo.target = turret;
                    // Rotation 3 times 45 degrees each
                    for (let i = 0; i < 3; i++) {
                        mo.A_Chase();
                    }
                }
            }
        }
    }
}

class TurrSuffMonstersWontAttackTurret : RwTurretItemSuffix {
    override string getName() {
        return "Misperception";
    }
    override int getAlignment() {
        return 0;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'TurrSuffAggroesMonsters';
    }
    override string getDescription() {
        return String.format("The turret aggroes monsters on you", (modifierLevel) );
    }
    override void initAndapplyEffectToRTurretItm(RwTurretItem turr, int quality) {}

    override void onDoEffect(Actor turret) {
        if (!(turret is 'BaseRwTurretActor')) return; // Applied only for turrets

        if (turret.GetAge() % TICRATE == 0) {
            let turretOwner = BaseRwTurretActor(turret).Creator;
            if (turretOwner == null) return;

            // Iterate through all monsters
            let ti = ThinkerIterator.Create('Actor');
            Actor mo;
            while (mo = Actor(ti.next())) {
                if (mo && mo.bIsMonster && mo.Health > 0 && mo.target == turret && mo.CheckSight(turretOwner, SF_IGNOREWATERBOUNDARY)) {
                    mo.target = turretOwner;
                }
            }
        }
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
        return String.format("+%.1f seconds of lifetime on kill", (gametime.ticksToSeconds(modifierLevel)) );
    }
    override void initAndapplyEffectToRTurretItm(RwTurretItem turr, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(TICRATE/2, TICRATE*2, 0.1) + remapQualityToRange(quality, 0, TICRATE);
    }
    override void onModifyDamage(int damage, out int newdamage, bool passive, Actor inflictor, Actor source, Actor owner, int flags) {
        if (!(owner is 'BaseRwTurretActor')) return; // Applied only for turrets
        if (!passive && source && source != owner) {
            if (source.health <= damage)
                BaseRwTurretActor(owner).lifetimeTics += modifierLevel;
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
