class RWStatsClass {
    Dice DamageDice;
    int Pellets;
    float HorizSpread;
    float VertSpread;
    int rofModifier; // Currently it's percentage modifier. 25 means the weapon fires 25% faster (75% base speed), -25 means 125% base speed.

    int rollDamage() {
        return DamageDice.Roll();
    }
}