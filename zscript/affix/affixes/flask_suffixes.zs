class RwFlaskSuffix : Affix {
    override void InitAndApplyEffectToItem(Inventory item, int quality) {
        initAndapplyEffectToRFlask(RWFlask(item), quality);
    }
    protected virtual void initAndapplyEffectToRFlask(RWFlask fsk, int quality) {
        debug.panicUnimplemented(self);
    }
    override bool IsCompatibleWithItem(Inventory item) {
        return (RWFlask(item) != null);
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
    override bool isCompatibleWithAffClass(Affix a2) {
        return !(a2 is 'RwFlaskSuffix'); // There may be only one suffix on an item
    }
}

class FSuffPainfulHeal : RwFlaskSuffix {
    override string getName() {
        return "Pain";
    }
    override string getDescription() {
        return "Healing is painful for "..modifierLevel.." seconds";
    }
    override int getAlignment() {
        return -1;
    }
    override void initAndapplyEffectToRFlask(RWFlask fsk, int quality) {
        modifierLevel = Random(2, 6) + remapQualityToRange(quality, 0, 4);
    }
    override void onBeingUsed(Actor owner, Inventory affixedItem) {
        owner.GiveInventory('RWPainToken', modifierLevel);
    }
}

class FSuffVulnerableHeal : RwFlaskSuffix {
    override string getName() {
        return "Fragility";
    }
    override string getDescription() {
        return "Makes you vulnerable for "..modifierLevel.." s";
    }
    override int getAlignment() {
        return -1;
    }
    override void initAndapplyEffectToRFlask(RWFlask fsk, int quality) {
        modifierLevel = Random(2, 6) + remapQualityToRange(quality, 0, 4);
    }
    override void onBeingUsed(Actor owner, Inventory affixedItem) {
        owner.GiveInventory('RWVulnerabilityToken', modifierLevel);
    }
}

class FSuffInstantHeal : RwFlaskSuffix {
    override string getName() {
        return "Emergency";
    }
    override string getDescription() {
        return "Instantly heals "..modifierLevel.." HP on use";
    }
    override int getAlignment() {
        return 1;
    }
    override void initAndapplyEffectToRFlask(RWFlask fsk, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(5, 15, 0.1) + remapQualityToRange(quality, 1, 10);
    }
    override void onBeingUsed(Actor owner, Inventory affixedItem) {
        owner.GiveBody(modifierLevel, owner.GetMaxHealth());
    }
}

class FSuffProtection : RwFlaskSuffix {
    override string getName() {
        return "Protection";
    }
    override string getDescription() {
        return "Also applies "..modifierLevel.."% protection for "..stat2.." s";
    }
    override int getAlignment() {
        return 1;
    }
    override void initAndapplyEffectToRFlask(RWFlask fsk, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(5, 35, 0.1) + remapQualityToRange(quality, 0, 15);
        stat2 = rnd.multipliedWeightedRandByEndWeight(3, 10, 0.1);
    }
    override void onBeingUsed(Actor owner, Inventory affixedItem) {
        RWProtectedToken.ApplyToActor(owner, modifierLevel, stat2);
    }
}

class FSuffExperienceBonus : RwFlaskSuffix {
    override string getName() {
        return "Learning";
    }
    override string getDescription() {
        return "Also applies "..modifierLevel.."% exp bonus for "..stat2.." s";
    }
    override int getAlignment() {
        return 1;
    }
    override void initAndapplyEffectToRFlask(RWFlask fsk, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(5, 25, 0.1) + remapQualityToRange(quality, 0, 25);
        stat2 = rnd.multipliedWeightedRandByEndWeight(3, 10, 0.1);
    }
    override void onBeingUsed(Actor owner, Inventory affixedItem) {
        RWExperienceBonusToken.ApplyToActor(owner, modifierLevel, stat2);
    }
}

class FSuffCleanse : RwFlaskSuffix {
    override string getName() {
        return "Cleansing";
    }
    override string getDescription() {
        return "Removes up to "..modifierLevel.." bad status effects on use";
    }
    override int getAlignment() {
        return 1;
    }
    override void initAndapplyEffectToRFlask(RWFlask fsk, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, 3, 0.1);
    }
    override void onBeingUsed(Actor owner, Inventory affixedItem) {
        int cleansed = 0;
        let invlist = owner.inv;
        while(invlist != null) {
            if (invlist != null && invlist is 'RwStatusEffectToken') {
                let se = RwStatusEffectToken(invlist);
                if (se.GetAlignment() == -1) {
                    se.Amount = 0;
                    cleansed++;
                }
                if (cleansed >= modifierLevel) break;
            }
            invlist=invlist.Inv;
        };
    }
}

class FSuffRepairsArmor : RwFlaskSuffix {
    override string getName() {
        return "the Knight";
    }
    override string getDescription() {
        return "Repairs "..modifierLevel.."% of armor DRB on use";
    }
    override int getAlignment() {
        return 1;
    }
    override void initAndapplyEffectToRFlask(RWFlask fsk, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(5, 25, 0.1) + quality/10;
    }
    override void onBeingUsed(Actor owner, Inventory affixedItem) {
        let plr = RwPlayer(owner);
        if (plr && plr.currentEquippedArmor) {
            plr.currentEquippedArmor.repairFor(math.GetIntPercentage(plr.currentEquippedArmor.stats.maxDurability, modifierLevel));
        }
    }
}

class FSuffGivesAmmo : RwFlaskSuffix {
    override string getName() {
        return "Abundance";
    }
    override string getDescription() {
        return "Refills "..modifierLevel.."% of random ammo on use";
    }
    override int getAlignment() {
        return 1;
    }
    override void initAndapplyEffectToRFlask(RWFlask fsk, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, 10, 0.1) + quality/20;
    }
    override void onBeingUsed(Actor owner, Inventory affixedItem) {
        let plr = RwPlayer(owner);
        if (plr) {
            let ammoType = Random(0, 3);
            switch (ammoType) {
                case 0:
                    plr.GetAmmoByCapPercentage('Clip', modifierLevel);
                    break;
                case 1:
                    plr.GetAmmoByCapPercentage('Shell', modifierLevel);
                    break;
                case 2:
                    plr.GetAmmoByCapPercentage('Rocketammo', modifierLevel);
                    break;
                case 3:
                    plr.GetAmmoByCapPercentage('Cell', modifierLevel);
                    break;
            }
        }
    }
}
