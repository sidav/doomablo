class RwItemsHelper {

    static bool isClassOfUniqueItem(class<Object> cls) {
        return (
            cls is 'RwUniqueWeaponBase' || cls is 'RwUniqueArmorBase'
            // TODO: flasks etc
        );
    }

    static bool isUniqueItem(Actor item) {
        return isClassOfUniqueItem(item.GetClass());
    }

    static int maxRarityForItem(Actor item) {
        if (isUniqueItem(item)) {
            return RaritiesHelper.UNIQUE_RARITY;
        }
        return RaritiesHelper.MYTHIC_RARITY;
    }

    static int minRarityForItem(Actor item) {
        if (isUniqueItem(item)) {
            return RaritiesHelper.UNIQUE_RARITY;
        }
        if (item is 'RwRelic')
            return 1;
        return 0;
    }
}