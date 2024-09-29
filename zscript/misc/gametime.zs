class Gametime {

    const tps = 35;

    static float ticksToSeconds(int ticks) {
        return float(ticks) / float(tps);
    }

    static int secondsToTicks(float seconds) {
        return int(seconds * float(tps));
    }
}