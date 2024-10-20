class RwMiniRocket : RwProjectile
{
	Default
	{
		Scale 0.4;
		Radius 5;
		Height 3;
		Speed 20;
		Projectile;
		+RANDOMIZE
		+DEHEXPLOSION
		+ROCKETTRAIL
		+ZDOOMTRANS
		// SeeSound "weapons/rocklf";
		DeathSound "weapons/rocklx";
		Obituary "$OB_MPROCKET";
	}
	States
	{
	Spawn:
		MISL A 1 Bright;
		Loop;
	Death:
		MISL B 8 Bright rwExplode();
		MISL C 6 Bright;
		MISL D 4 Bright;
		Stop;
	BrainExplode:
		MISL BC 10 Bright;
		MISL D 10 A_BrainExplode;
		Stop;
	}
}