class RwGlGrenade : RwProjectile
{
	Default
	{
		Radius 6;
		Height 6;
		Scale 0.5;
		Speed 30;
		Gravity 0.5;
		ReactionTime 60; // Life time of the grenade
		BounceType "Grenade";
		BounceFactor 0.5;
		WallBounceFactor 0.5;
		BounceCount 10;

		Projectile;
		-NOGRAVITY
		+BOUNCEAUTOOFFFLOORONLY
		+CANBOUNCEWATER
		+RANDOMIZE
		+DEHEXPLOSION
		+EXTREMEDEATH
		+ZDOOMTRANS
		SeeSound "40mm/grenbounce";
		DeathSound "40mm/grenexplode";
		Obituary "$OB_MPROCKET";
	}
	States
	{
	Spawn:
		SHRP O 2 Bright A_SpawnItemEX("RwGrenadeSmoke",0,0,0,0,0,0,0,2);
		TNT0 A 0 A_CountDown();
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

class RwGrenadeSmoke : Actor
{
	Default {
		Radius 0;
		Height 1;
		Speed 0;
		Projectile;
		Scale 0.75;
		Renderstyle "Translucent";
		Alpha 0.45;
	}
	States
	{
	Spawn:
		NULL A 3 Bright;
		SMK2 ABCDE 2 Bright;
		Stop;
	}
}