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

    // Monster-affix-specific method, that's why it's here
    virtual play void onOwnerDiedPreviousTick(Actor owner) {}
}

// On put into inventory

class MAffMoreHealth : RwMonsterAffix { // It WILL synergize with the affixator-given health.
    override string getName() {
        return "Unyelding";
    }
    override string getDescription() {
        return "HLTH +"..(modifierLevel-100).."%";
    }
    override int minRequiredRarity() {
        return 2;
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

class MAffInflictsPoison : RwMonsterAffix {
    override string getName() {
        return "Poisonous";
    }
    override string getDescription() {
        return "POIS "..modifierLevel;
    }
    override int minRequiredRarity() {
        return 2;
    }
    override void initAndApplyEffectToRwMonsterAffixator(RwMonsterAffixator affixator, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, 20);
        stat2 = quality;
    }
    override void onModifyDamage(int damage, out int newdamage, bool passive, Actor inflictor, Actor source, Actor owner, int flags) {
        if (!passive && source && source != owner) {
            RWPoisonToken.ApplyToActor(source, StatsScaler.ScaleIntValueByLevelRandomized(1, stat2), 10);
        }
    }
}

class MAffInflictsPain : RwMonsterAffix {
    override string getName() {
        return "Painful";
    }
    override string getDescription() {
        return "PAIN "..modifierLevel;
    }
    override int minRequiredRarity() {
        return 0;
    }
    override void initAndApplyEffectToRwMonsterAffixator(RwMonsterAffixator affixator, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, 85);
    }
    override void onModifyDamage(int damage, out int newdamage, bool passive, Actor inflictor, Actor source, Actor owner, int flags) {
        if (!passive && source && source != owner && rnd.percentChance(modifierLevel)) {
            source.GiveInventory('RWPainToken', modifierLevel);
        }
    }
}

class MAffInflictsCorrosion : RwMonsterAffix {
    override string getName() {
        return "Corrosive";
    }
    override string getDescription() {
        return String.Format("CORR %d", (modifierLevel));
    }
    override int minRequiredRarity() {
        return 2;
    }
    override void initAndApplyEffectToRwMonsterAffixator(RwMonsterAffixator affixator, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, 10);
    }
    override void onModifyDamage(int damage, out int newdamage, bool passive, Actor inflictor, Actor source, Actor owner, int flags) {
        if (!passive && source && source != owner) {
            source.GiveInventory('RWCorrosionToken', modifierLevel);
        }
    }
}

class MAffInflictsVulnerability : RwMonsterAffix {
    override string getName() {
        return "Foul";
    }
    override string getDescription() {
        return "VULN "..modifierLevel;
    }
    override int minRequiredRarity() {
        return 2;
    }
    override void initAndApplyEffectToRwMonsterAffixator(RwMonsterAffixator affixator, int quality) {
        modifierLevel = remapQualityToRange(quality, 5, 50);
    }
    override void onModifyDamage(int damage, out int newdamage, bool passive, Actor inflictor, Actor source, Actor owner, int flags) {
        if (!passive && source && source != owner && rnd.percentChance(modifierLevel)) {
            source.GiveInventory('RWVulnerabilityToken', 5);
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
    override int minRequiredRarity() {
        return 2;
    }
    override void initAndApplyEffectToRwMonsterAffixator(RwMonsterAffixator affixator, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, 5);
    }
    override void onModifyDamage(int damage, out int newdamage, bool passive, Actor inflictor, Actor source, Actor owner, int flags) {
        if (passive && source && source != owner && !occuredThisTick()) {
            source.damageMobj(null, null, Random(0, modifierLevel), 'Normal');
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
        if (passive && source && source != owner && !(flags & DMG_NO_ARMOR)) {
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
    override int minRequiredRarity() {
        return 2;
    }
    override void initAndApplyEffectToRwMonsterAffixator(RwMonsterAffixator affixator, int quality) {
        modifierLevel = remapQualityToTicksFromSecondsRange(quality, 3, 15);
    }

    override void onModifyDamage(int damage, out int newdamage, bool passive, Actor inflictor, Actor source, Actor owner, int flags) {
        if (passive && source && source != owner && !occuredThisTick()) {
            owner.bALWAYSFAST = true;
            owner.bALLOWPAIN = false;
            updateLastEffectTick();
        }
    }

    override void onDoEffect(Actor owner) {
        if (owner.bALWAYSFAST && occuredMoreThanTicksAgo(modifierLevel)) {
            owner.bALWAYSFAST = false;
            owner.bALLOWPAIN = true;
            updateLastEffectTick();
        }
    }
}

class MAffIncreaseDamageEachDealt : RwMonsterAffix { // Each time monster is damaged its damage is increased.
    override string getName() {
        return "Angrying";
    }
    override string getDescription() {
        if (modifierLevel == 0) {
            return "ANGER";
        }
        return "ANGER "..modifierLevel;
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
        if (
            owner.target && 
            (owner.Distance3DSquared(owner.target) < (owner.radius * 10) ** 2) && // pull only at some distance
            owner.CheckSight(owner.target, SF_IGNOREWATERBOUNDARY)
        ) {
            let pullAngle = owner.target.AngleTo(owner);
            owner.target.Thrust(double(modifierLevel+40)/600, pullAngle);
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
        if (
            owner.target && 
            (owner.Distance3DSquared(owner.target) < (owner.radius * 10) ** 2) && // pull only at some distance
            owner.CheckSight(owner.target, SF_IGNOREWATERBOUNDARY)
        ) {
            let pullAngle = owner.target.AngleTo(owner);
            owner.target.Thrust(-double(modifierLevel+50)/600, pullAngle);
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
        if (owner.GetAge() % (2*TICRATE/3) == 0) {
            owner.GiveBody(modifierLevel);
        }
    }
}

class MAffBlinking : RwMonsterAffix {
    override string getName() {
        return "Blinking";
    }
    override string getDescription() {
        return String.Format("BLNK %.1f", Gametime.ticksToSeconds(modifierLevel));
    }
    override void initAndApplyEffectToRwMonsterAffixator(RwMonsterAffixator affixator, int quality) {
        modifierLevel = remapQualityToTicksFromSecondsRange(quality, 15, 5);
    }
    override void onDoEffect(Actor owner) {
        if (owner && owner.target && (owner.GetAge() % modifierLevel == 0) && 
            (rnd.OneChanceFrom(30) || owner.CheckSight(owner.target, SF_IGNOREWATERBOUNDARY)) )
        {

            let target = owner.target;
            let originalPos = owner.Pos;
            if (LevelHelper.TryMoveActorToRandomCoordsInRangeFrom(owner, 3*target.radius, 10*owner.radius, target.Pos)) {
                let tfog = owner.Spawn('TeleportFog');
                tfog.SetOrigin(originalPos, false);
                owner.A_SpawnItemEx('TeleportFog');
            }
        }
    }
}

class MAffSummoner : RwMonsterAffix {
    override string getName() {
        return "Summoning";
    }
    override string getDescription() {
        return "SMMN "..modifierLevel;
    }
    override int minRequiredRarity() {
        return 3;
    }
    override void initAndApplyEffectToRwMonsterAffixator(RwMonsterAffixator affixator, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, 75);
    }
    const TRY_SUMMON_EACH = TICRATE;
    override void onDoEffect(Actor owner) {
        if (level.maptime % TRY_SUMMON_EACH == 0 && owner.target != null) {
            let maxChance = (100 - modifierLevel) + (owner.GetMaxHealth() / 5);
            if (!rnd.OneChanceFrom(maxChance)) {
                return;
            }
            // debug.print("    Spawning "..i);
            let newMo = owner.Spawn(owner.GetClass(), owner.Pos);
            if (!LevelHelper.TryMoveActorToRandomCoordsInRangeFrom(newMo, owner.radius * 2, 5 * owner.radius, owner.Pos)) {
                newMo.destroy();
                return;
            }
            owner.A_SpawnItemEx('TeleportFog');
            newMo.A_SpawnItemEx('TeleportFog');
            newMo.target = owner.target;
            newMo.A_ChangeCountFlags(false, FLAG_NO_CHANGE, FLAG_NO_CHANGE); // Don't count as kill, don't drop loot
        }
    }
}

class MAffPeriodicallyInvulnerable : RwMonsterAffix {
    override string getName() {
        return "Phasing";
    }
    override string getDescription() {
        return String.Format("INVL %.1f", gametime.ticksToSeconds(modifierLevel));
    }
    override int minRequiredRarity() {
        return 2;
    }
    override void initAndApplyEffectToRwMonsterAffixator(RwMonsterAffixator affixator, int quality) {
        modifierLevel = remapQualityToTicksFromSecondsRange(quality, 15, 5);
    }
    const InvulDuration = 3 * TICRATE;
    override void onDoEffect(Actor owner) {
        if (owner.bINVULNERABLE && occuredMoreThanTicksAgo(InvulDuration)) {
            owner.bINVULNERABLE = false;
            owner.A_SetRenderStyle(1, STYLE_Normal);
            updateLastEffectTick();
            return;
        }
        if (!owner.bINVULNERABLE && occuredMoreThanTicksAgo(modifierLevel)) {
            owner.bINVULNERABLE = true;
            owner.A_SetRenderStyle(1, STYLE_Add);
            updateLastEffectTick();
        }
    }
}

class MAffPeriodicallyInvisible : RwMonsterAffix {
    override string getName() {
        return "Spectral";
    }
    override string getDescription() {
        return String.Format("INVIS %.1f", gametime.ticksToSeconds(modifierLevel));
    }
    override int minRequiredRarity() {
        return 2;
    }
    override void initAndApplyEffectToRwMonsterAffixator(RwMonsterAffixator affixator, int quality) {
        modifierLevel = remapQualityToTicksFromSecondsRange(quality, 15, 5);
    }
    const InvisDuration = 4 * TICRATE;
    override void onDoEffect(Actor owner) {
        if (owner.bSTEALTH && occuredMoreThanTicksAgo(InvisDuration)) {
            owner.A_SetRenderStyle(1, STYLE_Normal);
            owner.bSTEALTH = false;
            RwMonsterAffixator.GetMonsterAffixator(owner).attachLight();
            updateLastEffectTick();
            return;
        }
        if (!owner.bSTEALTH && occuredMoreThanTicksAgo(modifierLevel)) {
            // owner.A_SetRenderStyle(1, STYLE_Fuzzy); - this causes bugs
            owner.bSTEALTH = true;
            RwMonsterAffixator.GetMonsterAffixator(owner).removeLight();
            updateLastEffectTick();
        }
    }
}

class MAffDamagingAura : RwMonsterAffix {
    override string getName() {
        return "Draining";
    }
    override string getDescription() {
        return "DRAIN "..modifierLevel;
    }
    override int minRequiredRarity() {
        return 3;
    }
    override void initAndApplyEffectToRwMonsterAffixator(RwMonsterAffixator affixator, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, 30);
    }
    override void onDoEffect(Actor owner) {
        if (
            Players[0].mo &&
            (level.maptime % 17 == 0) &&
            (owner.Distance3DSquared(Players[0].mo) < ((Players[0].mo.radius + owner.radius + modifierLevel*4.0) ** 2))
        ) {
            Players[0].mo.damageMobj(null, owner, 1, 'Normal', DMG_NO_ARMOR);
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
    override int minRequiredRarity() {
        return 3;
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
                if (!LevelHelper.TryMoveActorToRandomCoordsInRangeFrom(newMo, 0, 6 * owner.radius, owner.Pos)) {
                    newMo.destroy();
                    continue;
                }
                newMo.bNOINFIGHTING = true;
                newMo.bNOTARGET = true;
                newMo.A_ChangeCountFlags(false, FLAG_NO_CHANGE, FLAG_NO_CHANGE); // Don't count as kill, don't drop loot
                newMo.target = owner.target;
                newMo.A_SpawnItemEx('TeleportFog');
                AssignMinorSpreadVelocityTo(newMo);
            }
        }
    }
}

class MAffFireballRevenge : RwMonsterAffix {
    override string getName() {
        return "Vengeful";
    }
    override string getDescription() {
        return "REVENGE "..modifierLevel;
    }
    override int minRequiredRarity() {
        return 2;
    }
    override void initAndApplyEffectToRwMonsterAffixator(RwMonsterAffixator affixator, int quality) {
        modifierLevel = remapQualityToRange(quality, 3, 10);
    }
    const missileHSpread = 4.0; // Degrees
    const missileVSpread = 0.25; // Abs value for code simplification
    override void onOwnerDied(Actor owner) {
        if (owner) {
            for (let i = 0; i < modifierLevel; i++) {
                // TODO: direct missile to the one who is the killer
                let msl = owner.SpawnMissile(Players[0].mo, 'DoomImpBall');
                if (msl) {
                    msl.vel *= rnd.randf(0.7, 1.5);
                    let newXY = msl.rotateVector((msl.vel.X, msl.vel.Y), rnd.randf(-missileHSpread, missileHSpread));
                    msl.vel.x = newXY.X;
                    msl.vel.y = newXY.Y;
                    msl.vel.z += rnd.randf(-missileVSpread, missileVSpread);
                }
            }
        }
    }
}

class MAffRespawnsOnDeath : RwMonsterAffix { // Ohhhh this whole affix was horrible to figure out
    override string getName() {
        return "Undying";
    }
    override string getDescription() {
        if (modifierLevel <= 0) {
            return "MORTAL";
        }
        return "UNDYING "..modifierLevel;
    }
    override int minRequiredRarity() {
        return 3;
    }
    override void initAndApplyEffectToRwMonsterAffixator(RwMonsterAffixator affixator, int quality) {
        modifierLevel = remapQualityToRange(quality, 1, 3);
    }
    override void onOwnerDied(Actor owner) {
        if (modifierLevel <= 0) return;
        // Spawn "corpse". It's an OTHER new actor of the same class that just immediatly dies.
        let corpse = owner.Spawn(owner.GetClass());
        corpse.angle = owner.angle;
        corpse.SetOrigin(owner.Pos, false);
        // Do not count the actor towards kills (don't know which line from those is better):
        // corpse.ClearCounters();
        corpse.A_ChangeCountFlags(false, FLAG_NO_CHANGE, FLAG_NO_CHANGE);
        // SetHealth does not always change actor's state immediately, so we damage it manually
        corpse.damageMobj(null, null, corpse.Health - owner.Health, 'Normal', DMG_NO_PROTECT|DMG_NO_ARMOR);
    }
    override void onOwnerDiedPreviousTick(Actor owner) {
        if (modifierLevel <= 0) return;
        modifierLevel--;

        // Revive the owner
        owner.Revive();
        owner.Height = owner.Default.Height; // Gzdoom bug (?): this property is not auto-reset in Revive().
        owner.SetState(owner.ResolveState('See')); // The state is not auto-reset in Revive() either.

        // Reattach the light
        let affixator = RwMonsterAffixator.GetMonsterAffixator(owner);
        affixator.attachLight();

        // Teleport owner to other location
        let originalPos = owner.Pos;
        if (LevelHelper.TryMoveActorToRandomCoordsInRangeFrom(owner, 2*owner.radius, 10*owner.radius, owner.Pos)) {
            owner.A_SpawnItemEx('TeleportFog');
        }
    }
}
