extend class RandomizedWeapon {

    action void RWA_ApplyRateOfFire() {
        let rof = invoker.stats.rofModifier;
        if (rof == 0) {
            return; // no change required
        }
        let baseTicks = self.player.FindPSprite(PSP_WEAPON).tics;
        let newTicks = math.getIntPercentage(baseTicks, getFrameDurationPercentageWithSpeedBonus(rof));
        newTicks = clamp(newTicks, 1, 200);
        A_SetTics(newTicks);
    }

    action void RWA_ApplyRateOfFireToFlash() {
        let rof = invoker.stats.rofModifier;
        if (rof == 0) {
            return; // no change required
        }
        let baseTicks = self.player.FindPSprite(PSP_FLASH).tics;
        let newTicks = math.getIntPercentage(baseTicks, getFrameDurationPercentageWithSpeedBonus(rof));
        newTicks = clamp(newTicks, 1, 200);
        A_SetTics(newTicks);
    }

    action void RWA_ApplyReloadSpeed() {
        let rsm = invoker.stats.reloadSpeedModifier;
        if (rsm == 0) {
            return; // no change required
        }
        let baseTicks = self.player.FindPSprite(PSP_WEAPON).tics;
        let newTicks = math.getIntPercentage(baseTicks, getFrameDurationPercentageWithSpeedBonus(rsm));
        newTicks = clamp(newTicks, 1, 200);
        A_SetTics(newTicks);
    }

    // Speed bonus is in percents difference from 100% (for example, 25% bonus is 25 here, not 125), and is not the fraction (not 0.25).
    // ROF is FRAME SPEED, not FRAME DURATION - there was a mistake about it which caused extreme bonuses from RoF affixes.
    private static int getFrameDurationPercentageWithSpeedBonus(int speedBonusPerc) {
        // In "reals" without percents it would be 1 / (1 + speedBonus)
        // We multiply top and bottom parts of the fraction by 100, and then multiply result by 100 again to get the percentage
        // Hence: 100 * (100 / (100 + speedBonus*100)) -> 100 * (100 / (100 + speedBonusPercentage))
        return 10000/(100 + speedBonusPerc);
    }
    
    // int modifiedStatesThisSequence;
    // Will get basic ticks and change them according to fireratemodifier
    // action void ApplyRateOfFire(int baseTicks, bool stateJustBegan, int remainingModifiableStatesInSequence) {
    //     if stateJustBegan {
    //         modifiedStatesThisSequence = 0;
    //     }
    //     if (rof == 0) {
    //         return; // no change required
    //     }
    //     let rof = invoker.stats.rofModifier;
    //     let newTicks = baseTicks;

    //     // First: negative ROF Modifier (slowing the weapon down):
    //     switch (rof) {
    //     case -5:
            

    //     }

    //     A_SetTics(newTicks);
    // }

    // State wstate0, wstate1; // For morph
    // void MorphRateOfFire() {
    //     return;
    //     let weap = owner.player.readyweapon;
    //     if (!weap || weap != self)
    //         return;

    //     //multiply every OTHER frame by 1.5 (multiplying every frame makes it too slow and using a smaller factor doesn't always work since we can't have fractional tics)
    //     let ticvar = true;
    //     double fac = ticvar ? 5 : 1;	
    //     let ps0 = owner.player.FindPSprite(PSP_WEAPON);
    //     if (!ps0)
    //         return;
    //     ticvar = !ticvar;	
    //     if (ps0.curstate != wstate0) {		
    //         debug.tprint("Curr ticks "..ps0.tics);
    //         ps0.tics = Clamp(double(ps0.tics*fac), 2, 5);
    //         debug.tprint("After ticks "..ps0.tics);
    //         wstate0 = ps0.curstate;
    //     }
    //     let ps1 = owner.player.FindPSprite(PSP_FLASH);
    //     if (!ps1)
    //         return;
    //     if (ps1 && ps1.curstate != wstate1) {					
    //         ps1.tics = Clamp(double(ps1.tics*fac), 2, 5);
    //         wstate1 = ps1.curstate;
    //     }		
    // }
}