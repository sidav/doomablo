// Slow homing no-explosion bullet (TODO: think of a better name)
class RwHeavyBullet : RwProjectile
{
	Default
	{
		// Scale 0.4;
		Radius 5;
		Height 3;
		Speed 44;
		Projectile;
		RenderStyle "Add";
		alpha 0.9;
		scale .25;
		+ZDOOMTRANS
		+FORCEXYBILLBOARD
		-RANDOMIZE
		-SEEKERMISSILE
		-SCREENSEEKER
	}
	States
	{
	Spawn:
		TNT0 A 1;
		Loop;
	Crash:
		TNT1 A 0;
		Stop;
	XDeath:
		TNT1 A 0;
		Stop;
	Death:
		TNT1 A 0 A_SpawnItem("BulletPuff");
		Stop;
	}

	action void RWA_SpawnTrailParticles() {
		let totalParticles = Random(1, 1);
		for (let i = 0; i < totalParticles; i++) {
			A_SpawnParticle(
				0xFFFF00,
				flags: SPF_FULLBRIGHT | SPF_REPLACE | SPF_RELATIVE | SPF_ROLL,
				lifetime: 500,
				size: 7.5,
				angle: 0,
				velx: 3.0
				// double accelx = 0, double accely = 0, double accelz = 0, double startalphaf = 1, double fadestepf = -1, double sizestep = 0
			);
		}
	}
}
