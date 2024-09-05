class Math {
    static int getIntPercentage(int value, int percent) {
        // +50 needed for proper rounding
        return (value * percent + 50) / 100;
    }
}