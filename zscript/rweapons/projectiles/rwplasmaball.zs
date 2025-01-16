class RwPlasmaBall : RwProjectile
{
	Default
	{
		Radius 13;
		Height 8;
		Speed 25;
		Projectile;
		+RANDOMIZE
		+ZDOOMTRANS
		RenderStyle "Add";
		Alpha 0.75;
		SeeSound "weapons/plasmaf";
		DeathSound "weapons/plasmax";
		Obituary "$OB_MPPLASMARIFLE";
	}
	States
	{
	Spawn:
		PLSS AB 6 Bright RWA_SeekerMissile();
		Loop;
	Death:
		PLSE ABCDE 4 Bright;
		Stop;
	}
}

class RwPlasmaBall1 : RwProjectile
{
	Default
	{
		Radius 13;
		Height 8;
		Speed 25;
		Projectile;
		+RANDOMIZE
		+ZDOOMTRANS
		RenderStyle "Add";
		Alpha 0.75;
		BounceType "Classic";
		BounceFactor 1.0;
		Obituary "$OB_MPBFG_MBF";
		Seesound "BetaBall/Fire";
	}
	States
	{
	Spawn:
		BBGB AB 6 Bright RWA_SeekerMissile();
		Loop;
	Death:
		BBGB CDE 4 Bright;
		Stop;
	}
}
	
class RwPlasmaBall2 : RwPlasmaBall1
{
	States
	{
	Spawn:
		BBG2 AB 6 Bright RWA_SeekerMissile();
		Loop;
	Death:
		BBG2 CDEFGH 4 Bright;
		Stop;
	}
}
