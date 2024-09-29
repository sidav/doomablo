class GameDetector {
    static bool isDoom1() {
        return (Wads.FindLump("DSBOSSIT", 0, Wads.ANYNAMESPACE) == -1);
    }
}