class CurrentTargetHandler : EventHandler {

    Actor currentTargetMonster;
    RwMonsterAffixator currentMonsterAffixator;

    int ticksSinceLastCheck;
    const CHECK_PERIOD = 7;
    const CHECK_DISTANCE = 1024;
    const PICKUP_X_ANGLE = 7.0;
    const PICKUP_Y_ANGLE = 10.0;

    override void WorldTick() {
        if (ticksSinceLastCheck < CHECK_PERIOD || ticksSinceLastCheck % CHECK_PERIOD != 1) {
            ticksSinceLastCheck++;
            return;
        }
        ticksSinceLastCheck = 0;

        let source =  players[0].mo;
        currentTargetMonster = UpdateCurrentTarget(source);
        if (currentTargetMonster) {
            currentMonsterAffixator = RwMonsterAffixator(currentTargetMonster.FindInventory('RwMonsterAffixator'));
            // debug.print("Current target monster "..currentTargetMonster.GetClassName());
        } else {
            currentMonsterAffixator = null;
            // debug.print("No current target monster ");
        }
    }

    Actor UpdateCurrentTarget(Actor source) {
        double closestAngle = double.infinity;
        double currDist = CHECK_DISTANCE;
        Actor newTargetMonster = null;

        let ti = ThinkerIterator.Create('Actor');
        Actor act;
        while (act = Actor(ti.next())) {
            if (!act || act.bNOSECTOR || !act.bisMonster || act.Health <= 0 || act == source)
				continue;
            
            let newDist = source.Distance3D(act);
            if (newDist > currDist) {
                continue;
            }
            if (!source.CheckSight(act, SF_IGNOREWATERBOUNDARY))
				continue;

            // Check if the player looks at the monster
            double playerZCorrection = source.height * 0.5 - source.floorclip + source.player.mo.AttackZOffset*source.player.crouchFactor;
			Vector3 viewVector = Level.SphericalCoords(
                source.pos + (0, 0, playerZCorrection), // player line of fire origin
                act.pos + (0, 0, act.height * 0.5), // middle of the object
                (source.angle, source.pitch)
            );

            if (abs(viewVector.x) > PICKUP_X_ANGLE || abs(viewVector.y) > PICKUP_Y_ANGLE || viewVector.z > currDist) {
                continue;
            }
			double lookAngle = min(viewVector.x, viewVector.y);
			if (lookAngle < closestAngle)
			{
				newTargetMonster = act;
                currDist = newDist;
			}
        }
        return newTargetMonster;
    }
}
