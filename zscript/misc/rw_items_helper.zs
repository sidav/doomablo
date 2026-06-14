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
}