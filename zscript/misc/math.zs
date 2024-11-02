class Math {

    static int abs(int x) {
        if (x < 0)
            return -x;
        return x;
    }

    static int sign(int x) {
        if (x < 0)
            return -1;
        if (x == 0)
            return 0;
        return 1;
    }

    // Remaps integer from the range [fromMin, fromMax] to range [toMin, toMax] preserving the scale.
    static int remapIntRange(int val, int fromMin, int fromMax, int toMin, int toMax, bool randomizedInterpolation = false) {
        if (toMax < toMin) {
            let t = toMax;
            toMax = toMin;
            toMin = t;
            val = fromMax - val; // "Reverse" the argument in its range.
        }
        let fromLength = fromMax - fromMin;
        let toLength = toMax - toMin;
        // We need to solve the equation:
        //   val - fromMin             x
        // -----------------  =   -----------
        //    fromLength            toLength
        //
        // Then result = x + toMin.
        // where x = divideIntWithRounding(toLength * (val-fromMin), fromLength);

        let toReturn = toMin + divideIntWithRounding(toLength * (val-fromMin), fromLength);

        // Randomize "mid-step" values, if there's a room for it. It reduces accuracy, but allows for more varied results.
        if (randomizedInterpolation) {
            let ratio = (toLength / fromLength);
            if (ratio > 1) {
                // CASE 1: to-range is bigger than the from-range.
                // Example: 5 remapped from [1, 10] range to [1, 100] range may be remapped to 45, 46, 47, ..., 54
                // because it's all will still be the same 5 if remapped back again (with no randomization).

                // Remain in the range if applicable:
                let minRnd = val <= fromMin ? 0 : -ratio/2;
                let maxRnd = val >= fromMax ? 0 : ratio/2;
                toReturn += Random(minRnd, maxRnd);
            } else {
                // CASE 2: to-range is smaller than the from-range
                // It's more complicated... Well. 
                // Example: 52 remapped from [1, 100] range to [1, 10] range should be 5 80% of the time and 6 the remaining 20% of the time.
                // Their mean expected value is 5.2, so it's close enough to non-integer range remapping
                // CURRENTLY DISABLED because it is buggy as hell

                // ratio = (fromLength / toLength);
                // if (ratio > 1) {    
                //     toReturn = toMin + divideIntWithRounding(toLength * (val+Random(-toLength/2, toLength/2 - 1)-fromMin), fromLength);
                // }

            }
        }
        return toReturn;
    }

    static int divideIntWithRounding(int divisible, int divisor) {
        return (divisible + divisor/2) / divisor;
    }

    static int getIntPercentage(int value, int percent) {
        // +50 needed for proper rounding
        return (value * percent + 50) / 100;
    }

    static int getPercentageFromInt(int value, int max) {
        // +50 needed for proper rounding
        return (100 * value + max/2) / max;
    }
}