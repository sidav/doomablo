// This file is WIP for streamlining affix effects.
// Call these funcs for all affixes in appropriate locations
extend class Affix {

    virtual int modifyRolledDamage(int rolledDmg, RwPlayer owner) {
        return rolledDmg;
    }

    // Universal
    virtual play void onDoEffect(Actor owner) {}
    virtual play void onModifyDamage(int damage, Actor target, Actor owner) {}

    // Weapons
    virtual play void onDamageDealtByPlayer(int damage, Actor target, RwPlayer plr) {}
    virtual play void onFatalDamageDealtByPlayer(int damage, Actor target, RwPlayer plr) {}

    // For monster affixes
    virtual play void onPutIntoMonsterInventory(Actor owner) {}
    virtual play void onDamageDealt(int damage, Actor target, Actor owner) {}
}