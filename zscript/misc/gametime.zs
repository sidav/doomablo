class Gametime {

    // Alternates between returning true and false each periodLengthTicks
    const defaultPeriod = 3 * TICRATE / 2;
    static bool GetPhase(int periodLengthTicks = defaultPeriod) {
        return (Level.maptime % (periodLengthTicks * 2)) < periodLengthTicks;
    }

    static bool phaseJustChanged() {
        return Level.maptime % defaultPeriod == 0;
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