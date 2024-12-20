class RwArmorStats {
    int currDurability;
    int maxDurability;
    int AbsorbsPercentage; // this many percents of damage will be directed to armor amount.
    int DamageReduction; // this many points of damage will be nullified.
    int BonusRepair; // How many armor points it gets from armor bonus. Is 0, can't be repaired.
    // Damage can't be nullified to 0, and can't be nullified if damage is higher than current armor amount

    int delayUntilRecharge; // Ticks. Only for energy armor
    int energyRestoreSpeedX1000; // Restored per tick. x1000 because of frame-logic related fixed point math


    bool IsEnergyArmor() {
        return (delayUntilRecharge > 0) && (energyRestoreSpeedX1000 > 0);
    }

    bool IsFull() {
        return (currDurability >= maxDurability);
    }

    double RestorePerSecond() {
        return double(TICRATE * energyRestoreSpeedX1000)/1000.;
    }
}