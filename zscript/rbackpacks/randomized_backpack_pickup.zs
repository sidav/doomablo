extend class RwBackpack {
    mixin DropSpreadable;

    // TODO: move it to affixable?
    override void Touch(Actor toucher) {
        return;
    }

    void rwTouch(Actor toucher)
	{
        let plrInfo = toucher.player;
		if (plrInfo)
		{
            let plrActor = MyPlayer(toucher);
            plrActor.PickUpBackpack(self);
            onPickup(toucher);
		}
    }

    const dropChunkSize = 10;
    void OnPickup(in out Actor toucher) {
        DoPickupSpecial(toucher);
        AttachToOwner(toucher);
		toucher.SetAmmoCapacity('Clip', stats.maxBull);
        toucher.SetAmmoCapacity('Shell', stats.maxShel);
        toucher.SetAmmoCapacity('Rocketammo', stats.maxRckt);
        toucher.SetAmmoCapacity('Cell', stats.maxCell);

        // Drop excessive ammo:
        bool unused;
        let invlist = toucher.Inv;
        while(invlist != null) {
			let toReduce = Ammo(invlist);
            if (toReduce && toReduce.Amount > GetAmmoCapacity(toReduce.GetClass())) {
                let capacity = GetAmmoCapacity(toReduce.GetClass());
                let difference = toReduce.Amount - capacity;

                toReduce.Amount = capacity;

                while (difference > 0) {
                    Actor dropped;
                    [unused, dropped] = toucher.A_SpawnItemEx(toReduce.GetClass());
                    Inventory(dropped).Amount = min(difference, dropChunkSize);
                    difference -= dropChunkSize;
                    AssignSpreadVelocityTo(dropped);
                }
            }
            invlist=invlist.Inv;
        }
	}

    override void DetachFromOwner ()
	{
		// When removing a backpack, drop the player's ammo maximums to normal
		if (MyPlayer(owner)) {
            MyPlayer(owner).ResetMaxAmmoToDefault();
        }
	}
}
