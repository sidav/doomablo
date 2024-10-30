class RwProjectile : Actor {

	bool noDamageToOwner; // makes sense only for exploding projectiles
	int rwExplosionRadius;
	int rwSetDmg; // It is needed to override the default behaviour of damage randomization.

	default {
		DamageFunction rwSetDmg; // Do not use Damage property for this! It causes damage to be randomized!
		// Damage property itself should be unset in all the descendants.
	}

	float explosionSpriteScale;
	// BUG: this is NOT called if a rocket is fired at point blank range.
	// Resolved (work-arounded) by calling pointBlank() after A_FireProjectile() return values check, see below
    void applyWeaponStats(RandomizedWeapon weapon) {
		// Set damage. DO NOT use SetDamage() for this, because it makes the projectile have randomized damage 
		// (it's some strange implicit Doom behavior)
		rwSetDmg = weapon.RWA_RollDamage();

		rwExplosionRadius = weapon.stats.ExplosionRadius;
		explosionSpriteScale = weapon.stats.GetExplosionSpriteScale();
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
}