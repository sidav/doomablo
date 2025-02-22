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

class FSuffDamagesOnUse : RwFlaskSuffix {
    override string getName() {
        return "Side Effects";
    }
    override string getDescription() {
        return "Deals "..modifierLevel.." DMG on use (won't kill)";
    }
    override int getAlignment() {
        return -1;
    }
    override void initAndapplyEffectToRFlask(RWFlask fsk, int quality) {
        modifierLevel = rnd.multipliedWeightedRandByEndWeight(1, 10, 10.0) + remapQualityToRange(quality, 0, 10);
    }
    override void onBeingUsed(Actor owner, Inventory affixedItem) {
        let damageAmount = min(owner.Health - 1, modifierLevel);
        if (damageAmount > 0) {
            owner.damageMobj(affixedItem, null, damageAmount, 'Normal', DMG_NO_ARMOR);
        }
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
        owner.GiveBody(modifierLevel);
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

class FSuffWeakSummoning : RwFlaskSuffix {
    override string getName() {
        return "Summoning";
    }
    override string getDescription() {
        return "Summons "..stat2.." weak friendly minions of LVL "..modifierLevel;
    }
    override int getAlignment() {
        return 1;
    }
    override void initAndapplyEffectToRFlask(RWFlask fsk, int quality) {
        modifierLevel = max(1, quality + rnd.multipliedWeightedRandByEndWeight(-5, 2, 0.3));
        modifierLevel = min(100, modifierLevel);
        stat2 = rnd.multipliedWeightedRandByEndWeight(2, 4, 0.35);
    }
    override void onBeingUsed(Actor owner, Inventory affixedItem) {
        for (let i = 0; i < stat2; i++) {
            class<Actor> minion;
            int choice = Random(0, 2);
            switch(choice) {
                case 0: minion = 'Zombieman'; break;
                case 1: minion = 'DoomImp'; break;
                case 2: minion = 'ShotgunGuy'; break;
            }
            let newMo = owner.Spawn(minion, owner.Pos, ALLOW_REPLACE);
            if (!LevelHelper.TryMoveActorToRandomCoordsInRangeFrom(newMo, owner.radius * 2, 5 * owner.radius, owner.Pos)) {
                newMo.destroy();
                return;
            }
            newMo.A_ClearTarget();
            newMo.bFriendly = true;
            newMo.SetFriendPlayer(RwPlayer(owner).Player);
            newMo.A_SpawnItemEx('TeleportFog');
            RwMonsterAffixator.AffixateMonster(newMo, 0, modifierLevel);
            newMo.A_ChangeCountFlags(false, FLAG_NO_CHANGE, FLAG_NO_CHANGE); // Don't count as kill, don't drop loot
        }
    }
}

class FSuffStrongSummoning : RwFlaskSuffix {
    override string getName() {
        return "Demonology";
    }
    override string getDescription() {
        return "Summons stronger friendly minion of LVL "..modifierLevel.." on use";
    }
    override int getAlignment() {
        return 1;
    }
    override void initAndapplyEffectToRFlask(RWFlask fsk, int quality) {
        modifierLevel = max(1, quality + rnd.multipliedWeightedRandByEndWeight(-2, 5, 0.2));
        modifierLevel = min(100, modifierLevel);
    }
    override void onBeingUsed(Actor owner, Inventory affixedItem) {
        class<Actor> minion;
        int choice = Random(0, 3);
        switch(choice) {
            case 0: minion = 'ShotgunGuy'; break;
            case 1: minion = 'ChaingunGuy'; break;
            case 2: minion = 'Demon'; break;
            case 3: minion = 'LostSoul'; break;
        }
        let newMo = owner.Spawn(minion, owner.Pos, ALLOW_REPLACE);
        if (!LevelHelper.TryMoveActorToRandomCoordsInRangeFrom(newMo, owner.radius * 2, 5 * owner.radius, owner.Pos)) {
            newMo.destroy();
            return;
        }
        newMo.A_ClearTarget();
        newMo.bFriendly = true;
        newMo.SetFriendPlayer(RwPlayer(owner).Player);
        newMo.A_SpawnItemEx('TeleportFog');
        RwMonsterAffixator.AffixateMonster(newMo, 0, modifierLevel);
        newMo.A_ChangeCountFlags(false, FLAG_NO_CHANGE, FLAG_NO_CHANGE); // Don't count as kill, don't drop loot
    }
}
