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

    // Returns integer: how many percents is "part" of the "whole"
    static int getIntFractionInPercent(int part, int whole) {
        // +50 needed for proper rounding
        return (100 * part + whole/2) / whole;
    }

    // Useful for things which just can't be floats, like frames' durations. 
    // Useful only for repeated (across multiple frames) calcs with same vars.
    // First var is whole undividable integer, second is fixed-point one, multiplied by the precision.
    // fractionAccum is a variable to store fractional part.
    // If the added value is e.g. 1.2345, the addition param should be 12345 and precision should be 10000
    // Example usage: to add 1.34 to 25, use AccumulatedFixedPointAdd(25, 134, 100, fractionAccum)
    // ALWAYS use the same precision with same fractionAccum var! Or, better, always stick same calculation to the same precision.
    static int AccumulatedFixedPointAdd(int whole, int addition, int precision, out int fractionAccum) {
        fractionAccum += whole * precision + addition;
        whole = fractionAccum / precision;
        fractionAccum = fractionAccum % precision;
        return whole;
    }
}