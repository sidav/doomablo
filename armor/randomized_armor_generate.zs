extend class RandomizedArmor {
    void Generate() {
        let prefixesCount = rnd.weightedRand(1, 3, 2, 0);

        // DEBUG: delete the following line when not needed
        prefixesCount = 3;

        AssignRandomAffixes(prefixesCount);
        rwFullName = rwbaseName;
    }
}