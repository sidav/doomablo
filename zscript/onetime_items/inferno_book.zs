class InfernoBook : Inventory {
	Default
	{
		Inventory.Pickupmessage "Tome of knowledge!";
		// +INVENTORY.ALWAYSPICKUP - should be false
		Inventory.Amount 1;
		Inventory.MaxAmount 5;
		Inventory.Icon "TOMEG0";
		-Inventory.AUTOACTIVATE
		+INVENTORY.INVBAR
		+BRIGHT
	}
	States
	{
	Spawn:
		TOME ABCDEFGH 5;
		loop;
	}

	override bool CanPickup(Actor toucher) {
		return RwPlayer(toucher) != null;
	}

	override bool Use(bool pickup) {
		let plr = RwPlayer(owner);
		if (plr) {
			plr.A_PrintBold(GetUseMessage(plr.infernoLevel + 1));
			plr.infernoLevel = min(plr.infernoLevel + 1, plr.maxInfernoLevel);
			plr.GiveBody(25, 200); // Heal the player
			return true;
        }
		return false;
	}

	virtual string GetUseMessage(int newInfernoLevel) {
		let plr = RwPlayer(owner);
		if (plr) {
			switch (newInfernoLevel) {
			case plr.maxInfernoLevel+1:
				return "The Final Seal is broken. This is the edge of oblivion.";
			case 100:
				return "Inferno level 100: Apotheosis of Abaddon";
			case 75:
				return "Inferno level 75: The Eternal Malevolence";
			case 66:
				return "Inferno level 66: The Ascension of Anathema";
			case 50:
				return "Inferno level 50: The Crescendo of Gehennah";
			case 25:
				return "Inferno level 25: Hellbound Ascension";
			case 10:
				return "Inferno level 10: Tide of Malevolence";
			default:
				return "Inferno level increased to "..newInfernoLevel;
			}
        }
		return "If you see this message, it's a bug.";
	}
}
