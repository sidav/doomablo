class DropsDecider {

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
        // 0 - onetime item (armor bonus or health)
        // 1 - ammo
        // 2 - progression item
        // 3 - Randomizable artifact (weapon/armor/backpack)
        if (dropperHealth > 1000) {
            return rnd.weightedRand(1, 1, 1+dropperRarity, 1+2*dropperRarity); // drop artifacts mostly.
        } else if (dropperHealth >= 500) {
            return rnd.weightedRand(10, 5, 1+dropperRarity, 1+2*dropperRarity);
        } else if (dropperHealth >= 250) {
            return rnd.weightedRand(10, 5, 1+dropperRarity, 1+2*dropperRarity);
        } else {
            return rnd.weightedRand(10, 15, 1+dropperRarity, 1+2*dropperRarity);
        }
        return 0;
    }

    static int, int rollRarQtyModifiers(int dropperHealth, int dropperRarity) {
        int rarmod, qtymod;
        if (dropperHealth > 1000) {
            rarmod = rnd.weightedRand(0, 0, 5, 2, 1);
            qtymod = rnd.rand(1, 5);
        } else if (dropperHealth >= 500) {
            rarmod = rnd.weightedRand(1, 3, 1);
            qtymod = rnd.rand(1, 3);
        } else if (dropperHealth >= 250) {
            rarmod = rnd.weightedRand(10, 1);
            qtymod = rnd.rand(0, 5);
        }

        if (dropperRarity > 0) {
            qtyMod += rnd.rand(1, dropperRarity);
        }

        if (dropperRarity > 2) {
            rarmod += 1;
        }

        return rarmod, qtymod;
    }

    static int, int rollRarityAndQuality(int rarMod, int qtyMod) {
        // Roll rarity
        let rar = rnd.weightedRand(50, 100, 50, 30, 15, 5);
        rar = min(rar+rarMod, 5);

        // Roll quality
        int qty = 1;
        if (rar > 0) {
            let plr = RwPlayer(Players[0].mo);
            if (plr) {
                int minQty = plr.minItemQuality;
                int maxQty = plr.maxItemQuality;
                qty = rnd.linearWeightedRand(minQty, maxQty, 5, 1);
            } else {
                debug.print("Non-player quality roll!");
                qty = rnd.linearWeightedRand(1, 100, 100, 1);
            }
        }
        qty = min(qty+qtyMod, 100);

        // debug.print("Rolling rarity (+"..rarMod..") and quality (+"..qtyMod.."): "..rar..", "..qty);
        return rar, qty;
    }
}