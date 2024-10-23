extend class RwMonsterAffixator {
    private void GenerateOwnersName() {

        switch (appliedAffixes.Size()) {
            case 0: return;
            case 1: 
                owner.SetTag(appliedAffixes[0].GetName().." "..owner.GetTag());
                return;
            case 2:
                owner.SetTag("Lv "..generatedQuality.." "..appliedAffixes[0].GetName().." "..appliedAffixes[1].GetName().." "..owner.GetTag());
                return;
            case 3:
                owner.SetTag("Lv "..generatedQuality.." "..getRandomAdjective(false).." "..owner.GetTag());
                return;
            case 4:
                owner.SetTag("Lv "..generatedQuality.." "..getRandomAdjective(true).." "..generateRandomName());
                return;
            case 5:
                owner.SetTag("Lv "..generatedQuality.." "..getRandomAdjective(true).." "..generateRandomName()..", the "..generateRandomDignity());
                return;
        }
    }

    static string getRandomAdjective(bool highLevel) {
        static const string weakAdjs[] = {
            "Cursed",
            "Disciplined",
            "Hating",
            "Tormented",
            "Unholy"
        };
        static const string strongAdjs[] = {
            "Corrupted",
            "Cursed",
            "Demonic",
            "Devouring",
            "Possessed",
            "Scary",
            "Terrifying"
        };
        if (highLevel) {
            return strongAdjs[rnd.randn(strongAdjs.Size())];
        }
        return weakAdjs[rnd.randn(weakAdjs.Size())];
    }

    static string generateRandomName() {
        static const string specialChars[] =
        {
            "",
            "",
            "",
            "'",
            "'",
            "-",
            "-ul-"
        };
        static const string syl1[] =
        {
            "Baa",
            "Bel",
            "Em",
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
            "kul",
            "let",
            "luk",
            "sot",
            "zek"
        };
        return syl1[rnd.randn(syl1.Size())]..specialChars[rnd.randn(specialChars.Size())]
            ..syl2[rnd.randn(syl2.Size())]..specialChars[rnd.randn(specialChars.Size())]
            ..syl3[rnd.randn(syl3.Size())];
    }

    static string generateRandomDignity() {
        static const string word1[] = {
            "Aeons",
            "Doomsday",
            "Promised",
            "Sinful"
        };
        static const string word2[] = {
            "Annihilator",
            "End",
            "Devourer",
            "Disciple",
            "Legion",
            "Obliterator",

            "of Abaddon",
            "of Gehenna"
        };
        return word1[rnd.randn(word1.Size())].." "..word2[rnd.randn(word2.Size())];
    }
}