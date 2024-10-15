extend class RandomizedArmor {
	override void Touch(Actor toucher)
	{
        return;
    }

    void rwTouch(Actor toucher)
	{
        let plrInfo = toucher.player;
		if (plrInfo)
		{
            let plrActor = RwPlayer(toucher);
            plrActor.PickUpArmor(self);
            onPickup(toucher);
		}
    }

    void onPickup(Actor toucher) {
        let player = toucher.player;
        DoPickupSpecial(toucher);
        AttachToOwner(toucher);
        if (PickupFlash != NULL) {
            Spawn(PickupFlash, Pos, ALLOW_REPLACE);
        }
        if (bCountItem)
		{
			if (player != NULL)
			{
				player.itemcount++;
			}
			level.found_items++;
		}

		if (bCountSecret)
		{
			Actor ac = player != NULL? Actor(player.mo) : toucher;
			ac.GiveSecret(true, true);
		}
    }
}
