// Handles the replacement of default weapons/items. 
class MonstersAffixingHandler : EventHandler
{

    bool warningPrinted;

	override void WorldThingSpawned(worldEvent e) {
		let mo = e.thing;
		if (!(mo && mo.bIsMonster)) {
            return;
        }

        if (level.maptime > TICRATE) {
            return; // Affixate only map-placed monsters.
        }

        // int rarmod, qtymod;
        // [rarmod, qtymod] = rollRarQtyModifiers(mo.health);
        int rar, qty;
        [rar, qty] = rollRarityAndQuality(0, 0);

        // debug.print("Giving the affixator to "..mo.GetClassName());
        // debug.print(String.format("       Rar %d qty %d;", rar, qty));
        RwMonsterAffixator.AffixateMonster(mo, rar, qty);
        if (rar > 4 && !warningPrinted) {
            warningPrinted = true;
            mo.A_PrintBold("$RAREMONSTERSPAWNED");
        }
	}

    // static int, int rollRarQtyModifiers(int monsterHealth) {
    //     return 0, 0
    //     int rarmod, qtymod;
    //     if (monsterHealth >= 1000) {
    //         rarmod = rnd.weightedRand(100, 40, 10, 5, 2, 1);
    //         qtymod = rnd.rand(1, 5);
    //     } else if (monsterHealth >= 500) {
    //         rarmod = rnd.weightedRand(10, 3, 1);
    //         qtymod = rnd.rand(1, 3);
    //     } else if (monsterHealth >= 250) {
    //         rarmod = rnd.weightedRand(10, 1);
    //         qtymod = rnd.rand(0, 1);
    //     }
    //     return rarmod, qtymod;
    // }

    static int, int rollRarityAndQuality(int rarMod, int qtyMod) {
        // Roll rarity
        let rar = rnd.weightedRand(600, 200, 80, 20, 7, 1);
        rar = min(rar+rarMod, 5);

        // Roll quality
        int qty = 1;
        let plr = RwPlayer(Players[0].mo);
        if (plr) {
            int minQty = plr.minItemQuality;
            int maxQty = plr.maxItemQuality;
            qty = rnd.linearWeightedRand(minQty, maxQty, 5, 1);
        } else {
            debug.print("Non-player quality roll!");
            qty = rnd.linearWeightedRand(1, 100, 100, 1);
        }
        qty = min(qty+qtyMod, 100);

        // debug.print("Rolling rarity (+"..rarMod..") and quality (+"..qtyMod.."): "..rar..", "..qty);
        return rar, qty;
    }
}
