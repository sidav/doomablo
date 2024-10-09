class DropsDecider {

    static bool decideIfCreateDrop(int dropperHealth) {
        int chances = 5;
        if (dropperHealth >= 1000) {
            return true;
        } else if (dropperHealth >= 500) {
            chances = 2;
        } else if (dropperHealth >= 250) {
            chances = 4;
        }
        return rnd.OneChanceFrom(chances);
    }

    static int whatToDrop(int dropperHealth) {
        // 0 - onetime item
        // 1 - weapon
        // 2 - armor
        if (dropperHealth >= 500) {
            return rnd.weightedRand(0, 5, 5); // Drop atrifacts only
        }
        return rnd.weightedRand(10, 4, 4);
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
        int qty;
        let plr = MyPlayer(Players[0].mo);
        if (plr) {
            int minQty = plr.minItemQuality;
            int maxQty = plr.maxItemQuality;
            qty = rnd.linearWeightedRand(minQty, maxQty, 5, 1);
        } else {
            debug.print("Non-player quality roll!");
            qty = rnd.linearWeightedRand(1, 100, 100, 1);
            qty = rar == 0 ? 1 : min(qty+qtyMod, 100);
        }

        // debug.print("Rolling rarity (+"..rarMod..") and quality (+"..qtyMod.."): "..rar..", "..qty);
        return rar, qty;
    }
}