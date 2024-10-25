class LevelHelper {

    static Vector3 GetRandomCoordinatesInLevelAtRangeFrom(double range, Vector3 origin) {
        Vector3 result = (0, 0, 0);
        for (let i = 0; i < 1000; i++) {
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

}