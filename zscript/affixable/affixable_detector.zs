// TODO: rename this, it's more than just a detector now.
class AffixableDetector {

    static bool IsAffixableItem(Actor a) {
        return (a is 'RwWeapon') || (a is 'RwArmor') || (a is 'RwBackpack') || (a is 'RwFlask');
    }

    static string GetNameOfAffixableItem(Actor a) {
        if (a is "RwWeapon") {
			return RwWeapon(a).nameWithAppliedAffixes;
		}
		if (a is "RwArmor") {
			return RwArmor(a).nameWithAppliedAffixes;
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