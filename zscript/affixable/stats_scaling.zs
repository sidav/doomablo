class StatsScaler {

    // Used e.g. for monster HP scaling or weapon damage scaling.
    const exponentBase = 2.0164; // That means "each 'multipliesEachLevels' of levels the value will be multiplied by exponentRateBase
    const multipliesEachLevels = 20.; // Each this many levels the value will be multiplied by exponentBase
    static int ScaleIntValueByLevel(int value, int level) {
        return int(double(value) * exponentBase ** (double(level) / multipliesEachLevels));
    }

    static int UnscaleIntValueByLevel(int value, int level) {
        return int(double(value) / (exponentBase ** (double(level) / multipliesEachLevels)));
    }

    // Adds a minor randomization (+- 0.5 of the current level); the formula is the same
    static int ScaleIntValueByLevelRandomized(int value, int level, float expMod = 0.0) {
        let levelFloat = double(level);
        double expModifiedBase = exponentBase + expMod;
        let minVal = int(double(value) * expModifiedBase ** ((levelFloat - 0.5) / multipliesEachLevels));
        let maxVal = int(double(value) * expModifiedBase ** ((levelFloat + 0.5) / multipliesEachLevels));

        return Random(minVal, maxVal);
    }
}
