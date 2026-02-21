class RwStoredConsumable : Inventory abstract {

    int rBaseMaxAmount; // max amount not counting the player stats.
    Property RwBaseMaxAmount : rBaseMaxAmount;

    Default
	{
		Inventory.Amount 1;
		Inventory.MaxAmount 1000;
		Inventory.InterHubAmount 1000;
        RwStoredConsumable.RwBaseMaxAmount 10;

		-Inventory.AUTOACTIVATE
		+INVENTORY.INVBAR
		+BRIGHT
	}

    override bool CanPickup(Actor toucher) {
        let plr = RwPlayer(toucher);
        if (plr == null) return false;
        let sameItemInInv = plr.findInventory(self.getClass());
        if (sameItemInInv == null) return true;
        return plr.stats.getMaxInvItemAmount(rBaseMaxAmount) > sameItemInInv.Amount;
	}
}