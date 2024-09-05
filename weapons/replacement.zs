class WeaponReplacementHandler : EventHandler
{
	override void CheckReplacement(ReplaceEvent e)
	{
		let cls = e.Replacee.GetClassName();
        switch (cls)
        {
		case 'Pistol':
			e.Replacement = 'rwPistol';
            break;
		case 'Shotgun':
			e.Replacement = 'rwShotgun';
            break;
		case 'Chaingun':
			e.Replacement = 'rwChaingun';
            break;
        }
	}

	override void WorldThingSpawned(worldEvent e)
	{
		let itm = RandomizedWeapon(e.thing);
		if (itm)
		{
			itm.bSPECIAL = false; // Make it not automatically pickupable
		}
	}
}