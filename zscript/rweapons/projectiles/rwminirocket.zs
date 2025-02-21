class RwMiniRocket : RwProjectile
{
	float firedPellets; // Required to reduce the noise from e.g. shotguns with minimissiles
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
		// DeathSound "weapons/rocklx";
		Obituary "$OB_MPROCKET";
	}
	States
	{
	Spawn:
		MISL A 1 Bright RWA_SeekerMissile();
		Loop;
	Death:
		MISL B 8 Bright {
			double explVolume = min(0.85, 1.3 / firedPellets);
			double att = ATTN_NORM;
			if (firedPellets > 3.0) {
				att = 0.01; // Compensation for the low volume making sound fade off too quickly
			}
			A_StartSound("weapons/rocklx", volume: explVolume, attenuation: att);
			rwExplode();
		}
		MISL C 6 Bright;
		MISL D 4 Bright;
		Stop;
	BrainExplode:
		MISL BC 10 Bright;
		MISL D 10 A_BrainExplode;
		Stop;
	}

	override void applyWeaponStats(RandomizedWeapon weapon) {
		super.applyWeaponStats(weapon);
		firedPellets = float(weapon.stats.Pellets);
		if (firedPellets == 0.0) firedPellets = 1.;
	}
}