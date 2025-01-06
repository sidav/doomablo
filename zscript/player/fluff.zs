extend class RwPlayer {
    static clearscope string GetFluffNameForInfernoLevel(int level) {
        if (level == 1) {
            return "Fragile Hope";
        }
        static const string infFluff[] = {
            "The Quiet Before Chaos",
            "The Ember of Corruption",
            "Tide of Evil",
            "Corruption Surge",
            "Dominion Rising",
            "Covenant of Pandemonium",
            "The Ascension of Anathema",
            "Beyond Salvation",
            "The Crescendo of Gehennah",
            "The Eternal Malevolence",
            "Apotheosis of Abaddon"
        };
        return infFluff[level / (infFluff.Size() - 1)];
    }
}