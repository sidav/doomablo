class NameGenerator {

    ////////////////////////////////////////////////////////////
    // "X Y ArtifactName of Z Noun"
    static string createXYAZName(string x, string y, string baseName, string z) {
        static const string suff[] = {
            "Tech",
            "Experiment",
            "Trial"
        };
        return x.." "..y.." "..baseName.." of "..z.." "..suff[rnd.randn(suff.Size())];
    }

    ////////////////////////////////////////////////////////////
    // "X of Y", "X's Y", "X-ed Y" and etc names
    static string createFluffedName(string baseName) {
        static const string pref[] = {
            "Blazkowicz's",
            "Commander Keen's",
            "Corvus's",
            "Cynic's",
            "Dave's",
            "Daedolon's",
            "Experimental",
            "Famous",
            "Great",
            "Modified",
            "Prototype",
            "Reassembled",
            "Ripley's",
            "Strange",
            "Tinkered",
            "UAC"
        };
        return pref[rnd.randn(pref.Size())].." "..baseName;
    }

    ////////////////////////////////////////////////////////////
    // Fully random names
    static string createAngelicOrDemonicName(string baseName) {
        if (rnd.OneChanceFrom(2)) {
            return generateRandomCursedName(baseName);
        }
        return generateRandomBlessedName(baseName);
    }

    private static string generateRandomBlessedName(string baseName) {
        static const string pref[] = {
            "Angelic",
            "Blessed",
            "Holy",
            "Righteous",
            "Zealous"
        };
        static const string syl1[] =
        {
            "Dae",
            "Lum",
            "Lym",
            "Mal",
            "Pah",
            "Tau",
            "Tyr"
        };
        static const string syl2[] =
        {
            "do",
            "lo",
            "ma",
            "na",
            "no",
            "ta"
        };
        static const string syl3[] =
        {
            "as",
            "el",
            "er",
            "fel",
            "il",
            "ir",
            "on",
            "tar",
            "tyr",
            "yl",
            "yr"
        };
        return pref[rnd.randn(pref.Size())]
        .." "..baseName.." "
        .."\""..syl1[rnd.randn(syl1.Size())]..syl2[rnd.randn(syl2.Size())]..syl3[rnd.randn(syl3.Size())].."\"";
    }

    private static string generateRandomCursedName(string baseName) {
        static const string pref[] = {
            "Corrupted",
            "Cursed",
            "Demonic",
            "Possessed"
        };
        static const string syl1[] =
        {
            "Baa",
            "Bel",
            "Ul",
            "Xar",
            "Xo"
        };
        static const string syl2[] =
        {
            "",
            "fi",
            "lur",
            "re",
            "xe"
        };
        static const string syl3[] =
        {
            "bab",
            "bub",
            "duc",
            "lur",
            "leg",
            "sto",
            "zaj"
        };

        return pref[rnd.randn(pref.Size())]
        .." "..baseName.." "
        .."\""..syl1[rnd.randn(syl1.Size())]..syl2[rnd.randn(syl2.Size())]..syl3[rnd.randn(syl3.Size())].."\"";
    }
}