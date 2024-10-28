class NameGenerator {

    ////////////////////////////////////////////////////////////
    // "X Y", "X's Y", "X-ed Y" and etc names
    static string createFluffedName(string baseName) {
        static const string pref[] = {
            "Brand new",
            "Diplomatic",
            "Experimental",
            "Fair",
            "Famous",
            "Great",
            "Glued",
            "Homemade",
            "Modified",
            "Prototype",
            "Qualitative",
            "Reassembled",
            "Reassuring",
            "Rebuilt",
            "Scarce",
            "Serviced",
            "Strange",
            "Smuggled",
            "Tinkered",
            "Trophy",
            "UAC-approved",
            "UAC-patented"
        };
        return pref[rnd.randn(pref.Size())].." "..baseName;
    }

    static string createPossessiveName(string baseName) {
        static const string pref[] = {
            "Agent Ash's",
            "Baratus'",
            "Bertruger's",
            "Bitterman's",
            "Blazkowicz's",
            "Caleb's",
            "Commander Keen's",
            "Corvus's",
            "Cynic's",
            "Dave's",
            "Dawn's",
            "Daedolon's",
            "Duke's",
            "Hayden's",
            "Lo Wang's",
            "Parias'",
            "Pierce's",
            "Ranger's",
            "Ripley's",
            "Slayer's",
            "Tekla's",
            "Xanthippe's",
            "Yendor's"
        };
        return pref[rnd.randn(pref.Size())].." "..baseName;
    }

    ////////////////////////////////////////////////////////////
    // Fully random names
    static string generateRandomBlessedName(string baseName) {
        static const string pref[] = {
            "Angelic",
            "Blessed",
            "Righteous",
            "Shining",
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

    static string generateRandomCursedName(string baseName) {
        static const string pref[] = {
            "Corrupted",
            "Cursed",
            "Demonic",
            "Possessed",
            "Scary",
            "Terrifying"
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