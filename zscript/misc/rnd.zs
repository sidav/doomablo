class rnd {

    static int rand(int min, int max) {
        return Random(min, max);
    }

    static int randn(int max) {
        return Random(0, max-1);
    }

    const floatRandomStep = 2.0 ** 24.0; // 24-bit mantissa, so biggest 32-bit possible is 16777216
    static float randf(float min, float max) {
        let r = float(Random(0, floatRandomStep)) / float(floatRandomStep); // [0-1] range
        return min + (max-min) * r;
    }

    const doubleRandomStep = 2.0 ** 31.0 - 1; // 52-bit mantissa, but random() takes signed int32 argument. So the max value possible is 2^31 - 1
    private static double randDouble(double min, double max) {
        let r = double(Random(0, doubleRandomStep)) / double(doubleRandomStep); // [0-1] range
        return min + (max-min) * r;
    }

    // static int randTicksFromSeconds(double minSeconds, double maxSeconds) {
    //     return TICRATE * randf(minSeconds, maxSeconds);
    // }

    static bool PercentChance(int percent) {
        return randn(100) < percent;
    }

    static bool OneChanceFrom(int chances) {
        if (chances <= 0) return false;
        return Random(0, chances-1) == 0;
    }

    // Creates rand in range either of [min1, max1] or [min2, max2] (equal chance for any value from both ranges)
    // First range MUST be smaller than the second one, and min/max order is important
    static int RandInTwoRanges(int min1, int max1, int min2, int max2) {
        let range1len = max1 - min1 + 1;
        let range2len = max2 - min2 + 1;
        let val = Random(0, range1len + range2len-1);
        // debug.print("Random in "..min1.."-"..max1.." or "..min2.."-"..max2..": r1l is "..range1len.."; r2l is "..range2len.."; roll is "..val..";");
        if (val < range1len) {
            return min1 + val;
        }
        return min2 + (val - range1len);
    }

    // Changes arr to be of "size" random ints, each in range either of [min1, max1] (left range) or [min2, max2] (right range).
    // Probability of RANGES (not each values!) are equal.
    static int fillArrWithRandsInTwoRanges(array <int> arr, int min1, int max1, int min2, int max2, int size, int minLeftEntries, int minRightEntries) {
        if (arr.Size() > 0) {
            debug.panic("Non-empty array given: "..debug.intArrToString(arr));
        }
        if (minLeftEntries + minRightEntries > size) {
            debug.panic("Bad arguments given: "..(minLeftEntries + minRightEntries).." > "..size);
        }

        let leftEntries = Random(minLeftEntries, size - minRightEntries);
        for (let i = 0; i < leftEntries; i++) {
            arr.Push(Random(min1, max1));
        }
        for (let i = leftEntries; i < size; i++) {
            arr.Push(Random(min2, max2));
        }
        // debug.print("Array "..debug.intArrToString(arr).." -> Balance is "..(size - leftEntries - leftEntries));
        return leftEntries;
    }

    static int linearWeightedRand(int from, int to, int fromWeight, int toWeight) {
        if (from == to) {
            return from;
        }
        fromWeight *= 100; // Increasing accuracy, as we're working with ints here
        toWeight *= 100;
        let totalVals = to-from+1;

        // Calculating weights sum
        let weightsSum = (fromWeight+toWeight)*(totalVals/2);
        if (totalVals % 2 != 0) {
            weightsSum += (fromWeight+toWeight)/2;
        }

        let selected = random(0, weightsSum-1);
        for (let i = 0; i < totalVals; i++) {
            let currWeight = fromWeight+(i * (toWeight - fromWeight) / (totalVals-1));
            if (selected < currWeight) {
                return i + from;
            }
            selected -= currWeight;
        }
        debug.panic("Something is wrong in linear weighted random. Args: "..
            from..", "..to..", "..fromWeight..", "..toWeight);
        return 0;
    }

    // This absolute MONSTROCITY comes from the fact I can't comfortably init dynamic arrays with values in ZScript. :|
    // I want to use something like:    let result = rnd.weightedRand(array <int> {5, 5, 2, 1});
    // but it's not possible. So let's use this awful code. 16 weights should be enough
    static int weightedRand(int x0 = 0, int x1 = 0, int x2 = 0, int x3 = 0, int x4 = 0, 
        int x5 = 0, int x6 = 0,int x7 = 0, int x8 = 0, int x9 = 0, int x10 = 0,
        int x11 = 0, int x12 = 0, int x13 = 0, int x14 = 0, int x15 = 0) {

        array <int> weights;
        weights.push(x0);
        weights.push(x1);
        weights.push(x2);
        weights.push(x3);
        weights.push(x4);
        weights.push(x5);
        weights.push(x6);
        weights.push(x7);
        weights.push(x8);
        weights.push(x9);
        weights.push(x10);
        weights.push(x11);
        weights.push(x12);
        weights.push(x13);
        weights.push(x14);
        weights.push(x15);

        // Calculating weights sum
        let weightsSum = 0;
        for (let i = 0; i < weights.Size(); i++) {
            weightsSum += weights[i];
        }
        if (weightsSum <= 0) {
            debug.panic("Bad weights sent.");
        }

        let selected = random(0, weightsSum-1);

        for (let i = 0; i < weights.Size(); i++) {
            let currWeight = weights[i];
            if (currWeight > 0 && selected < currWeight) {
                return i;
            }
            selected -= currWeight;
        }
        debug.panic("Something is wrong.");
        return 0;
    }

    static int WeightedRandArr(Array<int> weights) {
        int sum = 0;
        for (int i = 0; i < weights.size(); i++) {
            int w = weights[i];
            sum += w;
        }
        if (sum <= 0) { debug.panic("Bad weights sent."); }

        int selected = random(0,sum-1);

        for (int i = 0; i < weights.Size(); i++) {
            if (weights[i] > 0 && selected < weights[i]) {
                return i;
            }

            selected -= weights[i];
        }

        debug.panic("Weighted random failed to select an item.");
        return 0;
    }


    // Nonlinear weighted random (known as discrete geometrical distribution).
    // weightIncreaseFactor is how much times the next value is more probable than the previous one.
    // For example, if we repeatedly roll random in range 1-3 with weightIncreaseFactor 2 (each next is 2x more probable than the previous), total results will be like:
    // We will get (in ideal case): 1 - 100 times; 2 - 200 times; 3 - 400 times
    // Example 2: roll random 1-4 with weightIncreaseFactor 0.2 (0.2 == 1.0/5.0, so each next is 5x less probable than the previous):
    // 1 - 1000 times, 2 - 200 times, 3 - 40 times, 4 - 8 times.
    // Be careful with those though, as rounding error may make some values unobtainable.
    static int multipliedWeightedRand(int from, int to, double weightIncreaseFactor) {
        if (from == to) {
            return from;
        }
        // Calculating via a formula (I don't know if it's better than a loop)
        double weightsSum = (weightIncreaseFactor**(to-from+1) - 1)/(weightIncreaseFactor - 1);

        // Calculating weights sum via loop. Outcommented for now, I'm not sure which way is better
        // double weightsSum = 0;
        // for (let i = 0; i <= to-from; i++) {
        //     weightsSum += weightIncreaseFactor ** i;
        // }

        let selected = randDouble(0, weightsSum);
        float cumulativeWeight = 0.0;
        for (let x = 0; x <= to-from; x++) {
            cumulativeWeight += weightIncreaseFactor ** x;
            if (selected <= cumulativeWeight) {
                return from+x;
            }
        }
        debug.panic("Something is wrong in nonlinear weighted random. Args: "..
            from..", "..to..", "..weightIncreaseFactor);
        return 0;
    }

    // The same as previous one, but the endWeight simply shows how much weight the end value has (the first has 1.0)
    // SO: multipliedWeightedRand(from=1, to=10, weightIncreaseFactor=2) is the same as
    // multipliedWeightedRand(from=1, to=10, endWeight=1024)
    static int multipliedWeightedRandByEndWeight(int from, int to, double endWeight) {
        return multipliedWeightedRand(from, to, endWeight ** (1 / double(to - from)));
    }

    // Returns a gauss-distributed float. Dunno why it may be needed, but still.
    static float gaussianRandomf() {
        // Polar coords method
        let u = randf(-1, 1);
        let v = randf(-1, 1);
        let s = (u * u) + (v * v);
        while (s == 0 || s >= 1) {
            u = randf(-1, 1);
            v = randf(-1, 1);
            s = (u * u) + (v * v);
        }
        return u * sqrt(-2.0 * log(s) / s);
    }
}