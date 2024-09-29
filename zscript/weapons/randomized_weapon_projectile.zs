class RwProjectile : Actor {

	int rwExplosionRadius;
	int rwSetDmg; // It is needed to override the default behaviour of damage randomization.

	default {
		DamageFunction rwSetDmg; // Do not use Damage property for this! It causes damage to be randomized!
		// Damage property itself should be unset in all the descendants.
	}

	float explosionSpriteScale;
	// BUG: this is NOT called if a rocket is fired at point blank range.
	// Resolved (work-arounded) by calling pointBlank() after A_FireProjectile() return values check, see below
    void applyWeaponStats(RWStatsClass stats) {
		// Set damage. DO NOT use SetDamage() for this, because it makes the projectile have randomized damage 
		// (it's some strange implicit Doom behavior)
		rwSetDmg = stats.rollDamage();

		rwExplosionRadius = stats.ExplosionRadius;
		explosionSpriteScale = stats.GetExplosionSpriteScale();

		// Rotate (apply spread)
		let horiz = RotateVector((vel.x, vel.y), rnd.Randf(-stats.HorizSpread, stats.HorizSpread));
		vel.x = horiz.x;
		vel.y = horiz.y;
		vel.z += rnd.Randf(-stats.VertSpread, stats.VertSpread);

		// Apply speed
		let factor = stats.getProjSpeedFactor();
		vel.x *= factor;
		vel.y *= factor;
		vel.z *= factor;
	}

	action void rwExplode() {
		self.scale = (invoker.explosionSpriteScale, invoker.explosionSpriteScale);
		A_Explode(
			Damage,
			invoker.rwExplosionRadius, // Distance
			XF_HURTSOURCE
			// true, // Alert
			// 0 // The area within which full damage is inflicted. 
			// 0, // Nails
			// 10, // Nail damage
			// "BulletPuff" // Nail puff
		);
	}

	// WORKAROUND: Call this only when A_FireProjectile doesn't return the first value (that means point-blank shot, 
	//      so applyWeaponStats() won't be called in time)
	void pointBlank() {
		RadiusAttack(
			self,
			Damage,
			rwExplosionRadius,
			'None', // Damage type
			RADF_HURTSOURCE,
			0.0,
			'None'
		);
	}
}