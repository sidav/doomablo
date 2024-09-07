class RwProjectile : Actor {
    void applyWeaponStats(RWStatsClass stats) {
		// Set damage
		SetDamage(stats.rollDamage());

		// Rotate (apply spread)
		let horiz = RotateVector((vel.x, vel.y), rnd.Randf(-stats.HorizSpread, stats.HorizSpread));
		vel.x = horiz.x;
		vel.y = horiz.y;
		vel.z += rnd.Randf(-stats.VertSpread, stats.VertSpread);

		// Apply speed
		let factor = stats.getProjSpeedFactor();
		debug.print("FACTOR: "..factor);
		vel.x *= factor;
		vel.y *= factor;
		vel.z *= factor;
	}
}