// There is NO "one suffix" restriction for monsters, so monster prefixes and suffixes are just one class
class RwMonsterAffix : Affix {
    override void InitAndApplyEffectToItem(Inventory item, int quality) {
        initAndApplyEffectToRwMonsterAffixator(RwMonsterAffixator(item), quality);
    }
    protected virtual void initAndApplyEffectToRwMonsterAffixator(RwMonsterAffixator affixator, int quality) {
        debug.panicUnimplemented(self);
    }
    override int getAlignment() {
        return 0;
    }
    override string getDescription() {
        return "";
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return true;
    }
    override bool IsCompatibleWithItem(Inventory item) {
        return (RwMonsterAffixator(item) != null);
    }
}

class MPrefMoreHealth : RwMonsterAffix {
    override string getName() {
        return "Unholy";
    }
    override void initAndApplyEffectToRwMonsterAffixator(RwMonsterAffixator affixator, int quality) {
        modifierLevel = remapQualityToRange(quality, 125, 500);
    }
    override void onPutIntoMonsterInventory(Actor owner) {
        owner.starthealth = math.getIntPercentage(owner.health, modifierLevel);
        owner.A_SetHealth(owner.starthealth);
    }
}

// Yes, allow it to synergize with affix above
class MPrefMoreHealth2 : MPrefMoreHealth {
    override string getName() {
        return "Unyelding";
    }
}

class MPrefHigherDamage : RwMonsterAffix {
    override string getName() {
        return "Strong";
    }
    override string getDescription() {
        return "DMG +"..modifierLevel.."%";
    }
    override void initAndApplyEffectToRwMonsterAffixator(RwMonsterAffixator affixator, int quality) {
        modifierLevel = remapQualityToRange(quality, 25, 200);
    }
    override void onModifyDamageDealtByOwner(int damage, Name damageType, out int newdamage, Actor inflictor, Actor source, Actor owner, int flags) {
        newdamage = math.getIntPercentage(damage, 100+modifierLevel);
    }
}

class MSuffRegen : RwMonsterAffix {
    override string getName() {
        return "Fear-feeding";
    }
    override string getDescription() {
        return "Regen "..modifierLevel;
    }
    override void initAndApplyEffectToRwMonsterAffixator(RwMonsterAffixator affixator, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, 10);
    }
    override void onDoEffect(Actor owner) {
        if (owner.GetAge() % TICRATE == 0) {
            owner.GiveBody(modifierLevel);
        }
    }
}

class MSuffThorns : RwMonsterAffix {
    override string getName() {
        return "Untouchable";
    }
    override string getDescription() {
        return "Thorns "..modifierLevel;
    }
    override void initAndApplyEffectToRwMonsterAffixator(RwMonsterAffixator affixator, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, 5);
    }
    override void onModifyDamageToOwner(int damage, Name damageType, out int newdamage, Actor inflictor, Actor source, Actor owner, int flags) {
        if (source) {
            source.damageMobj(null, null, modifierLevel, 'Normal');
        }
    }
}

class MSuffVampiric : RwMonsterAffix {
    override string getName() {
        return "Blood-feeding";
    }
    override string getDescription() {
        return "Vamp "..modifierLevel;
    }
    override void initAndApplyEffectToRwMonsterAffixator(RwMonsterAffixator affixator, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, 25);
    }
    override void onModifyDamageDealtByOwner(int damage, Name damageType, out int newdamage, Actor inflictor, Actor source, Actor owner, int flags) {
        // debug.print("VAMPIRIC Source is "..source.GetClassName().." and owner is "..owner.GetClassName());
        owner.GiveBody(modifierLevel, 1000);
    }
}

class MSuffIncreaseDamageEachDealt : RwMonsterAffix {
    override string getName() {
        return "Raging";
    }
    override string getDescription() {
        return "Rage";
    }
    override void initAndApplyEffectToRwMonsterAffixator(RwMonsterAffixator affixator, int quality) {
        modifierLevel = 0;
    }
    override void onModifyDamageToOwner(int damage, Name damageType, out int newdamage, Actor inflictor, Actor source, Actor owner, int flags) {
        modifierLevel++;
    }
    override void onModifyDamageDealtByOwner(int damage, Name damageType, out int newdamage, Actor inflictor, Actor source, Actor owner, int flags) {
        newdamage += modifierLevel;
    }
}

class MSuffMagnet : RwMonsterAffix {
    override string getName() {
        return "Devouring";
    }
    override string getDescription() {
        return "Magnet "..modifierLevel;
    }
    override void initAndApplyEffectToRwMonsterAffixator(RwMonsterAffixator affixator, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, 100);
    }
    override void onDoEffect(Actor owner) {
        if (owner.target && owner.CheckSight(owner.target, SF_IGNOREWATERBOUNDARY)) {
            let pullAngle = owner.target.AngleTo(owner);
            owner.target.Thrust(double(modifierLevel)/1000, pullAngle);
        }
    }
}

// class MSuffSpawnHordeOnDeath : RwMonsterAffix {
//     override string getName() {
//         return "Engorged";
//     }
//     override string getDescription() {
//         return "Horde "..modifierLevel;
//     }
//     override void initAndApplyEffectToRwMonsterAffixator(RwMonsterAffixator affixator, int quality) {
//         modifierLevel = remapQualityToRange(quality, 5, 25);
//     }
//     mixin DropSpreadable;
//     override void onModifyDamageToOwner(int damage, Name damageType, out int newdamage, Actor inflictor, Actor source, Actor owner, int flags) {
//         debug.print("Spawning!");
//         if (owner && owner.health <= damage) {
//             for (let i = 0; i < modifierLevel; i++) {
//                 debug.print("    Spawning "..i);
//                 let newMo = owner.Spawn(owner.GetClass(), owner.Pos);
//                 newMo.bNOINFIGHTING = true;
//                 AssignSpreadVelocityTo(newMo);
//             }
//         }
//     }
// }
