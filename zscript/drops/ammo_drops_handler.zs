// Spawns ammo near RandomizedWeapons (because we purposely have AmmoGive at zero at all weapons)
// Ammo is dropped separately so that the player doesn't have to "press use to pick it up"
class AmmoDropsHandler : EventHandler
{
	override void WorldThingSpawned(worldEvent e)
	{
		let wpn = RandomizedWeapon(e.thing);

		if (wpn && !wpn.owner && !wpn.bTossed) {
            bool spawned;
            Actor ammoitm;
			[spawned, ammoitm] = wpn.A_SpawnItemEx(wpn.ammotype1, xvel: rnd.randf(-2.5, 2.5), yvel: rnd.randf(-2.5, 2.5), zvel: 5.0);
            if (spawned && ammoitm) {
				if (wpn.stats.clipSize > 0) {
                	Inventory(ammoitm).Amount = wpn.stats.clipSize;
				}
				// Resolves e.g. BFG dropping too little ammo
				if (wpn.stats.ammoUsage > Inventory(ammoitm).Amount) {
					Inventory(ammoitm).Amount = wpn.stats.ammoUsage;
				}
            }
		}
	}
}
