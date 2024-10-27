class Gametime {

    // Returns true if tick is the first tick of any of the each Nth seconds.
    static bool checkPeriod(int tick, int seconds) {
        return tick > 0 && tick % (seconds * TICRATE) == 0;
    }

    static float ticksToSeconds(int ticks) {
        return float(ticks) / float(TICRATE);
    }

    static float ticksToPeriod(int ticks) {
        return 1.0/(float(ticks) / float(TICRATE));
    }

    static int secondsToTicks(float seconds) {
        return int(seconds * float(TICRATE));
    }
}