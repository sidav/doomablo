class RwArmorStats {
    int currDurability;
    int currRepairFraction; // stores current fractional part of the repair progress.
                            // OR currect fraction of energy armor recharge

    int maxDurability;
    int AbsorbsPercentage; // this many percents of damage will be directed to armor amount.
    int RepairFromBonusx1000; // How many armor points it gets from armor bonus, x1000 for fraction. If 0, can't be repaired.

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