class RwProjectile : Actor {
    void applyWeaponStats(RWStatsClass stats) {
		// Set damage
		SetDamage(stats.rollDamage());

		// Rotate (apply spread)
		let horiz = RotateVector((vel.x, vel.y), rnd.Randf(-stats.HorizSpread, stats.HorizSpread));
		vel.x = horiz.x;
		vel.y = horiz.y;
		vel.z += rnd.Randf(-stats.VertSpread/2, stats.VertSpread/2);

		// Apply speed
		let factor = stats.getProjSpeedFactor();

		vel.x *= factor;
		vel.y *= factor;
		vel.z *= factor;
	}
}