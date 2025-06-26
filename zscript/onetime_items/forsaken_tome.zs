class ForsakenTome : Inventory {
	Default
	{
		Inventory.Pickupmessage "Tome of change!";
		// +INVENTORY.ALWAYSPICKUP - should be false
		+FLOATBOB
		-COUNTITEM
		Inventory.Amount 1;
		Inventory.MaxAmount 1;
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

	override bool CanPickup(Actor toucher) {
		return RwPlayer(toucher) != null;
	}

	override bool Use(bool pickup) {
		let plr = RwPlayer(owner);
		if (!plr) {
			return false;
        }
		let currWeapon = RandomizedWeapon(Players[0].ReadyWeapon);
		if (!currWeapon) {
			plr.A_Print("This weapon can't be absolved");
			return false;
		}

		string usageStr;
		Affix affixToRemove, newAffix;
		[affixToRemove, newAffix] = currWeapon.replaceRandomAffixWithRandomAffix();

		if (affixToRemove) {
			plr.A_Print("What once was cursed with "..affixToRemove.getName().."\n"
					    .."now bears the burden of "..newAffix.getName().."ness");
			return true;
		}
		plr.A_Print("This weapon can't be absolved");
		return false;
	}
}
