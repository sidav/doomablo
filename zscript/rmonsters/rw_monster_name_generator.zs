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
                owner.SetTag(levelString()..generateRandomAlias());
                return;
            case 4:
                owner.SetTag(levelString()..getRandomAdjective().." "..generateRandomAlias());
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
            "Warrior"
        };
        return suffs[rnd.randn(suffs.Size())];
    }

    static string generateRandomAlias() {
        static const string word1[] = {
            "It-who-",
            "It-what-",
            "That-which-",
            "One who "
        };
        static const string word2[] = {
            "devastates",
            "glows",
            "obliterates",
            "preys",
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
            "Cursed",
            "Cyclopic",
            "Demonic",
            "Devouring",
            "Evil",
            "Infamous",
            "Maddening",
            "Miasmic",
            "Possessed",
            "Scary",
            "Terrifying",
            "Vile"
        };
        return Adjs[rnd.randn(Adjs.Size())];
    }

    static string generateRandomName() {
        static const string specialChars[] =
        {
            "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",
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
            "Aeons",
            "Dark Will",
            "Dark Might",
            "Doomsday",
            "Evil",
            "Gargantuan",
            "Insufferable",
            "Nightmare",
            "Promised",
            "Propheted",
            "Sinful"
        };
        static const string word2[] = {
            "Annihilator",
            "End",
            "Devourer",
            "Disciple",
            "Harbinger",
            "Legion",
            "Obliterator",
            "Terrifier",

            "one of Abaddon",
            "one of Gehennah",
            "one of Hell's depth",
            "one of Tartarus"
        };
        return word1[rnd.randn(word1.Size())].." "..word2[rnd.randn(word2.Size())];
    }
}