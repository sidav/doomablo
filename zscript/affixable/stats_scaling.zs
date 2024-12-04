class StatsScaler {

    // Used e.g. for monster HP scaling or weapon damage scaling.
    const doublesEachLevels = 20.;
    static int ScaleIntValueByLevel(int value, int level) {
        return int(double(value) * 2 ** (double(level) / doublesEachLevels));
    }
}