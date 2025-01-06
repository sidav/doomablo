extend class DropsHandler {

    const minProgItemsPerLevel = 2;
    const maxProgItemsPerLevel = 4;
    // Those two should reset each level, because DropsHandler is not a StaticEventHandler
    int guarateedProgDropsCount;
    int nonguaranteedProgDropsCount;

    void MaybeDropProgressionItem(Actor dropper, int dropperRarity) {
        if (guarateedProgDropsCount >= maxProgItemsPerLevel) return; // Drop nothing if already enough

        let dropGuaranteed = rollGuaranteedProgDrop();
        let dropNonGuaranteed = rollNonguaranteedProgDrop(dropper, dropperRarity);

        if (dropGuaranteed || dropNonGuaranteed) {
            let spawnedItem = DropsSpawner.createDropByClass(dropper, 'InfernoBook');
            AssignSpreadVelocityTo(spawnedItem);
            if (dropGuaranteed) {
                // debug.print("Guaranteed drop");
                guarateedProgDropsCount++;
            } else {
                // debug.print("Non-guaranteed drop");
                nonguaranteedProgDropsCount++;
            }
        }
    }

    bool rollGuaranteedProgDrop() {
        if (guarateedProgDropsCount >= minProgItemsPerLevel) {
            return false; // Guaranteed amount already dropped
        }
        // Guaranteed amount not yet dropped:
        let guaranteedDropEachKills = level.Total_Monsters / minProgItemsPerLevel; // GDEK for short in the comments below
        if (guaranteedDropEachKills == 0) return true; // Kinda resolves the problem of levels with too few monsters.

        // Drop only one guaranteed item each "GDEK" killed monsters. Prevents getting all the guaranteed items from the very first monsters.
        if (level.Killed_Monsters / guaranteedDropEachKills < guarateedProgDropsCount) {
            return false;
        }

        let odds = 1 + guaranteedDropEachKills - (level.Killed_Monsters % guaranteedDropEachKills);
        return rnd.OneChanceFrom(odds);
    }

    bool rollNonguaranteedProgDrop(Actor dropper, int dropperRarity) {
        if (nonguaranteedProgDropsCount >= maxProgItemsPerLevel - minProgItemsPerLevel) {
            return false;
        }
        switch (dropperRarity) {
            case 0:
                return rnd.OneChanceFrom(math.getIntPercentage(level.Total_Monsters, 300));
            case 1:
                return rnd.OneChanceFrom(math.getIntPercentage(level.Total_Monsters, 100));
            case 2:
                return rnd.OneChanceFrom(math.getIntPercentage(level.Total_Monsters, 50) + 1);
            case 3:
                return rnd.OneChanceFrom(math.getIntPercentage(level.Total_Monsters, 25) + 1);
            case 4:
                return rnd.OneChanceFrom(2);
            case 5:
                return rnd.OneChanceFrom(1);
        }
        return false;
    }

}