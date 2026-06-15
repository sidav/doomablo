class RwRocket : RwProjectile
{
	Default
	{
		Radius 11;
		Height 8;
		Speed 20;
		Projectile;
		+RANDOMIZE
		+DEHEXPLOSION
		+ROCKETTRAIL
		+ZDOOMTRANS
		SeeSound "weapons/rocklf";
		DeathSound "weapons/rocklx";
		Obituary "$OB_MPROCKET";
	}
	States
	{
	Spawn:
		MISL A 1 Bright RWA_SeekerMissile();
		Loop;
	Death:
		EXPL A 3 Bright rwExplode();
		EXPL BCDEF 3 Bright;
		Stop;
	BrainExplode:
		MISL BC 10 Bright;
		MISL D 10 A_BrainExplode;
		Stop;
	}
}