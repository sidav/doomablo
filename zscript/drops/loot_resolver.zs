class LootResolver {

    static int decideDropsCount(int dropperHealth, int dropperRarity) {
        let count = -1;
        if (dropperHealth > 1000) {
            count = rnd.weightedRand(0, 0, 2, 3, 1);
        } else if (dropperHealth >= 500) {
            count = rnd.weightedRand(2, 3, 2, 1);
        } else if (dropperHealth >= 250) {
            count = rnd.weightedRand(3, 4, 1);
        } else {
            count = rnd.weightedRand(8, 2, 1);
        }
        if (dropperRarity == 1 && count == 0) {
            count++;
        }
        if (dropperRarity > 1) {
            count += rnd.weightedRand(0, dropperRarity/2, dropperRarity/3, dropperRarity/5);
        }
        if (count == -1) {
            debug.panic(String.Format("Count not set! dropperHealth is %d, dropperRarity is %d", (dropperHealth, dropperRarity)));
        }
        return count;
    }

    static int whatToDrop(int dropperHealth, int dropperRarity) {
        // 0 - consumable item (armor bonus or health or whatever)
        // 1 - ammo
        // 2 - Randomizable artifact (weapon/armor/backpack/flask)
        if (dropperHealth > 1000) {
            return rnd.weightedRand(
                1, // Consumable item weight
                1, // Ammo weight
                3+2*dropperRarity // Artifact weight
            ); // drop artifacts mostly.
        } else if (dropperHealth >= 500) {
            return rnd.weightedRand(
                5, // Consumable item weight
                1, // Ammo weight
                1+2*dropperRarity // Artifact weight
            );
        } else if (dropperHealth >= 250) {
            return rnd.weightedRand(
                10, // Consumable item weight
                5, // Ammo weight
                1+2*dropperRarity // Artifact weight
            );
        } else {
            return rnd.weightedRand(
                10, // Consumable item weight
                15, // Ammo weight
                1+2*dropperRarity // Artifact weight
            );
        }
        return 0;
    }

    static int rollRarityModifierForMonsterDrop(int dropperHealth, int dropperRarity) {
        int rarmod;
        // First, dropper rarity influences minimum rarity of dropped stuff.
        switch (dropperRarity) {
            case 0:
                rarmod = 0;
                break;
            case 1:
                rarmod = rnd.weightedRand(100, 1);
                break;
            case 2:
                rarmod = rnd.weightedRand(50, 1);
                break;
            case 3:
                rarmod = rnd.weightedRand(20, 1);
                break;
            case 4:
                rarmod = rnd.weightedRand(0, 20, 1);
                break;
            case 5:
                rarmod = rnd.weightedRand(0, 5, 1);
                break;
            default:
                rarmod = 0;
                debug.warning(String.format("Unknown loot dropper rarity: %d, falling back to 0", dropperRarity));
                break;
        }
        // Second, dropper health also influences min rarity of dropped stuff.
        if (dropperHealth >= 1000) {
            rarmod += rnd.weightedRand(0, 10, 5);
        } else if (dropperHealth >= 500) {
            rarmod += rnd.weightedRand(10, 3, 1);
        } else if (dropperHealth >= 250) {
            rarmod += rnd.weightedRand(10, 1);
        }

        return rarmod;
    }

    static int rollRarityForMonsterDrop(int rarMod) {
        // Roll rarity
        let rar = rnd.weightedRand(4300, 4420, 1000, 200, 25, 1);
        rar = clamp(rar+rarMod, 0, RaritiesHelper.MAX_RARITY);
        return rar;
    }

    static int, int rollRarityAndQualityForMapPlacedItem() {
        int rar = rollRarityForMonsterDrop(rnd.weightedRand(0, 20, 1));
        if (rar == RaritiesHelper.UNIQUE_RARITY) rar--; // Unique items are never map-placed (and I don't know how to implement this lol)
        int qty = 1;
        let plr = RwPlayer(Players[0].mo);
        if (plr) {
            qty = plr.rollForDropLevel();
        } else {
            debug.warning("Non-player quality roll!");
        }
        qty = clamp(qty, 1, 100);
        return rar, qty;
    }
}