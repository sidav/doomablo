// TODO: rename this, it's more than just a detector now.
class AffixableDetector {

    static bool IsAffixableItem(Actor a) {
        return (a is 'RandomizedWeapon') || (a is 'RandomizedArmor') || (a is 'RwBackpack') || (a is 'RwFlask');
    }

    static string GetNameOfAffixableItem(Actor a) {
        if (a is "RandomizedWeapon") {
			return RandomizedWeapon(a).nameWithAppliedAffixes;
		}
		if (a is "RandomizedArmor") {
			return RandomizedArmor(a).nameWithAppliedAffixes;
		}
		if (a is "RwBackpack") {
			return RwBackpack(a).nameWithAppliedAffixes;
		}
		if (a is "RwFlask") {
			return RwFlask(a).nameWithAppliedAffixes;
		}
        return "<ERROR DETECTING NAME>";
    }
}