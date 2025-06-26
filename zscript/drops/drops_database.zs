class DropDatabaseHandler : StaticEventHandler { // Good thing this isn't SQL, lmao
    // This class has two jobs:
    // 1. At startup, iterate the whole class list looking for categories of items.
    Map<String,int> OneTimeItems; // Consumables such as Bonuses, Stimpacks, Scrolls, Spheres
    Map<String,int> AmmoItems; // Ammunition drops.
    Map<String,int> WeaponItems; // Types of weapons that can be dropped.
    Map<String,int> ArmorItems; // As above, for armor.
    Map<String,int> EquipItems; // Non-armor equipment.

    static DropDatabaseHandler Get() {
        return DropDatabaseHandler(StaticEventHandler.Find("DropDatabaseHandler"));
    }

    override void OnRegister() {
        // Start by pushing all the known OneTimeItems.
        // TODO: Better way of doing this.
        OneTimeItems.insert("RwArmorBonus",400);
        OneTimeItems.insert("HealthBonus",400);
        OneTimeItems.insert("Stimpack",100);
        OneTimeItems.insert("Blursphere",10);
        OneTimeItems.insert("Soulsphere",7);
        OneTimeItems.insert("Berserk",5);
        OneTimeItems.insert("MegaSphere",3);
        OneTimeItems.insert("InvulnerabilitySphere",1);
        OneTimeItems.insert("StatScroll",10);
        OneTimeItems.insert("RwFlaskRefill",200);
        OneTimeItems.insert("ForsakenTome", 1);
        // Also, ammo items.
        // No plans to add new ammo, AFAIK.
        AmmoItems.insert("Clip",5);
        AmmoItems.insert("Shell",5);
        AmmoItems.insert("RocketAmmo",1);
        AmmoItems.insert("Cell",2);

        debug.print("=== All artifacts' weights: ===");
        // And now, iterate the whole class list...
        // I might be able to make this even more flexible later.
        // There's a way to check if a class has a function,
        // which would mean that I could have each of these implement a "GetRandWeight()" function
        // and then check for the presence of that function
        // to insert items into the drop tables.
        // This would necessarily mean unifying all of the item drops into one table, though.
        foreach (c : AllClasses) {
            // Don't include abstract classes.
            if (c.isAbstract()) {
                continue;
            }
            // Sort items into their proper lists.
            if (c is "RandomizedWeapon") {
                Class<Actor> rwc = c.GetClassName();
                let rw = RandomizedWeapon(GetDefaultByType(rwc));
                WeaponItems.Insert(rw.GetClassName(),rw.rweight);
                console.printf("  Weapon - %s (%d)",rw.GetClassName(),rw.rweight);
            }
            if (c is "RandomizedArmor") {
                Class<Actor> rac = c.GetClassName();
                let ra = RandomizedArmor(GetDefaultByType(rac));
                ArmorItems.Insert(ra.GetClassName(),ra.rweight);
                console.printf("  Armor - %s (%d)",ra.GetClassName(),ra.rweight);
            }
            if (c is "RwBackpack") {
                Class<Actor> bpc = c.GetClassName();
                let bp = RwBackpack(GetDefaultByType(bpc));
                EquipItems.Insert(bp.GetClassName(),bp.rweight);
                console.printf("  Backpack - %s (%d)",bp.GetClassName(),bp.rweight);
            }
            if (c is "RwFlask") {
                Class<Actor> flc = c.GetClassName();
                let fl = RwFlask(GetDefaultByType(flc));
                EquipItems.Insert(fl.GetClassName(),fl.rweight);
                console.printf("  Flask - %s (%d)",fl.GetClassName(),fl.rweight);
            }
        }

    }

    // 2. When something asks for a random drop, give it to them.
    String PickFromWeightList(Map<String,int> items) {
        MapIterator<String,int> it;
        Array<int> weights;
        Array<string> results;
        it.init(items);
        foreach (k, v : it) {
            weights.push(v);
            results.push(k);
        }

        // Now we have a list of weights, so we can just do WeightedRand.
        int selected = rnd.WeightedRandArr(weights);
        if (selected < 0 || selected > results.Size()) {
            String err = String.format("Invalid result %d from WeightedRand",selected);
            debug.panic(err);
        }

        string result = results[selected];

        return result;
    }

    String PickWeapon() {
        return PickFromWeightList(WeaponItems);
    }

    String PickArmor() {
        return PickFromWeightList(ArmorItems);
    }

    String PickEquip() {
        return PickFromWeightList(EquipItems);
    }

    String PickAmmo() {
        return PickFromWeightList(AmmoItems);
    }

    String PickOneTimeItem() {
        return PickFromWeightList(OneTimeItems);
    }
}