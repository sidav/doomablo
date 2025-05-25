class RwBlasterBall : RwProjectile {
    Default {
        Radius 8;
        Height 6;
        Speed 30;
        Projectile;
        +RANDOMIZE;
        +ZDOOMTRANS;
        RenderStyle "Add";
        Alpha 0.6;
        SeeSound "weapons/plasmaf";
        DeathSound "weapons/plasmax";
        Obituary "$OB_MPBLASTER";
    }
    
    states {
        Spawn:
            BOLT A 4 Bright RWA_SeekerMissile();
            Loop;
        Death:
            BOLT BCDEF 3 Bright;
            Stop;
    }
}