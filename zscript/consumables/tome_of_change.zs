class TomeOfChange : RwStoredConsumable {
	Default
	{
		Inventory.Pickupmessage "Tome of change!";
		// +INVENTORY.ALWAYSPICKUP - should be false
		+FLOATBOB
		-COUNTITEM
		RwStoredConsumable.RwBaseMaxAmount 2;
		Inventory.Icon "FTINA0";
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
			let colorCode = RaritiesHelper.getRarityColorCode(AffixableDetector.getRarityOfAffixableItem(usedOn));
			if (usedOnWeaponInHands) {
				plr.A_Print("Use Tome of Change again to apply it to\n"
					..colorCode..AffixableDetector.GetNameOfAffixableItem(usedOn)
					.."\nin your hands", USAGE_CONFIRMATION_SECONDS);
			} else {
				plr.A_Print("Use Tome of Change again to apply it to\n"
					..colorCode..AffixableDetector.GetNameOfAffixableItem(usedOn)
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
				printUseResultMessage("weapon", affixToRemove, newAffix);
				return true;
			}
			plr.A_Print("This weapon can't be altered");
			return false;
		}
		if (usedOn is "RwArmor") {
			[affixToRemove, newAffix] = RwArmor(usedOn).replaceRandomAffixWithRandomAffix();
			if (affixToRemove) {
				printUseResultMessage("armor", affixToRemove, newAffix);
				return true;
			}
			plr.A_Print("This armor can't be altered");
			return false;
		}
		if (usedOn is "RwBackpack") {
			[affixToRemove, newAffix] = RwBackpack(usedOn).replaceRandomAffixWithRandomAffix();
			if (affixToRemove) {
				printUseResultMessage("bag", affixToRemove, newAffix);
				return true;
			}
			plr.A_Print("This backpack can't be altered");
			return false;
		}
		if (usedOn is "RwFlask") {
			[affixToRemove, newAffix] = RwFlask(usedOn).replaceRandomAffixWithRandomAffix();
			if (affixToRemove) {
				printUseResultMessage("glass", affixToRemove, newAffix);
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

	private void printUseResultMessage(string itemName, Affix oldAff, Affix newAff) {
		string wholeLineColorCode;
		string oldAffColorCode = "\ca";
		string oldAffLine = oldAffColorCode..oldAff.getName();
		string changeLine;
		string newAffColorCode;
		switch (newAff.getAlignment()) {
			case -1:
				wholeLineColorCode = "\cx";
				changeLine = "now bears the burden of ";
				newAffColorCode = "\cr";
				break;
			case 0:
				wholeLineColorCode = "\cc";
				changeLine = "is transmuted with ";
				newAffColorCode = "\cf";
				break;
			case 1:
				wholeLineColorCode = "\cv";
				changeLine = "is now blessed with ";
				newAffColorCode = "\cf";
				break;
		}
		owner.A_Print(
			wholeLineColorCode.."The "..itemName.." that once was cursed with "..oldAffLine.."\n"..
			wholeLineColorCode..changeLine..newAffColorCode..newAff.getName().."ness",
			5
		);
	}
}
