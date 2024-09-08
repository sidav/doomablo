class PressToPickupHandler : EventHandler {

    Inventory currentItemToPickUp;
    int ticksSinceLastCheck;
    int manualPickupCooldown;
    const CHECKINTERVAL = 7;
    const PICKUPINTERVAL = 35;
    const PICKUPDISTFAC = 1.5;

    override void WorldTick() {
        if (manualPickupCooldown > 0) {
            manualPickupCooldown--;
        } else {
            // Check if button is pressed
            if (currentItemToPickUp && players[0].mo && (players[0].cmd.buttons & BT_USE)) {
                RandomizedWeapon(currentItemToPickUp).rwTouch(players[0].mo);
                manualPickupCooldown = PICKUPINTERVAL;
            }
        }

        if (ticksSinceLastCheck < CHECKINTERVAL || ticksSinceLastCheck % CHECKINTERVAL != 0) {
            ticksSinceLastCheck++;
            return;
        }
        ticksSinceLastCheck = 0;

        let source =  players[0].mo;
        currentItemToPickUp = GetClosestPickUp(source);
    }

    Inventory GetClosestPickUp(Actor source) {
        double dist = source.radius * 2 * PICKUPDISTFAC;
        Inventory currClosestPickup = null;

		BlockThingsIterator it = BlockThingsIterator.Create(source, dist);
        while(it.Next()) {

            let itm = Inventory(it.thing);
			if (!itm || itm.bNOSECTOR || itm.owner)
				continue;

            if (!RandomizedWeapon(itm))
                continue;

            let newDist = source.Distance3D(it.thing);
            if (newDist < dist) {
                currClosestPickup = itm;
            }
        }
        return currClosestPickup;
    }

}
