mixin class AffixableGenerationHelperable {

    static void GenerateAffixableItem(Actor aItem, int rarity, int quality) {
        if (aItem is 'RwWeapon') {
            RwWeapon(aItem).Generate(rarity, quality);
        } else if (aItem is 'RwArmor') {
            RwArmor(aItem).Generate(rarity, quality);
        } else if (aItem is 'RwBackpack') {
            RwBackpack(aItem).Generate(rarity, quality);
        } else if (aItem is 'RwFlask') {
            RwFlask(aItem).Generate(rarity, quality);
        } else if (aItem is 'RwTurretItem') {
            RwTurretItem(aItem).Generate(rarity, quality);
        } else {
            debug.panic("Unknown affixable item "..aItem.GetClassName());
        }
    }
}