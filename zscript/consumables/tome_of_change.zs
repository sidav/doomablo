class TomeOfChange : Inventory {
	Default
	{
		Inventory.Pickupmessage "Tome of change!";
		// +INVENTORY.ALWAYSPICKUP - should be false
		+FLOATBOB
		-COUNTITEM
		Inventory.Amount 1;
		Inventory.MaxAmount 2;
		Inventory.InterHubAmount 1;
		Inventory.Icon "FSTIN";
		-Inventory.AUTOACTIVATE
		+INVENTORY.INVBAR
		+BRIGHT
	}
	States
	{
	Spawn:
		FSTM A 1;
		loop;
	}

	Inventory willBeUsedOn;
	const USAGE_CONFIRMATION_SECONDS = 3;
	int lastTickUsed;

	override bool CanPickup(Actor toucher) {
		return RwPlayer(toucher) != null;
	}

	override bool Use(bool pickup) {
		let plr = RwPlayer(owner);
		if (!plr) {
			return false;
        }

		bool usedOnWeaponInHands = false;
		// First: item the player is looking at
		let usedOn = selectItem();
		// If player looks at no item, try the weapon in hands
		if (usedOn == null) {
			usedOn = Players[0].ReadyWeapon;
			usedOnWeaponInHands = true;
			if (!AffixableDetector.IsAffixableItem(usedOn)) {
				plr.A_Print("Look at the item you want to apply this tome to,\n"..
				 			"then use it to alter item's random bad affix");
				return false;
			}
		}

		// Usage confirmation timeout
		if (lastTickUsed == 0 || Level.MapTime - lastTickUsed > USAGE_CONFIRMATION_SECONDS * TICRATE) {
			willBeUsedOn = null;
		}
		lastTickUsed = Level.MapTime;
		// If used on another item (or timeout is passed)...
		if (usedOn != willBeUsedOn) {
			willBeUsedOn = usedOn;
			if (usedOnWeaponInHands) {
				plr.A_Print("Use Tome of Change again to apply it to\n"
					..AffixableDetector.GetNameOfAffixableItem(usedOn)
					.."\nin your hands", USAGE_CONFIRMATION_SECONDS);
			} else {
				plr.A_Print("Use Tome of Change again to apply it to\n"
					..AffixableDetector.GetNameOfAffixableItem(usedOn)
					.."\nlying before you", USAGE_CONFIRMATION_SECONDS);
			}
			return false;
		}

		// Actually apply on the item
		string usageStr;
		Affix affixToRemove, newAffix;
		if (usedOn is "RwWeapon") {
			[affixToRemove, newAffix] = RwWeapon(usedOn).replaceRandomAffixWithRandomAffix();
			if (affixToRemove) {
				plr.A_Print("The armament that once was cursed with "..affixToRemove.getName().."\n"
							.."now bears the burden of "..newAffix.getName().."ness", 5);
				return true;
			}
			plr.A_Print("This weapon can't be altered");
			return false;
		}
		if (usedOn is "RwArmor") {
			[affixToRemove, newAffix] = RwArmor(usedOn).replaceRandomAffixWithRandomAffix();
			if (affixToRemove) {
				plr.A_Print("The armor that was cursed with "..affixToRemove.getName().."\n"
							.."now bears the burden of "..newAffix.getName().."ness", 5);
				return true;
			}
			plr.A_Print("This armor can't be altered");
			return false;
		}
		if (usedOn is "RwBackpack") {
			[affixToRemove, newAffix] = RwBackpack(usedOn).replaceRandomAffixWithRandomAffix();
			if (affixToRemove) {
				plr.A_Print("The bag that once was cursed with "..affixToRemove.getName().."\n"
							.."now bears the burden of "..newAffix.getName().."ness", 5);
				return true;
			}
			plr.A_Print("This backpack can't be altered");
			return false;
		}
		if (usedOn is "RwFlask") {
			[affixToRemove, newAffix] = RwFlask(usedOn).replaceRandomAffixWithRandomAffix();
			if (affixToRemove) {
				plr.A_Print("The glass that once was cursed with "..affixToRemove.getName().."\n"
							.."now bears the burden of "..newAffix.getName().."ness", 5);
				return true;
			}
			plr.A_Print("This flask can't be altered");
			return false;
		}
		plr.A_Print("You shouldn't see this line, report it please.");
		return false;
	}

	private Inventory selectItem() {
		let itemUnderCrosshair = PressToPickupHandler.GetItemUnderCrosshair();
        if (AffixableDetector.IsAffixableItem(itemUnderCrosshair)) {
            return itemUnderCrosshair;
        }
		return null;
	}
}
