class RandomMonsterHelper {
    static class <Actor> GetRandomMonsterClassByMaxHp(int maxHp) {
        let handler = MonstersCacheHandler(EventHandler.Find('MonstersCacheHandler'));
        let tries = 0;
        let index = Random(0, handler.monsterClasses.Size() - 1);
        for (tries = 0; tries < 1000; tries++) {
            if (handler.monstersHpPerClass[index] > maxHp) {
                index = (index + 1) % handler.monsterClasses.Size();
            } else {
                return handler.monsterClasses[index];
            }
        }
        debug.print("Unable to find a good monster class with maxHp <= "..maxHp);
        return null;
    }
}

class MonstersCacheHandler : EventHandler {
    array< Class<Actor> > monsterClasses;
    array<int> monstersHpPerClass;

    override void OnRegister() {
        debug.print("===== MONSTER CACHING BEGIN =====");
        // Check all the actor classes
        foreach (cls : AllActorClasses)  {

            let act = GetDefaultByType(cls); // Instantiating to check default values
            string className = act.GetClassName();

            if (act.bIsMonster && act.SpawnState != null) { // If is a monster with spawn state...
                // Check if it's good to spawn (e.g. it has graphic resources loaded; so we won't spawn heretic monster inside Doom
                TextureID spawntex  = act.SpawnState.GetSpriteTexture(0);
                String spawnTexName = TexMan.GetName(spawntex);
                if (spawnTexName.IndexOf("TNT1A0") != -1) continue; // If it's a TNT0 (transparent), skip it
                if (!spawntex.IsValid()) continue;
                if (spawnTexName.IndexOf(""..SpriteID(act.spawnstate.sprite)) == -1) continue;

                // Skip marines and stealth monsters
                if (className.IndexOf("Stealth") != -1) continue;
                if (className.IndexOf("Marine") != -1) continue;

                // All checks passed; it's a spawnable monster.
                monsterClasses.push(cls); // Add class to cache
                monstersHpPerClass.push(act.Health); // Add health to cache
                debug.print("Selected "..act.GetClassName()..String.Format("; is a monster with %d HP.", (act.Health)));
            }
        }
        debug.print("===== MONSTER CACHING END: "..monsterClasses.Size().." CLASSED CACHED =====");
	}
}
