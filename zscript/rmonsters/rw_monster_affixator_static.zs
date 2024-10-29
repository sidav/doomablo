extend class RwMonsterAffixator {
    
    static int GetMonsterRarity(Actor monster) {
        let a = monster.FindInventory('RwMonsterAffixator');
        if (a) {
            return RwMonsterAffixator(a).GetRarity();
        }
        return 0;
    }

    static RwMonsterAffixator GetMonsterAffixator(Actor monster) {
        return RwMonsterAffixator(monster.FindInventory('RwMonsterAffixator'));
    }

    static void AffixateMonster(Actor monster, int rar, int qty) {
        let a = monster.FindInventory('RwMonsterAffixator');
        if (a) {
            debug.panic("Monster "..monster.GetClassName().." is already affixed! Class is "..a.GetClassName());
        }
        if (RwPlayer(monster) || !monster.bIsMonster) {
            debug.panic("Trying to affixate "..monster.GetClassName().." !");
        }
        let given = RwMonsterAffixator(monster.GiveInventoryType('RwMonsterAffixator'));
        given.Generate(rar, qty);
    }
    
}