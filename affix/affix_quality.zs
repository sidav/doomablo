extend class Affix {
    static int getTotalAlignmentOfAffixesArray(array <Affix> affixes) {
        let sum = 0;
        foreach (aff : affixes) {
            sum += aff.getAlignment();
        }
        return sum;
    }

    // An affix may be "good" (returns 1), "bad" (returns -1) or neutral (0).
    virtual int getAlignment() {
        return 0;
    }
}