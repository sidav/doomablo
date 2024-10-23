// Handles the replacement of default weapons/items. 
class MonstersAffixingHandler : EventHandler
{

	override void WorldThingSpawned(worldEvent e) {
		let mo = e.thing;
		if (!mo.bIsMonster) {
            return;
        }

        let given = RwMonsterAffixator(mo.GiveInventoryType('RwMonsterAffixator'));
        given.Generate(rnd.rand(0, 2), rnd.rand(1, 100));
	}
}
