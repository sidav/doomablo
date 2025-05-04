extend class RwMonsterAffixator {
    
    static int GetMonsterRarity(Actor monster) {
        let a = monster.FindInventory('RwMonsterAffixator');
        if (a) {
            return RwMonsterAffixator(a).GetRarity();
        }
        return 0;
    }

    static int GetMonsterLevel(Actor monster) {
        let a = monster.FindInventory('RwMonsterAffixator');
        if (a) {
            return RwMonsterAffixator(a).generatedQuality;
        }
        return 1;
    }

    static RwMonsterAffixator GetMonsterAffixator(Actor monster) {
        if (monster == null) return null;
        return RwMonsterAffixator(monster.FindInventory('RwMonsterAffixator'));
    }

    static void AffixateMonster(Actor monster, int rar, int qty) {
        let a = monster.FindInventory('RwMonsterAffixator');
        if (a) {
            debug.print("Monster "..monster.GetClassName().." is already affixed! Class is "..a.GetClassName());
            return;
        }
        if (RwPlayer(monster) || !monster.bIsMonster) {
            // Just silently skip this entity if it's not actually a monster
            // debug.print("Trying to affixate but "..monster.GetClassName().." is not a monster!");
            return;
        }
        let given = RwMonsterAffixator(monster.GiveInventoryType('RwMonsterAffixator'));
        given.Generate(rar, qty);
    }
    
}
