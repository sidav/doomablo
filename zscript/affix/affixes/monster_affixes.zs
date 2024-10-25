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

// On put into inventory

class MAffMoreHealth : RwMonsterAffix { // It WILL synergize with the affixator-given health.
    override string getName() {
        return "Unyelding";
    }
    override string getDescription() {
        return "HLTH +"..(modifierLevel-100).."%";
    }
    override void initAndApplyEffectToRwMonsterAffixator(RwMonsterAffixator affixator, int quality) {
        modifierLevel = remapQualityToRange(quality, 125, 500);
    }
    override void onPutIntoMonsterInventory(Actor owner) {
        owner.starthealth = math.getIntPercentage(owner.health, modifierLevel);
        owner.A_SetHealth(owner.starthealth);
    }
}

// On damage BY owner

class MAffKnockback : RwMonsterAffix {
    override string getName() {
        return "Kicking";
    }
    override string getDescription() {
        return "KNBCK "..modifierLevel;
    }
    override void initAndApplyEffectToRwMonsterAffixator(RwMonsterAffixator affixator, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, 20);
    }
    override void onModifyDamage(int damage, out int newdamage, bool passive, Actor inflictor, Actor source, Actor owner, int flags) {
        if (!passive && source && source != owner) {
            let angle = owner.angle;
            if (inflictor && !(flags & DMG_INFLICTOR_IS_PUFF)) {
                angle = inflictor.angle;
            }
            source.Thrust(double(modifierLevel), angle);
            // debug.panic("SOURCE IS "..source.GetClassName().." inflictor is "..inflictor.GetClassName().." angle is "..inflictor.angle.." INF IS PUFF ="..(flags & DMG_INFLICTOR_IS_PUFF));
        }
    }
}

class MAffHigherDamage : RwMonsterAffix {
    override string getName() {
        return "Strong";
    }
    override string getDescription() {
        return "DMG +"..modifierLevel.."%";
    }
    override void initAndApplyEffectToRwMonsterAffixator(RwMonsterAffixator affixator, int quality) {
        modifierLevel = remapQualityToRange(quality, 25, 200);
    }
    override void onModifyDamage(int damage, out int newdamage, bool passive, Actor inflictor, Actor source, Actor owner, int flags) {
        if (!passive) {
            newdamage = math.getIntPercentage(damage, 100+modifierLevel);
        }
    }
}

class MAffVampiric : RwMonsterAffix {
    override string getName() {
        return "Blood-feeding";
    }
    override string getDescription() {
        return "Vamp "..modifierLevel;
    }
    override void initAndApplyEffectToRwMonsterAffixator(RwMonsterAffixator affixator, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, 50);
    }
    override void onModifyDamage(int damage, out int newdamage, bool passive, Actor inflictor, Actor source, Actor owner, int flags) {
        if (!passive) {
            // debug.print("VAMPIRIC Source is "..source.GetClassName().." and owner is "..owner.GetClassName());
            owner.GiveBody(modifierLevel, owner.GetMaxHealth());
        }
    }
}

// On damage TO owner

class MAffThorns : RwMonsterAffix {
    override string getName() {
        return "Untouchable";
    }
    override string getDescription() {
        return "Thorns "..modifierLevel;
    }
    override void initAndApplyEffectToRwMonsterAffixator(RwMonsterAffixator affixator, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, 5);
    }
    override void onModifyDamage(int damage, out int newdamage, bool passive, Actor inflictor, Actor source, Actor owner, int flags) {
        if (passive && source && source != owner && !occuredThisTick()) {
            source.damageMobj(null, null, modifierLevel, 'Normal');
            updateLastEffectTick();
        }
    }
}

class MAffArmored : RwMonsterAffix {
    override string getName() {
        return "Fat-skinned";
    }
    override string getDescription() {
        return "ARMR "..modifierLevel;
    }
    override void initAndApplyEffectToRwMonsterAffixator(RwMonsterAffixator affixator, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, 10);
    }
    override void onModifyDamage(int damage, out int newdamage, bool passive, Actor inflictor, Actor source, Actor owner, int flags) {
        if (passive && source && source != owner) {
            newdamage = max(damage-modifierLevel, 1);
        }
    }
}

class MAffFastOnBeingDamaged : RwMonsterAffix { // Monster becomes fast and feels no pain for modifierLevel ticks when damaged.
    override string getName() {
        return "Raging";
    }
    override string getDescription() {
        return String.Format("RAGE %.1f", gametime.ticksToSeconds(modifierLevel));
    }
    override void initAndApplyEffectToRwMonsterAffixator(RwMonsterAffixator affixator, int quality) {
        modifierLevel = remapQualityToTicksFromSecondsRange(quality, 3, 15);
    }

    override void onModifyDamage(int damage, out int newdamage, bool passive, Actor inflictor, Actor source, Actor owner, int flags) {
        if (passive && source && source != owner && !occuredThisTick()) {
            owner.bALWAYSFAST = true;
            updateLastEffectTick();
        }
    }

    override void onDoEffect(Actor owner) {
        if (owner.bALWAYSFAST && occuredMoreThanTicksAgo(modifierLevel)) {
            owner.bALWAYSFAST = false;
            updateLastEffectTick();
        }
    }
}

class MAffIncreaseDamageEachDealt : RwMonsterAffix { // Each time monster is damaged its damage is increased.
    override string getName() {
        return "Angrying";
    }
    override string getDescription() {
        return "ANGER";
    }
    override void initAndApplyEffectToRwMonsterAffixator(RwMonsterAffixator affixator, int quality) {
        modifierLevel = 0;
    }
    override void onModifyDamage(int damage, out int newdamage, bool passive, Actor inflictor, Actor source, Actor owner, int flags) {
        if (passive) {
            modifierLevel++;
        } else {
            newdamage += modifierLevel;
        }
    }
}

// Each tick

class MAffMagnet : RwMonsterAffix {
    override string getName() {
        return "Magnetic";
    }
    override string getDescription() {
        return "Magnet "..modifierLevel;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'MAffRepulsive';
    }
    override void initAndApplyEffectToRwMonsterAffixator(RwMonsterAffixator affixator, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, 50);
    }
    override void onDoEffect(Actor owner) {
        if (owner.target && owner.CheckSight(owner.target, SF_IGNOREWATERBOUNDARY)) {
            let pullAngle = owner.target.AngleTo(owner);
            owner.target.Thrust(double(modifierLevel+40)/500, pullAngle);
        }
    }
}

class MAffRepulsive : RwMonsterAffix {
    override string getName() {
        return "Repulsive";
    }
    override string getDescription() {
        return "Fear "..modifierLevel;
    }
    override bool isCompatibleWithAffClass(Affix a2) {
        return a2.GetClass() != 'MAffMagnet';
    }
    override void initAndApplyEffectToRwMonsterAffixator(RwMonsterAffixator affixator, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, 50);
    }
    override void onDoEffect(Actor owner) {
        if (owner.target && owner.CheckSight(owner.target, SF_IGNOREWATERBOUNDARY)) {
            let pullAngle = owner.target.AngleTo(owner);
            owner.target.Thrust(-double(modifierLevel+50)/400, pullAngle);
        }
    }
}

class MAffRegen : RwMonsterAffix {
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
        if (owner.GetAge() % (TICRATE/2) == 0) {
            owner.GiveBody(modifierLevel);
        }
    }
}

class MAffCorrosion : RwMonsterAffix {
    override string getName() {
        return "Corrosive";
    }
    override string getDescription() {
        return String.Format("CORR %.1f", 1/Gametime.TicksToSeconds(modifierLevel));
    }
    override void initAndApplyEffectToRwMonsterAffixator(RwMonsterAffixator affixator, int quality) {
        modifierLevel = remapQualityToTicksFromSecondsRange(quality, 2, 0.1);
    }
    override void onDoEffect(Actor owner) {
        if (owner.GetAge() % modifierLevel == 0) {
            let pTarget = RwPlayer(owner.target);
            if (pTarget && owner.CheckSight(pTarget, SF_IGNOREWATERBOUNDARY) && pTarget.CurrentEquippedArmor) {
                if (pTarget.CurrentEquippedArmor.stats.currDurability > 0) {
                    pTarget.CurrentEquippedArmor.stats.currDurability -= rnd.rand(1, 3);
                    pTarget.CurrentEquippedArmor.stats.currDurability = max(pTarget.CurrentEquippedArmor.stats.currDurability, 0);
                }
            }
        }
    }
}

// On owner died

class MAffSpawnHordeOnDeath : RwMonsterAffix {
    override string getName() {
        return "Engorged";
    }
    override string getDescription() {
        return "Horde "..modifierLevel;
    }
    override void initAndApplyEffectToRwMonsterAffixator(RwMonsterAffixator affixator, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, 10);
    }
    mixin DropSpreadable;
    override void onOwnerDied(Actor owner) {
        // debug.print("Spawning!");
        if (owner) {
            owner.A_SpawnItemEx('TeleportFog');
            for (let i = 0; i < modifierLevel; i++) {
                // debug.print("    Spawning "..i);
                let newMo = owner.Spawn(owner.GetClass(), owner.Pos);
                newMo.bNOINFIGHTING = true;
                newMo.bNOTARGET = true;
                AssignMajorSpreadVelocityTo(newMo);
            }
        }
    }
}

// Disabled because of bugs

// class MAffHealsOnDeath : RwMonsterAffix {
//     override string getName() {
//         return "Undying";
//     }
//     override string getDescription() {
//         return "Undying "..modifierLevel;
//     }
//     override void initAndApplyEffectToRwMonsterAffixator(RwMonsterAffixator affixator, int quality) {
//         modifierLevel = remapQualityToRange(quality, 1, 5);
//     }
//     mixin DropSpreadable;
//     override void onOwnerDied(Actor owner) {
//         // debug.print("Spawning!");
//         if (owner && modifierLevel > 0) {
//             owner.health = owner.GetMaxHealth();
//             owner.A_SpawnItemEx('TeleportFog');
//             // Required when resurrecting
//             owner.bCORPSE = false;
//             owner.bSHOOTABLE = true;
//             owner.bSOLID = true;
//             owner.bCANPUSHWALLS = true;
//             owner.bCANUSEWALLS = true;
//             owner.bACTIVATEMCROSS = true;
//             owner.bCANPASS = true;
//             owner.bISMONSTER = true;

//             modifierLevel--;
//             AssignMajorSpreadVelocityTo(owner);
//         }
//     }
// }
