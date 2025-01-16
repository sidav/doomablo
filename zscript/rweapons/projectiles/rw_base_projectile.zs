class RwProjectile : Actor {

	bool noDamageToOwner; // makes sense only for exploding projectiles
	int rwExplosionRadius;
	int rwSetDmg; // It is needed to override the default behaviour of damage randomization.
	int levelOfSeekerProjectile; // 0 means "not a seeker missile", other values mean the agressiveness of the seeking

	default {
		DamageFunction rwSetDmg; // Do not use Damage property for this! It causes damage to be randomized!
		// Damage property itself should be unset in all the descendants.
		MaxTargetRange 20;
		+SEEKERMISSILE
		+SCREENSEEKER
	}

	float explosionSpriteScale;
	// BUG: this is NOT called if a rocket is fired at point blank range.
	// Resolved (work-arounded) by calling pointBlank() after A_FireProjectile() return values check, see below
    virtual void applyWeaponStats(RandomizedWeapon weapon) {
		// Set damage. DO NOT use SetDamage() for this, because it makes the projectile have randomized damage 
		// (it's some strange implicit Doom behavior)
		rwSetDmg = weapon.RWA_RollDamage();

		rwExplosionRadius = weapon.stats.ExplosionRadius;
		explosionSpriteScale = weapon.stats.GetExplosionSpriteScale();
		levelOfSeekerProjectile = weapon.stats.levelOfSeekerProjectile;
		noDamageToOwner = weapon.stats.noDamageToOwner;

		// Apply speed
		let factor = weapon.stats.getProjSpeedFactor();
		vel.x *= factor;
		vel.y *= factor;
		vel.z *= factor;
	}

	action void rwExplode() {
		self.scale = (invoker.explosionSpriteScale, invoker.explosionSpriteScale);
		A_Explode(
			invoker.rwSetDmg,
			invoker.rwExplosionRadius, // Distance
			invoker.noDamageToOwner ? 0 : XF_HURTSOURCE
			// true, // Alert
			// 0 // The area within which full damage is inflicted. 
			// 0, // Nails
			// 10, // Nail damage
			// "BulletPuff" // Nail puff
		);
	}

	// WORKAROUND: Call this only when A_FireProjectile doesn't return the first value (that means point-blank shot, 
	//      so applyWeaponStats() won't be called in time)
	// BUG HERE: there's no explosion at point blank shot.
	void pointBlank() {
		if (rwExplosionRadius > 0) {
			RadiusAttack(
				target,
				rwSetDmg,
				rwExplosionRadius,
				'None', // Damage type
				noDamageToOwner ? 0 : RADF_HURTSOURCE,
				0.0,
				'None'
			);
		} else { // non-exploding projectile, like plasma ball
			RadiusAttack(
				target,
				rwSetDmg,
				radius/2,
				'None', // Damage type
				0, // RADF_HURTSOURCE is disabled
				radius/2,
				'None'
			);
		}
	}

	// Deals with the conditions (if the projectile is seeker) and the level of it
	const maxSeekerLvl = 3;
	int noSeekerTicksPassed;
	action void RWA_SeekerMissile() {
		if (invoker.levelOfSeekerProjectile == 0) return;
		if (invoker.levelOfSeekerProjectile > maxSeekerLvl) {
			debug.print("Report this: max seeker proj level exceeded with "..invoker.levelOfSeekerProjectile);
			invoker.levelOfSeekerProjectile = maxSeekerLvl;
		}
		
		int seekEach;
		int threshold, turnAngle;

		switch (invoker.levelOfSeekerProjectile) {
			case 1:
				seekEach = 4;
				threshold = 0;
				turnAngle = 2;
				break;
			case 2:
				seekEach = 3;
				threshold = 0;
				turnAngle = 2;
				break;
			case 3:
				seekEach = 2;
				threshold = 0;
				turnAngle = 2;
				break;
		}
		if (invoker.noSeekerTicksPassed == 0 || invoker.noSeekerTicksPassed % (seekEach) != 0) {
			invoker.noSeekerTicksPassed++;
			return;
		}
		invoker.noSeekerTicksPassed = 0;
		A_SeekerMissile(threshold, turnAngle, SMF_LOOK | SMF_PRECISE | SMF_CURSPEED, 255, 6);
	}
}