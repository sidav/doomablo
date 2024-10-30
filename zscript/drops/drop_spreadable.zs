mixin class DropSpreadable {

    // Add random speed for the actor (mostly used for "drop spread").
    static play void AssignSpreadVelocityTo(Actor a) {
        a.Vel3DFromAngle(rnd.randf(8.0, 10.0), rnd.randf(1.0, 360.0), rnd.randf(-80.0, -60.0));
    }

    static play void AssignMinorSpreadVelocityTo(Actor a) {
        a.Vel3DFromAngle(rnd.randf(4.0, 7.0), rnd.randf(0.0, 360.0), rnd.randf(-80.0, -60.0));
    }

    static play void AssignMajorSpreadVelocityTo(Actor a) {
        a.Vel3DFromAngle(rnd.randf(10.0, 15.0), rnd.randf(0.0, 360.0), rnd.randf(-70.0, -60.0));
    }

    static play void AssignVeryMinorSpreadVelocityTo(Actor a) {
        a.Vel3DFromAngle(rnd.randf(2.0, 4.0), rnd.randf(0.0, 360.0), rnd.randf(-80.0, -60.0));
    }

}