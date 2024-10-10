mixin class DropSpreadable {

    // Add random speed for the actor (mostly used for "drop spread").
    static void AssignSpreadVelocityTo(Actor a) {
        a.Vel3DFromAngle(rnd.randf(8.0, 10.0), rnd.randf(1.0, 360.0), rnd.randf(-80.0, -60.0));
    }

}