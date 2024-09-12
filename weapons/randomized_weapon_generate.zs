extend class RandomizedWeapon {

    void Generate() {
        let prefixesCount = rnd.weightedRand(1, 2, 3, 2, 1);

        // DEBUG: delete the following line when not needed
        // prefixesCount = 3;

        AssignRandomAffixes(prefixesCount);
    }

}