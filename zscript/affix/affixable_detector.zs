class AffixableDetector {
    static bool IsAffixableItem(Actor a) {
        return (a is 'RandomizedWeapon') || (a is 'RandomizedArmor') || (a is 'RwBackpack');
    }
}