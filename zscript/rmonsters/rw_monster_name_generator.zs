extend class RwMonsterAffixator {
    private void GenerateOwnersName() {

        switch (appliedAffixes.Size()) {
            case 0: return;
            case 1: 
                owner.SetTag(levelString()..appliedAffixes[0].GetName().." "..owner.GetTag());
                return;
            case 2:
                owner.SetTag(levelString()..owner.GetTag().." "..getRandomNameSuffix());
                return;
            case 3:
                owner.SetTag(levelString()..getRandomAdjective().." "..getRandomNameSuffix());
                return;
            case 4:
                owner.SetTag(levelString()..generateRandomAlias().." the "..getRandomAdjective());
                return;
            case 5:
                owner.SetTag(levelString()..getRandomAdjective().." "..generateRandomName()..", the "..generateRandomDignity());
                return;
        }
    }

    string levelString() {
        return "Lv "..generatedQuality.." ";
    }

    static string getRandomNameSuffix() {
        static const string suffs[] = {
            "Berserker",
            "Captain",
            "Commander",
            "Disciple",
            "Eater",
            "Enforcer",
            "Executor",
            "Guardian",
            "Incubus",
            "Nightmare",
            "Leader",
            "Legionnaire",
            "Mutant",
            "Tempter",
            "Torturer",
            "Undead",
            "Warrior"
        };
        return suffs[rnd.randn(suffs.Size())];
    }

    static string generateRandomAlias() {
        static const string word1[] = {
            "It-who-",
            "It-what-",
            "That-which-",
            "One-who-"
        };
        static const string word2[] = {
            "devastates",
            "feeds",
            "foresees",
            "glows",
            "lives",
            "lurks",
            "moves",
            "obliterates",
            "preys",
            "quivers",
            "screams",
            "suffers",
            "thirsts",
            "tortures",
            "waits",
            "yearns"
        };
        return word1[rnd.randn(word1.Size())]..word2[rnd.randn(word2.Size())];
    }

    static string getRandomAdjective() {
        static const string Adjs[] = {
            "Blasphemous",
            "Bloodthirsty",
            "Corrupted",
            "Cosmic",
            "Cursed",
            "Cyclopic",
            "Demonic",
            "Devouring",
            "Evil",
            "Gargantuan",
            "Infamous",
            "Insufferable",
            "Maddening",
            "Miasmic",
            "Possessed",
            "Promised",
            "Propheted",
            "Scary",
            "Sinful",
            "Terrifying",
            "Unholy",
            "Unliving",
            "Vile"
        };
        return Adjs[rnd.randn(Adjs.Size())];
    }

    static string generateRandomName() {
        static const string specialChars[] =
        {
            "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",
            "'", "'", "'", 
            "-",
            "-al-",
            "-ul-"
        };
        static const string syl1[] =
        {
            "Ar",
            "Baa",
            "Bar",
            "Bel",
            "Em",
            "Gar",
            "Gul",
            "Hu",
            "Hul",
            "Jo",
            "Jog",
            "Pa",
            "Pan",
            "Ra",
            "Rah",
            "She",
            "Shu",
            "Ul",
            "Xar",
            "Xo"
        };
        static const string syl2[] =
        {
            "",
            "bre",
            "fi",
            "ga",
            "gu",
            "gul",
            "kar",
            "kul",
            "lon",
            "lur",
            "mar",
            "nox",
            "ran",
            "re",
            "rus",
            "pe",
            "xe",
            "xer",
            "xu",
            "xur",
            "zer"
        };
        static const string syl3[] =
        {
            "bab",
            "bub",
            "duc",
            "dul",
            "gul",
            "glo",
            "kul",
            "let",
            "lep",
            "luk",
            "mol",
            "mue",
            "ort",
            "ron",
            "sot",
            "tan",
            "tot",
            "vul",
            "vex",
            "vir",
            "xan",
            "zek"
        };
        return syl1[rnd.randn(syl1.Size())]..specialChars[rnd.randn(specialChars.Size())]
            ..syl2[rnd.randn(syl2.Size())]..specialChars[rnd.randn(specialChars.Size())]
            ..syl3[rnd.randn(syl3.Size())];
    }

    static string generateRandomDignity() {
        static const string word1[] = {
            "Acolyte",
            "Aeons",
            "Annihilator",
            "Dark Will",
            "Dark Might",
            "Devourer",
            "Disciple",
            "Doomsday",
            "Harbinger",
            "Legion",
            "Mentor",
            "Nightmare",
            "Obliterator",
            "Preacher",
            "Promised one",
            "Propheted one",
            "Terrifier",
            "Unborn",
            "Worst"
        };
        static const string word2[] = {
            "of Abaddon",
            "of dark prophecy",
            "of doom",
            "of fate",
            "of Gehennah",
            "of Hell's depths",
            "of insanity",
            "of the end",
            "of Tartarus",
            "of times to come",
            "of unimaginable",
            "of what comes"
        };
        return word1[rnd.randn(word1.Size())].." "..word2[rnd.randn(word2.Size())];
    }
}