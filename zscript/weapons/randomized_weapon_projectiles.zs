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

class RwFlechette : RwProjectile
{
	Default
	{
		// Scale 0.4;
		Radius 5;
		Height 3;
		Speed 32;
		Projectile;
		+RANDOMIZE
		// +DEHEXPLOSION
		+ROCKETTRAIL
		+ZDOOMTRANS
		// SeeSound "weapons/rocklf";
		// DeathSound "weapons/rocklx";
		// Obituary "$OB_MPROCKET";
	}
	States
	{
	Spawn:
		TNT0 A 1 Bright;
		Loop;
	Death:
		Stop;
	}
}
