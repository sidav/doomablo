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
		PLSS AB 6 Bright;
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
	}
	States
	{
	Spawn:
		PLS1 AB 6 Bright;
		Loop;
	Death:
		PLS1 CDEFG 4 Bright;
		Stop;
	}
}
	
class RwPlasmaBall2 : RwPlasmaBall1
{
	States
	{
	Spawn:
		PLS2 AB 6 Bright;
		Loop;
	Death:
		PLS2 CDE 4 Bright;
		Stop;
	}
}
