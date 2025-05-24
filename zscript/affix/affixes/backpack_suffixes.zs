class RwBackpackSuffix : Affix {
    override void InitAndApplyEffectToItem(Inventory item, int quality) {
        initAndapplyEffectToRBackpack(RWBackpack(item), quality);
    }
    protected virtual void initAndapplyEffectToRBackpack(RWBackpack bpk, int quality) {
        debug.panicUnimplemented(self);
    }
    override bool IsCompatibleWithItem(Inventory item) {
        return (RWBackpack(item) != null);
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

class BSuffNoisy : RwBackpackSuffix {
    override string getName() {
        return "Noise";
    }
    override string getDescription() {
        return "Has a "..modifierLevel.."% chance to aggro monsters around you";
    }
    override int getAlignment() {
        return -1;
    }
    override void initAndapplyEffectToRBackpack(RWBackpack bkpk, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, 100); // Chance 1-100
    }
    override void onDoEffect(Actor owner, Inventory affixedItem) {
        if (affixedItem.GetAge() % (TICRATE * 5) == 0 && rnd.PercentChance(modifierLevel)) {
            // Iterate through all monsters
            let ti = ThinkerIterator.Create('Actor');
            Actor mo;
            while (mo = Actor(ti.next())) {
                if (mo && mo.bIsMonster && mo.target == null && mo.CheckSight(owner, SF_IGNOREWATERBOUNDARY)) {
                    mo.target = owner;
                    // Rotation 3 times 45 degrees each
                    for (let i = 0; i < 3; i++) {
                        mo.A_Chase();
                    }
                }
            }
        }
    }
}

class BSuffLessAmmoChance : RwBackpackSuffix {
    override string getName() {
        return "Holes";
    }
    override string getDescription() {
        return "Ammo pickups have "..modifierLevel.."% chance to have less ammo";
    }
    override int getAlignment() {
        return -1;
    }
    override void initAndapplyEffectToRBackpack(RWBackpack bkpk, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, 25) + 5;
    }
    override void onHandlePickup(Inventory pickedUp) {
        if (pickedUp is 'Ammo' && rnd.PercentChance(modifierLevel)) {
            if (pickedUp.Amount > 2) {
                pickedUp.amount = Random(pickedUp.amount/2, pickedUp.amount);
            }
        }
    }
}

class BSuffRestoreCells : RwBackpackSuffix {
    override string getName() {
        return "RITEG";
    }
    override string getDescription() {
        return String.Format("Gives %.2f energy cells per second", (double(modifierLevel) * TICRATE / 1000 ));
    }
    override void initAndapplyEffectToRBackpack(RWBackpack bkpk, int quality) {
        // ModifierLevel is "ammo per tick * 1000"
        modifierLevel = (rnd.multipliedWeightedRandByEndWeight(75, 1000, 0.05) + modifierLevel*2 + TICRATE/2) / TICRATE;
    }
    int fractionAccumulator;
    override void onDoEffect(Actor owner, Inventory affixedItem) {
        let addAmount = math.AccumulatedFixedPointAdd(0, modifierLevel, 1000, fractionAccumulator);
        if (addAmount > 0) {
            owner.GiveInventory('Cell', 1);
        }
    }
}

class BSuffRestoreBullets : RwBackpackSuffix {
    override string getName() {
        return "Nanoassembler";
    }
    override string getDescription() {
        return String.Format("Gives %.2f bullets per second", (double(modifierLevel) * TICRATE / 1000 ));
    }
    override void initAndapplyEffectToRBackpack(RWBackpack bkpk, int quality) {
        // ModifierLevel is "ammo per tick * 1000"
        modifierLevel = (rnd.multipliedWeightedRandByEndWeight(75, 1000, 0.05) + modifierLevel*2 + TICRATE/2) / TICRATE;
    }
    int fractionAccumulator;
    override void onDoEffect(Actor owner, Inventory affixedItem) {
        let addAmount = math.AccumulatedFixedPointAdd(0, modifierLevel, 1000, fractionAccumulator);
        if (addAmount > 0) {
            owner.GiveInventory('Clip', 1);
        }
    }
}

class BSuffAutoreload : RwBackpackSuffix {
    override string getName() {
        return "Auto-reload";
    }
    override string getDescription() {
        return "Each "
            ..
            String.Format("%.1f", (Gametime.TicksToSeconds(modifierLevel)))
            .." seconds reloads your weapons";
    }
    override void initAndapplyEffectToRBackpack(RWBackpack bkpk, int quality) {
        let seconds = Random(5, 10);
        modifierLevel = gametime.secondsToTicks(seconds);
    }
    override void onDoEffect(Actor owner, Inventory affixedItem) {
        if (affixedItem.GetAge() % modifierLevel == 0) {
            bool atLeastOneReloaded = false;
            // Iterate through all weapons
            let invlist = owner.Inv;
            while(invlist != null) {
                let toReload = RandomizedWeapon(invlist);
                if (toReload && owner.Player.ReadyWeapon != invlist && toReload.ammotype1 != null) {
                    let clipBefore = toReload.currentClipAmmo;
                    toReload.A_MagazineReload();
                    atLeastOneReloaded = atLeastOneReloaded || (toReload.currentClipAmmo > clipBefore);
                }
                invlist=invlist.Inv;
            }
            if (atLeastOneReloaded) {
                owner.A_StartSound("misc/w_pkup"); // plays Doom's "weapon pickup" sound
            }
        }
    }
}

class BSuffBetterMedikits : RwBackpackSuffix {
    override string getName() {
        return "Surgeon";
    }
    override string getDescription() {
        return "+"..modifierLevel.." to each non-bonus health pickup";
    }
    override void initAndapplyEffectToRBackpack(RWBackpack bkpk, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, 5, 0.05) + remapQualityToRange(quality, 0, 2);
    }
    override void onDoEffect(Actor owner, Inventory affixedItem) {
        // Caution here: this affix-caused healing may chain-trigger itself on next tick.
        // To prevent that the min allowed lastHealedBy should be bigger than the max affix heal amount.
        if (RwPlayer(owner).lastHealedBy >= 10 && RwPlayer(owner).lastHealedBy > modifierLevel) {
            owner.GiveBody(modifierLevel);
        }
    }
}

class BSuffBetterArmorRepair : RwBackpackSuffix {
    override string getName() {
        return "Repair kit";
    }
    override string getDescription() {
        return String.Format("%d%% chance to repair more armor DRB", (modifierLevel));
    }
    override void initAndapplyEffectToRBackpack(RWBackpack bkpk, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, 50, 0.05) + remapQualityToRange(quality, 0, 10);
    }

    int previousTickDRB;
    override void onDoEffect(Actor owner, Inventory affixedItem) {
        let plr = RwPlayer(owner);
        let arm = plr.CurrentEquippedArmor;
        if (arm && !arm.stats.IsEnergyArmor()) {
            let DurabDiff = arm.stats.currDurability - previousTickDRB;
            if (DurabDiff > 0 && rnd.PercentChance(modifierLevel)) {
                arm.RepairFor(Random(1, max(DurabDiff, 1)));
            }
            previousTickDRB = arm.stats.currDurability;
        }
    }
}

class BSuffMoreAmmoChance : RwBackpackSuffix {
    override string getName() {
        return "Optimization";
    }
    override string getDescription() {
        return "Ammo pickups have "..modifierLevel.."% chance to have more ammo";
    }
    override void initAndapplyEffectToRBackpack(RWBackpack bkpk, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, 40, 0.05) + remapQualityToRange(quality, 0, 10);
    }
    override void onHandlePickup(Inventory pickedUp) {
        if (pickedUp is 'Ammo' && rnd.PercentChance(modifierLevel)) {
            if (pickedUp.Amount < 3) {
                pickedUp.amount = Random(pickedUp.amount, 2*pickedUp.amount);
            } else {
                pickedUp.amount = Random(pickedUp.amount, 3*pickedUp.amount/2);
            }
        }
    }
}

class BSuffBetterEarmorDelay : RwBackpackSuffix {
    override string getName() {
        return "Circuitry";
    }
    override string getDescription() {
        return String.Format("Energy armor recharge delay -%d%%", (modifierLevel));
    }
    override void initAndapplyEffectToRBackpack(RWBackpack bkpk, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, 40, 0.05) + remapQualityToRange(quality, 0, 10);
    }
    override void onDoEffect(Actor owner, Inventory affixedItem) {
        let plr = RwPlayer(owner);
        let arm = plr.CurrentEquippedArmor;
        if (arm && arm.stats.IsEnergyArmor()) {
            // Call only some ticks after the damage to prevent bugs with "next-tick-expecting" affixes (such as ASuffECellsSpend)
            if (arm.ticksSinceDamage() == 3) {
                let diffTicks = math.getIntPercentage(arm.stats.delayUntilRecharge, modifierLevel);
                arm.lastDamageTick -= diffTicks;
            }
        }
    }
}
