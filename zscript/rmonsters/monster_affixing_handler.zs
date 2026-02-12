// Handles the replacement of default weapons/items. 
class MonstersAffixingHandler : EventHandler
{

    bool maxRarityWarningPrinted;

	override void WorldThingSpawned(worldEvent e) {
		let mo = e.thing;
		if (!(mo && mo.bIsMonster)) {
            return;
        }

        if (level.maptime > TICRATE) {
            return; // Affixate only map-placed monsters.
        }

        int rarmod = rollRarityModifier(mo.health);
        int rar, qty;
        [rar, qty] = rollRarityAndQuality(rarmod);

        // debug.print("Giving the affixator to "..mo.GetClassName());
        // debug.print(String.format("       Rar %d qty %d;", rar, qty));
        RwMonsterAffixator.AffixateMonster(mo, rar, qty);
        if (rar > 3 && !maxRarityWarningPrinted) {
            if (rar == 5) maxRarityWarningPrinted = true;
            warnPlayerOfRareMonster(mo, rar);
        }
	}

    static int rollRarityModifier(int monsterHealth) {
        int rarmod;
        if (monsterHealth >= 1000) {
            rarmod = rnd.weightedRand(20, 10, 2);
        } else if (monsterHealth >= 500) {
            rarmod = rnd.weightedRand(20, 5, 1);
        } else if (monsterHealth >= 250) {
            rarmod = rnd.weightedRand(20, 1);
        }
        return rarmod;
    }

    static int, int rollRarityAndQuality(int rarMod) {
        // Roll rarity
        let rar = rnd.weightedRand(7060, 2017, 706, 202, 10, 5);
        rar = clamp(rar+rarMod, 0, RaritiesHelper.MAX_RARITY);

        // Get quality (= monster level) from inferno level
        int qty = 1;
        let plr = RwPlayer(Players[0].mo);
        if (plr) {
            qty = plr.rollForDropLevel();
        } else {
            debug.print("Non-player quality roll!");
            qty = rnd.linearWeightedRand(1, 100, 100, 1);
        }
        qty = clamp(qty, 1, 100);

        // debug.print("Rolling rarity (+"..rarMod..") and quality (+"..qtyMod.."): "..rar..", "..qty);
        return rar, qty;
    }

    void warnPlayerOfRareMonster(Actor mo, int rarity) {
        let affixator = RwMonsterAffixator.GetMonsterAffixator(mo);
        let messageIndex = Random(0, 5);
        mo.A_PrintBold(
            String.Format(
                Stringtable.Localize("$RAREMONSTERSPAWNED"..messageIndex),
                "\ca",
                "\n"..RaritiesHelper.getRarityColorCode(rarity)..affixator.assignedName.."\n"
            ),
            5.0,
            "SMALLFONT");
            // "CONFONT");
    }
}
