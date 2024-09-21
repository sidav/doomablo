class PressToPickupHandler : EventHandler {

    Inventory currentItemToPickUp;
    int ticksSinceLastCheck;
    int manualPickupCooldown;
    const CHECK_PERIOD = 7;
    const PICKUP_DELAY = 35;
    const PICKUP_DISTANCE_FACTOR = 3.0;
    const PICKUP_X_ANGLE = 26.0;
    const PICKUP_Y_ANGLE = 24.0;

    override void WorldTick() {
        if (manualPickupCooldown > 0) {
            manualPickupCooldown--;
        } else {
            // Check if button is pressed
            if (currentItemToPickUp && players[0].mo && (players[0].cmd.buttons & BT_USE)) {
                if (RandomizedWeapon(currentItemToPickUp)) {
                    RandomizedWeapon(currentItemToPickUp).rwTouch(players[0].mo);
                } else if (RandomizedArmor(currentItemToPickUp)) {
                    RandomizedArmor(currentItemToPickUp).rwTouch(players[0].mo);
                }
                manualPickupCooldown = PICKUP_DELAY;
            }
        }

        if (ticksSinceLastCheck < CHECK_PERIOD || ticksSinceLastCheck % CHECK_PERIOD != 0) {
            ticksSinceLastCheck++;
            return;
        }
        ticksSinceLastCheck = 0;

        let source =  players[0].mo;
        currentItemToPickUp = GetClosestAimedPickUp(source);
    }

    Inventory GetClosestAimedPickUp(Actor source) {
        double dist = source.radius * PICKUP_DISTANCE_FACTOR;
        Inventory currClosestPickup = null;
        double closestAngle = double.infinity;

		BlockThingsIterator it = BlockThingsIterator.Create(source, dist);
        while(it.Next()) {

            let itm = Inventory(it.thing);
			if (!itm || itm.bNOSECTOR || itm.owner)
				continue;

            if (!RandomizedWeapon(itm) && !RandomizedArmor(itm))
                continue;

            let newDist = source.Distance3D(it.thing);
            if (newDist >= dist) {
                continue;
            }

            if (!source.CheckSight(itm, SF_IGNOREWATERBOUNDARY))
				continue;

            // Check if the player looks at the item
            double playerZCorrection = source.height * 0.5 - source.floorclip + source.player.mo.AttackZOffset*source.player.crouchFactor;
			Vector3 viewVector = Level.SphericalCoords(
                source.pos + (0, 0, playerZCorrection), // player line of fire origin
                itm.pos + (0, 0, itm.height * 0.5), // middle of the object
                (source.angle, source.pitch)
            );
            if (abs(viewVector.x) > PICKUP_X_ANGLE || abs(viewVector.y) > PICKUP_Y_ANGLE || viewVector.z > dist) {
                continue;
            }
			double lookAngle = min(viewVector.x, viewVector.y);
			if (lookAngle < closestAngle)
			{
				currClosestPickup = itm;
			}

        }
        return currClosestPickup;
    }
}
