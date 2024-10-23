// This is a special item which is put into monster inventory
// The item itself is affixable, not the monster (for ensuring universal compatibility)
class RwMonsterAffixator : Inventory {
    mixin Affixable; // Maybe it's NOT Affixable? The logic is quite different (at least for now)

    string descriptionStr;
    string lightId;

    override void DoEffect() {
        if (owner.Health <= 0) {
            return;
        }
        Affix aff;
        foreach (aff : appliedAffixes) {
            aff.onDoEffect(owner);
        }
    }

    override void OwnerDied () {
        removeLight();
    }

    override void ModifyDamage(int damage, Name damageType, out int newdamage, bool passive, Actor inflictor, Actor source, int flags) {
        if (owner.Health <= 0) {
            return;
        }
        // debug.print("Owner "..owner.GetClassName()..": damage before "..damage);
        // Passive is True if the attack is being received by the owner. False if the attack is being dealt by the owner.
        if (passive) {
            Affix aff;
            foreach (aff : appliedAffixes) {
                aff.onModifyDamageToOwner(damage, damageType, newdamage, inflictor, source, owner, flags);
            }
        } else {
            Affix aff;
            foreach (aff : appliedAffixes) {
                aff.onModifyDamageDealtByOwner(damage, damageType, newdamage, inflictor, source, owner, flags);
            }
        }
        // debug.print("  Damage after "..newdamage);
    }

    void attachLight() {
        let rarity = appliedAffixes.Size();
        if (rarity == 0) {
            return;
        }
        if (lightId == "") {
            lightId = ""..rnd.randn(10000);
        }
        Color clr;
        int flags;
        [clr, flags] = lightColorAndFlagsForRarity(rarity);
        owner.A_AttachLight(
            lightId,
            // DynamicLight.PointLight,
            DynamicLight.PulseLight,
            clr,
            owner.radius * 1.25,
            (owner.radius * 1.5) + 7 * rarity,
            flags,
            (0, 0, owner.Height/2),
            param: 3.0
        );
    }

    static Color, int lightColorAndFlagsForRarity(int rarity) {
        switch (rarity) {
            case 0: return 0xFFFFFF, 0;
            case 1: return 0x00FF00, DYNAMICLIGHT.LF_DONTLIGHTMAP;
            case 2: return 0x1111FF, DYNAMICLIGHT.LF_DONTLIGHTMAP;
            case 3: return 0xCC00FF, DYNAMICLIGHT.LF_SUBTRACTIVE|DYNAMICLIGHT.LF_DONTLIGHTMAP;
            case 4: return 0xAA0000, DYNAMICLIGHT.LF_SUBTRACTIVE;
            case 5: return 0xFFEEEE, DYNAMICLIGHT.LF_SUBTRACTIVE;
        }
        return 0xff00ff;
    }
    
    void removeLight() {
        owner.A_RemoveLight(lightId);
    }
}