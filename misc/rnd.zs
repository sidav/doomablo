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

}