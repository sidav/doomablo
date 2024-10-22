// This file is WIP for streamlining affix effects.
// Call these funcs for all affixes in appropriate locations
extend class Affix {

    virtual int modifyRolledDamage(int rolledDmg, RwPlayer owner) {
        return rolledDmg;
    }

    virtual play void onDamageDealtByPlayer(int damage, Actor target, RwPlayer plr) {}
    virtual play void onFatalDamageDealtByPlayer(int damage, Actor target, RwPlayer plr) {}

}