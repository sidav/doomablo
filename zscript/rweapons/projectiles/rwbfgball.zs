class RwBFGBall : RwProjectile
{
	Default
	{
		Radius 13;
		Height 8;
		Speed 15;
		Projectile;
		+RANDOMIZE
		+ZDOOMTRANS
		RenderStyle "Add";
		Alpha 0.75;
		DeathSound "weapons/bfgx";
		Obituary "$OB_MPBFG_BOOM";
	}
	States
	{
	Spawn:
		BFS1 AB 4 Bright;
		Loop;
	Death:
		BFE1 AB 8 Bright;
		BFE1 C 8 Bright A_BFGSpray;
		BFE1 DEF 8 Bright;
		Stop;
	}

	int NumberOfRays;
	double RaysConeAngle;
	int RayDmgMin, RayDmgMax;
	bool raysWillOriginateFromMissile; // false means rays from shooter, like in vanilla Doom.

	override void applyWeaponStats(RandomizedWeapon weapon) {
		super.applyWeaponStats(weapon);
		let bfgw = RwBFG(weapon);

		NumberOfRays = bfgw.NumberOfRays;
		RaysConeAngle = bfgw.RaysConeAngle;
		RayDmgMin = bfgw.RayDmgMin;
		RayDmgMax = bfgw.RayDmgMax;
		raysWillOriginateFromMissile = bfgw.raysWillOriginateFromMissile;
	}

	void A_BFGSpray(double distance = 16*64, double vrange = 32, int flags = 0) {
		int damage;
		FTranslatedLineTarget t;

		// validate parameters
		if (distance <= 0) distance = 16 * 64;
		if (vrange == 0) vrange = 32.;

		// [RH] Don't crash if no target
		if (!target) return;

		// [XA] Set the originator of the rays to the projectile (self) if
		//      the new flag is set, else set it to the player (target)
		Actor originator;
		if (flags & BFGF_MISSILEORIGIN) {
			originator = self;
		} else {
			originator = target;
		}

		// offset angles from its attack ang
		for (int i = 0; i < NumberOfRays; i++) {
			double an = angle - RaysConeAngle / 2 + RaysConeAngle / NumberOfRays*i;
			originator.AimLineAttack(an, distance, t, vrange);

			if (t.linetarget != null) {
				Actor spray = Spawn("RwBFGExtra", t.linetarget.pos + (0, 0, t.linetarget.Height / 4), ALLOW_REPLACE);

				int dmgFlags = 0;
				Name dmgType = 'BFGSplash';

				if (spray != null) {
					if (spray.bPuffGetsOwner) spray.target = target;
					dmgType = spray.DamageType;
				}

				damage = Random(RayDmgMin, RayDmgMax);

				int newdam = t.linetarget.DamageMobj(originator, target, damage, dmgType, dmgFlags|DMG_USEANGLE, t.angleFromSource);
				t.TraceBleed(newdam > 0 ? newdam : damage, self);
			}
		}
	}
}

class RwBFGExtra : Actor
{
	Default
	{
		+NOBLOCKMAP
		+NOGRAVITY
		+ZDOOMTRANS
		RenderStyle "Add";
		Alpha 0.75;
		DamageType "BFGSplash";
	}
	States
	{
	Spawn:
		BFE2 ABCD 8 Bright;
		Stop;
	}
}
