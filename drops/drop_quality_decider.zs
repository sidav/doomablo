class DropQualityDecider {

    static int decideRarity(int modifier = 0) {
        let val = rnd.weightedRand(50, 100, 50, 30, 15, 5);
        val = min(val, 5);
        return val;
    }

    static int decideQuality(int modifier = 0) {
        let val = rnd.linearWeightedRand(1, 100, 100, 1);
        val = min(val, 100);
        return val;
    }
}