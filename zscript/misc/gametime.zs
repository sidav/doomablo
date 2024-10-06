class Gametime {

    const tps = 35;

    // Returns true if tick is the first tick of any of the each Nth seconds.
    static bool checkPeriod(int tick, int seconds) {
        return tick > 0 && tick % (seconds * tps) == 0;
    }

    static float ticksToSeconds(int ticks) {
        return float(ticks) / float(tps);
    }

    static int secondsToTicks(float seconds) {
        return int(seconds * float(tps));
    }
}