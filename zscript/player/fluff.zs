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

    clearscope string GetFluffNameForPlayerLevel() {
        static const string fluff[] = {
            "Burdened Soul",
            "Vessel of Regret",
            "Seeker of Atonement",
            "Repentant Wanderer",
            "Forsaken Piligrim",
            "Aspiring Hellfighter",
            "Bearer of flickering light",
            "Torchbearer in the darkness",
            "Last hope of man",
            "Avatar of Penitence",
            "Herald of Righteous Fury",
            "Champion of of Purging Flames",
            "Incarnate of Divine Retribution",
            "Inevitable Doom"
        };
        if (stats.currentExpLevel > 100) {
            return "The Doom Slayer";
        }
        return fluff[math.remapIntRange(stats.currentExpLevel, 1, 100, 1, fluff.Size()-1)];
    }
}