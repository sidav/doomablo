class DropsDecider {

    static int decideDropsCount(int dropperHealth) {
        if (dropperHealth >= 1000) {
            return rnd.weightedRand(0, 0, 2, 3, 1);
        } else if (dropperHealth >= 500) {
            return rnd.weightedRand(0, 2, 3, 1);
        } else if (dropperHealth >= 250) {
            return rnd.weightedRand(1, 4, 1);
        }
        return rnd.weightedRand(4, 2, 1);
    }

    static int whatToDrop(int dropperHealth) {
        // 0 - onetime item (including ammo)
        // 1 - weapon
        // 2 - armor
        if (dropperHealth >= 1000) {
            return rnd.weightedRand(1, 2, 2); // drop artifacts mostly.
        } else if (dropperHealth >= 500) {
            return rnd.weightedRand(3, 1, 1);
        } else if (dropperHealth >= 250) {
            return rnd.weightedRand(4, 1, 1);
        }
        return rnd.weightedRand(10, 1, 1);
    }

    static int, int rollRarQtyModifiers(int dropperHealth) {
        int rarmod, qtymod;
        if (dropperHealth >= 1000) {
            rarmod = rnd.weightedRand(0, 0, 5, 2, 1);
            qtymod = rnd.rand(5, 20);
        } else if (dropperHealth >= 500) {
            rarmod = rnd.weightedRand(1, 3, 1);
            qtymod = rnd.rand(5, 10);
        } else if (dropperHealth >= 250) {
            rarmod = rnd.weightedRand(10, 1);
            qtymod = rnd.rand(0, 5);
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
            let plr = MyPlayer(Players[0].mo);
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