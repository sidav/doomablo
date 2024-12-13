class DropsHandler : EventHandler
{

    mixin AffixableGenerationHelperable;
    mixin DropSpreadable;

    override void WorldThingDied(WorldEvent e) {
        // Don't spawn items from barrels or from enemies which aren't counted as kills
        if (e.Thing is 'ExplosiveBarrel' || !e.Thing.bCOUNTKILL) {
            return;
        }
        // debug.print("Actor "..e.Thing.GetClassName().." died; max health is "..e.Thing.GetMaxHealth().."; unscaled is "..GetDropperUnscaledHealth(e.Thing));
        let dropperRarity = 0;
        if (e.Thing.FindInventory('RwMonsterAffixator') != null) {
            dropperRarity = RwMonsterAffixator(e.Thing.FindInventory('RwMonsterAffixator')).GetRarity();
        }
        MaybeDropProgressionItem(e.Thing, dropperRarity);
        let dropsCount = DropsDecider.decideDropsCount(GetDropperUnscaledHealth(e.Thing), dropperRarity);
        for (let i = 0; i < dropsCount; i++) {
            createDrop(e.Thing, dropperRarity);
        }
    }

    private void createDrop(Actor dropper, int dropperRarity) {
        let whatToDrop = DropsDecider.whatToDrop(GetDropperUnscaledHealth(dropper), dropperRarity);

        Actor spawnedItem;
        switch (whatToDrop) {
            case 0: 
                spawnedItem = DropsSpawner.SpawnRandomOneTimeItemDrop(dropper);
                break;
            case 1:
                spawnedItem = DropsSpawner.SpawnRandomAmmoDrop(dropper);
                break;
            case 2:
                spawnedItem = DropsSpawner.SpawnRandomProgressionItemDrop(dropper);
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
                [rarmod, qtymod] = DropsDecider.rollRarQtyModifiers(GetDropperUnscaledHealth(dropper), dropperRarity);
                int rar, qty;
                [rar, qty] = DropsDecider.rollRarityAndQuality(rarmod, qtymod);
                // Make the drop level equal to the droppers' level
                if (dropper.FindInventory('RwMonsterAffixator') != null) {
                    qty = GetDropperGeneratedLevel(dropper);
                }

                GenerateAffixableItem(spawnedItem, rar, qty);
            }
        }
        AssignSpreadVelocityTo(spawnedItem); // Add random speed for the spawned item.
        return;
    }

    private int GetDropperGeneratedLevel(Actor dropper) {
        if (dropper.FindInventory('RwMonsterAffixator') != null) {
            return RwMonsterAffixator(dropper.FindInventory('RwMonsterAffixator')).generatedQuality;
        }
        return 1;
    }

    private int GetDropperUnscaledHealth(Actor dropper) {
        if (dropper.FindInventory('RwMonsterAffixator') != null) {
            return RwMonsterAffixator(dropper.FindInventory('RwMonsterAffixator')).baseUnscaledOwnerMaxHealth;
        }
        return dropper.GetMaxHealth();
    }
}