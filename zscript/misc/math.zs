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
    static int remapIntRange(int val, int fromMin, int fromMax, int toMin, int toMax) {
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
        // let x = divideIntWithRounding(toLength * (val-fromMin), fromLength);
        return toMin + divideIntWithRounding(toLength * (val-fromMin), fromLength);
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