class RwArmorStats {
    int CurrentAmount;
    int MaxAmount;
    int AbsorbsPercentage; // this many percents of damage will be directed to armor amount.
    int DamageReduction; // this many points of damage will be nullified.
    int BonusRepair; // How many armor points it gets from armor bonus. Is 0, can't be repaired.
    // Damage can't be nullified to 0, and can't be nullified if damage is higher than current armor amount
}