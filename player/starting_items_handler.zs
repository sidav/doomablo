class StartingItemsHandler : EventHandler
{
	override void PlayerSpawned(PlayerEvent e)
	{
		PlayerPawn pmo = players[e.PlayerNumber].mo;
		if (pmo)
		{
			pmo.ClearInventory(); //Remove all current items
			pmo.GiveInventory('Fist', 1);
			pmo.GiveInventory('RwPistol', 1); //Pistol replacement
            pmo.GiveInventory('Clip', 50);

			pmo.FindInventory('BasicArmor').Destroy();
			// pmo.GiveInventory('BasicRandomizedArmor', 0);
		}
	}
}