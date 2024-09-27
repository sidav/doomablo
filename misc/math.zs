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

    static int getIntPercentage(int value, int percent) {
        // +50 needed for proper rounding
        return (value * percent + 50) / 100;
    }

    static int getPercentageFromInt(int value, int max) {
        // +50 needed for proper rounding
        return (100 * value + max/2) / max;
    }
}