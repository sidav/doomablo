// Slow homing no-explosion bullet (TODO: think of a better name)
class RwFlechette : RwProjectile
{
	Default
	{
		// Scale 0.4;
		Radius 5;
		Height 3;
		Speed 12;
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
		// Seeker missle first argument: angle targeting threshold (which max angle still counts as "on the direction to target")
		// Second: max turn angle per move (should be larger than threshold)
		// Third: flags (SMF_LOOK - look for targets if none selected currently)
		// 4: Chance - if the SMF_LOOK flag is used, this is the chance (out of 256) that the missile will try acquiring a target if it doesn't already have one.
		// 5: Distance - the maximum distance (in blocks of 128 map units) at which targets are sought. Default is 10
		TNT0 A 1 Bright A_SeekerMissile(3, 1, SMF_LOOK, 64, 5);
		TNT0 AA 1 Bright; // Empty state, so that those ticks won't be homing
		Loop;
	Death:
		Stop;
	}
}
