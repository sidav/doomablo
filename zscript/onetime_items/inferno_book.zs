class InfernoBook : Inventory {
	Default
	{
		Inventory.Pickupmessage "Tome of knowledge!";
		// +INVENTORY.ALWAYSPICKUP - should be false
		Inventory.Amount 1;
		Inventory.MaxAmount 5;
		Inventory.InterHubAmount 5;
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
			plr.A_Print(GetUseMessage(plr.infernoLevel + 1));
			plr.infernoLevel = min(plr.infernoLevel + 1, plr.maxInfernoLevel);
			plr.GiveBody(plr.stats.GetMaxHealth()/4, 2*plr.stats.GetMaxHealth()); // Heal the player
			return true;
        }
		return false;
	}

	virtual string GetUseMessage(int newInfernoLevel) {
		let plr = RwPlayer(owner);
		if (plr) {
			if (newInfernoLevel > plr.maxInfernoLevel) {
				return "The Final Seal is broken. This is the edge of oblivion.";
			} else {
				return "Inferno level "..newInfernoLevel..": "..plr.GetFluffNameForInfernoLevel(newInfernoLevel);
			}
        }
		return "If you see this message, it's a bug.";
	}
}
