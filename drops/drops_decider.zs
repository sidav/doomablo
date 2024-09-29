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

    static int, int rollRarityAndQuality(int rarMod, int qtyMod) {
        let rar = rnd.weightedRand(50, 100, 50, 30, 15, 5);
        rar = min(rar+rarMod, 5);
        let qty = rnd.linearWeightedRand(1, 100, 100, 1);
        qty = rar == 0 ? 1 : min(qty+qtyMod, 100);
        return rar, qty;
    }
}