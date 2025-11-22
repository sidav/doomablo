// This file is WIP for streamlining affix effects.
// Call these funcs for all affixes in appropriate locations
extend class Affix {

    virtual int modifyRolledDamage(int rolledDmg, RwPlayer owner) {
        return rolledDmg;
    }

    // Universal
    virtual play void onDoEffect(Actor owner, Inventory affixedItem = null) {}
    virtual play void onOwnerDied(Actor owner) {}
    virtual play void onModifyDamage(int damage, out int newdamage, bool passive, Actor inflictor, Actor source, Actor owner, int flags) {}
    virtual play void onBeingUsed(Actor owner, Inventory affixedItem) {}

    // Weapons
    virtual play void onDamageDealtByPlayer(int damage, Actor target, RwPlayer plr) {}
    virtual play void onFatalDamageDealtByPlayer(int damage, Actor target, RwPlayer plr) {}
    virtual play void onProjectileSpawnedByPlayer(RwProjectile projectile, RwPlayer plr) {}

    // Armor
    virtual play void onAbsorbDamage(int damage, Name damageType, out int newdamage, Actor inflictor, Actor source, Actor armorOwner, int flags) {}

    // Player-beneficial or player-related
    virtual play void onPlayerStatsRecalc(RwPlayer owner) {}
    virtual play void onHandlePickup(Inventory pickedUp) {}

    // For monster affixes
    virtual play void onPutIntoMonsterInventory(Actor owner) {}
    virtual play void onDamageDealt(int damage, Actor target, Actor owner) {}
}