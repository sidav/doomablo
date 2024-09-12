extend class RandomizedArmor {
    void Generate() {
        let prefixesCount = rnd.weightedRand(1, 2, 2, 1);

        AssignRandomAffixes(prefixesCount);
    }
}