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
            let plrActor = RwPlayer(toucher);
            plrActor.PickUpBackpack(self);
            onPickup(toucher);
		}
    }

    const dropChunkSize = 10;
    void OnPickup(in out Actor toucher) {
        DoPickupSpecial(toucher);
        AttachToOwner(toucher);
		increasePlayerMaxAmmo();

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

    void increasePlayerMaxAmmo() {
        owner.SetAmmoCapacity('Clip', owner.GetAmmoCapacity('Clip') + stats.maxBull);
        owner.SetAmmoCapacity('Shell', owner.GetAmmoCapacity('Shell') + stats.maxShel);
        owner.SetAmmoCapacity('Rocketammo', owner.GetAmmoCapacity('Rocketammo') + stats.maxRckt);
        owner.SetAmmoCapacity('Cell', owner.GetAmmoCapacity('Cell') + stats.maxCell);
    }

    override void DetachFromOwner ()
	{
		// When removing a backpack, drop the player's ammo maximums to normal
		if (RwPlayer(owner)) {
            RwPlayer(owner).ResetMaxAmmoToDefault();
        }
	}
}
