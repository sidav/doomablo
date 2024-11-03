class DropsHandler : EventHandler
{

    mixin AffixableGenerationHelperable;
    mixin DropSpreadable;

    override void WorldThingDied(WorldEvent e) {
        // Don't spawn items from barrels or from enemies which aren't counted as kills
        if (e.Thing is 'ExplosiveBarrel' || !e.Thing.bCOUNTKILL) {
            return;
        }
        // debug.print("Actor "..e.Thing.GetClassName().." died; max health is "..e.Thing.GetMaxHealth());
        let dropperRarity = 0;
        if (e.Thing.FindInventory('RwMonsterAffixator') != null) {
            dropperRarity = RwMonsterAffixator(e.Thing.FindInventory('RwMonsterAffixator')).AppliedAffixes.Size();
        }
        let dropsCount = DropsDecider.decideDropsCount(e.Thing.GetMaxHealth(), dropperRarity);
        for (let i = 0; i < dropsCount; i++) {
            createDrop(e.Thing, dropperRarity);
        }
    }

    private void createDrop(Actor dropper, int dropperRarity) {
        let whatToDrop = DropsDecider.whatToDrop(dropper.GetMaxHealth(), dropperRarity);

        bool unused; // Required by zscript syntax for multiple returned values; is indeed unused
        Actor spawnedItem;

        switch (whatToDrop) {
            case 0: 
                spawnedItem = DropsSpawner.SpawnRandomOneTimeItemDrop(dropper);
                break;
            case 1:
                spawnedItem = DropsSpawner.SpawnRandomAmmoDrop(dropper);
                break;
            case 2:
                if (RwPlayer(Players[0].mo).ProgressionEnabled()) {
                    spawnedItem = DropsSpawner.SpawnRandomProgressionItemDrop(dropper);
                } else {
                    spawnedItem = DropsSpawner.SpawnRandomOneTimeItemDrop(dropper);
                }
                break;
            case 3:
                spawnedItem = DropsSpawner.SpawnRandomRWArtifactItemDrop(dropper);
                break;
            default:
                debug.panic("I don't know what drop type it is: "..whatToDrop);
        }

        if (spawnedItem) {            
            // Generate stats/affixes for the spawned item.
            if (AffixableDetector.IsAffixableItem(spawnedItem)) {

                int rarmod, qtymod;
                [rarmod, qtymod] = DropsDecider.rollRarQtyModifiers(dropper.GetMaxHealth(), dropperRarity);
                int rar, qty;
                [rar, qty] = DropsDecider.rollRarityAndQuality(rarmod, qtymod);

                GenerateAffixableItem(spawnedItem, rar, qty);
            }
        }
        AssignSpreadVelocityTo(spawnedItem); // Add random speed for the spawned item.
        return;
    }
}