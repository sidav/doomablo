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
        let dropsCount = LootResolver.decideDropsCount(GetDropperUnscaledHealth(e.Thing), dropperRarity);
        for (let i = 0; i < dropsCount; i++) {
            createDrop(e.Thing, dropperRarity);
        }
    }

    private void createDrop(Actor dropper, int dropperRarity) {
        // Generate rarity before the item itself, because unique rarity (be it selected) requires different logic
        int rar = LootResolver.rollRarityForMonsterDrop(
            LootResolver.rollRarityModifierForMonsterDrop(GetDropperUnscaledHealth(dropper), dropperRarity)
        );

        let whatToDrop = LootResolver.whatToDrop(GetDropperUnscaledHealth(dropper), dropperRarity);

        Actor spawnedItem;
        switch (whatToDrop) {
            case 0: 
                spawnedItem = DropsSpawner.SpawnRandomConsumableDrop(dropper);
                break;
            case 1:
                spawnedItem = DropsSpawner.SpawnRandomAmmoDrop(dropper);
                break;
            case 2:
                spawnedItem = DropsSpawner.SpawnRandomRWArtifactItemDrop(dropper, rar == RaritiesHelper.UNIQUE_RARITY);
                break;
            default:
                debug.warning("I don't know what drop type it is: "..whatToDrop);
                return;
        }

        if (spawnedItem) {            
            // Generate stats/affixes for the spawned item.
            if (AffixableDetector.IsAffixableItem(spawnedItem)) {
                // If non-unique item was created for unique rarity, lower the applied rarity.
                if (rar == RaritiesHelper.UNIQUE_RARITY && !RwItemsHelper.isUniqueItem(spawnedItem))
                    rar--;

                int qty = 1;
                // Make the drop level equal to the droppers' level
                if (dropper.FindInventory('RwMonsterAffixator') != null) {
                    qty = GetDropperGeneratedLevel(dropper);
                } else {
                    debug.warning("Drop from non-affixed monster detected!");
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