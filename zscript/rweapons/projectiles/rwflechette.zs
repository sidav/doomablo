// Slow homing no-explosion bullet (TODO: think of a better name)
class RwFlechette : RwProjectile
{
	Default
	{
		// Scale 0.4;
		Radius 5;
		Height 3;
		Speed 14;
		Projectile;
		MaxTargetRange 20;
		+RANDOMIZE
		// +DEHEXPLOSION
		+ZDOOMTRANS
		+SCREENSEEKER
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
		TNT0 A 1 Bright {
			A_SeekerMissile(1, 2, SMF_LOOK | SMF_PRECISE, 128, 4);
			RWA_SpawnTrailParticles();
		}
		TNT0 A 1 Bright RWA_SpawnTrailParticles(); // Empty state, so that those ticks won't be homing
		Loop;
	Death:
		Stop;
	}

	const particleColor = 0xFFDD00;
	action void RWA_SpawnTrailParticles() {
		let totalParticles = Random(2, 3);
		for (let i = 0; i < totalParticles; i++) {
			A_SpawnParticle(
				particleColor,
				flags: SPF_FULLBRIGHT | SPF_REPLACE | SPF_RELATIVE,
				lifetime: rnd.rand(7, 17),
				size: 4.5,
				angle: 0,
				velx: -double(Random(-10, 10))/10, vely: -double(Random(-30, 30))/100, velz: -double(Random(-30, 30))/100
				// double accelx = 0, double accely = 0, double accelz = 0, double startalphaf = 1, double fadestepf = -1, double sizestep = 0
			);
		}
	}
}
