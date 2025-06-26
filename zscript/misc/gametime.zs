class Gametime {

    // Alternates between returning true and false each periodLengthTicks
    static bool GetPhase(int periodLengthTicks) {
        return (Level.maptime % (periodLengthTicks * 2)) < periodLengthTicks;
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