extend class RandomizedWeapon {

    // FDFAccum stands for "Frame Duration's Fraction Accumulator".
    int FireFDFAccum;
    int FlashFDFAccum;
    int ReloadFDFAccum;

    action void RWA_ApplyRateOfFire() { 
        let newDuration = invoker.getFrameDurationWithSpeedBonus(
            self.player.FindPSprite(PSP_WEAPON).tics,
            invoker.stats.rofModifier,
            invoker.FireFDFAccum
        );
        A_SetTics(newDuration);
    }

    action void RWA_ApplyRateOfFireToFlash() {
        let newDuration = invoker.getFrameDurationWithSpeedBonus(
            self.player.FindPSprite(PSP_FLASH).tics,
            invoker.stats.rofModifier,
            invoker.FlashFDFAccum
        );
        A_SetTics(clamp(newDuration, 1, 175)); // Don't reduce the ticks for flash below 1
    }

    action void RWA_ApplyReloadSpeed() {
        let newDuration = invoker.getFrameDurationWithSpeedBonus(
            self.player.FindPSprite(PSP_WEAPON).tics,
            invoker.stats.reloadSpeedModifier,
            invoker.ReloadFDFAccum
        );
        A_SetTics(newDuration);
    }

    // Uses the accumulator to determine if a frame should be shortened.
    // Algorithm idea is similar to "slope accumulator" in Bresenham's line.
    // Allows working with rate of fire bonuses (resolves the "80% of 3 frames" problem by periodically shortening only some durations)
    static int getFrameDurationWithSpeedBonus(int baseDuration, int speedBonusPerc, out int accumulator) {
        let expectedTicksX100 = baseDuration * 10000 / (100 + speedBonusPerc);
        accumulator += expectedTicksX100;
        let result = accumulator/100;
        accumulator = accumulator % 100; // Store only the fraction in the accumulator
        return result;
    }

    // static int getFrameDurationWithSpeedBonusOld(int baseDuration, int speedBonusPerc, out int accumulator) {
    //     if (accumulator < 0) { accumulator = 0; } // Handle the possible overflow

    //     let expectedTicksX100 = baseDuration * 10000 / (100 + speedBonusPerc);
    //     let prevAccum = accumulator / 100;
    //     accumulator += expectedTicksX100;
    //     // debug.print(String.format("BaseTicks %d, speedBonus %d, x %d", (baseDuration, speedBonusPerc, expectedTicksX100)));
    //     // debug.print(String.format("currAccum %d, prevAccum %d, result %d", (accumulator, prevAccum, (accumulator - prevAccum * 100)/100)));
    //     return (accumulator - prevAccum * 100)/100;
    // }
}