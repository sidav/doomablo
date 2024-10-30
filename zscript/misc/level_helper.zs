class LevelHelper {

    const tries = 1000;

    static Vector3 GetRandomCoordinatesInLevelAtRangeFrom(double range, Vector3 origin) {
        Vector3 result = (0, 0, 0);
        for (let i = 0; i < tries; i++) {
            let x = origin.X + rnd.randf(-range, range);
            let y = origin.Y + rnd.randf(-range, range);
            if (level.isPointInLevel( (x, y, origin.Z) )) {
                let sector = level.pointInSector((x, y));
                if (sector) {
                    result = (x, y, sector.floorplane.ZAtPoint( (x, y) ));
                    break;
                }
            }
        }
        return result;
    }

    static play bool TryMoveActorToRandomCoordsInRangeFrom(Actor act, double minRange, double maxRange, Vector3 origin) {
        let originalOrigin = act.Pos;
        for (let i = 0; i < tries; i++) {
            let newOrigin = GetRandomCoordinatesInLevelAtRangeFrom(maxRange, origin);

            // TODO: use better (two-range) random, it will be faster
            if ((originalOrigin - newOrigin).Length() < minRange) {
                continue;
            }

            act.SetOrigin(newOrigin, false);
            if (act.TestMobjLocation()) {
                return true;
            }
        }
        act.SetOrigin(originalOrigin, false);
        return false;
    }

}