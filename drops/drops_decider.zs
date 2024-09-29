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

    static bool dropArtifactOnly(int dropperHealth) {
        return dropperHealth >= 500;
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
        let rar = rnd.weightedRand(50, 100, 50, 30, 15, 5);
        rar = min(rar+rarMod, 5);
        let qty = rnd.linearWeightedRand(1, 100, 100, 1);
        qty = rar == 0 ? 1 : min(qty+qtyMod, 100);

        // debug.print("Rolling rarity (+"..rarMod..") and quality (+"..qtyMod.."): "..rar..", "..qty);
        return rar, qty;
    }
}