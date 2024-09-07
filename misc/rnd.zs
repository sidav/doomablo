class rnd {

    static int rand(int min, int max) {
        return Random(min, max);
    }

    static bool OneChanceFrom(int chances) {
        return Random(0, chances-1) == 0;
    }

    const floatRandomStep = 1024.0;
    static float randf(float min, float max) {
        return float(Random(min*floatRandomStep, max*floatRandomStep))/floatRandomStep;
    }

    static int linearWeightedRand(int from, int to, int fromWeight, int toWeight) {
        fromWeight *= 100; // Increasing accuracy, as we're working with ints here
        toWeight *= 100;
        let totalVals = to-from+1;

        // Calculating weights sum
        let weightsSum = (fromWeight+toWeight)*(totalVals/2);
        if (totalVals % 2 != 0) {
            weightsSum += (fromWeight+toWeight)/2;
        }

        let selected = random(0, weightsSum);
        for (let i = 0; i < totalVals; i++) {
            let currWeight = fromWeight+(i * (toWeight - fromWeight) / (totalVals-1));
            if (selected <= currWeight) {
                return i + from;
            }
            selected -= currWeight;
        }
        debug.panic("Something is wrong.");
        return 0;
    }
}