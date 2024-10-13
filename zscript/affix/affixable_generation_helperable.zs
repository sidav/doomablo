mixin class AffixableGenerationHelperable {

    static void GenerateAffixableItem(Actor aItem, int rarity, int quality) {
        if (aItem is 'RandomizedWeapon') {
            RandomizedWeapon(aItem).Generate(rarity, quality);
        } else if (aItem is 'RandomizedArmor') {
            RandomizedArmor(aItem).Generate(rarity, quality);
        } else if (aItem is 'RwBackpack') {
            RwBackpack(aItem).Generate(rarity, quality);
        } else {
            debug.panic("Unknown affixable item "..aItem.GetClassName());
        }
    }
}