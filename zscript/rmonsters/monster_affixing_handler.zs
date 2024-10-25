// Handles the replacement of default weapons/items. 
class MonstersAffixingHandler : EventHandler
{

	override void WorldThingSpawned(worldEvent e) {
		let mo = e.thing;
		if (!(mo && mo.bIsMonster)) {
            return;
        }

        int rarmod, qtymod;
        [rarmod, qtymod] = rollRarQtyModifiers(mo.health);
        int rar, qty;
        [rar, qty] = rollRarityAndQuality(rarmod, qtymod);

        if (rar == 0) {
            return; // We don't need to give the affixator to monster with zero rarity
        }

        // debug.print("Giving the affixator to "..mo.GetClassName());
        // debug.print(String.format("       Rar %d qty %d; rarmod %d, qtymod %d", rar, qty, rarmod, qtyMod));
        let given = RwMonsterAffixator(mo.GiveInventoryType('RwMonsterAffixator'));
        given.Generate(rar, qty);
	}

    static int, int rollRarQtyModifiers(int monsterHealth) {
        int rarmod, qtymod;
        if (monsterHealth >= 1000) {
            rarmod = rnd.weightedRand(0, 50, 10, 5, 2, 1);
            qtymod = rnd.rand(1, 5);
        } else if (monsterHealth >= 500) {
            rarmod = rnd.weightedRand(10, 3, 1);
            qtymod = rnd.rand(1, 3);
        } else if (monsterHealth >= 250) {
            rarmod = rnd.weightedRand(10, 1);
            qtymod = rnd.rand(0, 1);
        }
        return rarmod, qtymod;
    }

    static int, int rollRarityAndQuality(int rarMod, int qtyMod) {
        // Roll rarity
        let rar = rnd.weightedRand(1000, 250, 60, 15, 4, 1);
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
