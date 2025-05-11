class DropDatabase : StaticEventHandler { // Good thing this isn't SQL, lmao
    // This class has two jobs:
    // 1. At startup, iterate the whole class list looking for categories of items.
    Map<int,String> OneTimeItems; // Consumables such as Bonuses, Stimpacks, Scrolls, Spheres
    Map<int,String> AmmoItems; // Ammunition drops.
    Map<int,String> WeaponItems; // Types of weapons that can be dropped.
    Map<int,String> ArmorItems; // As above, for armor.
    Map<int,String> EquipItems; // Non-armor equipment.

    // 2. When something asks for a random drop, give it to them.

    int WeightedRand(Array<int> weights) {
        int sum = 0;
        for (w : weights) {
            sum += w;
        }
        if (sum <= 0) { debug.panic("Bad weights sent."); }

        int selected = random(0,sum-1);

        for (int i = 0; i < weights.Size(); i++) {
            if (weights[i] > 0 && selected < weights[i]) {
                return i;
            }

            selected -= weights[i];
        }

        debug.panic("Weighted random failed to select an item.");
        return 0;
    }

    String PickFromWeightList(Map<int,String> items) {
        MapIterator<int,String> it;
        Array<int> weights;
        Array<string> results;
        if (it.init(items);) {
            while (it.Valid() && it.Next()) {
                weights.push(it.GetKey());
                results.push(it.GetValue());
            }
        }

        // Now we have a list of weights, so we can just do WeightedRand.
        int selected = WeightedRand(weights);
        if (selected < 0 || selected > results.Size()) {
            String err = String.format("Invalid result %d from WeightedRand",selected);
            debug.panic(err);
        }

        return results[selected];
    }
}