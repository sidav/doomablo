class ArmorReplacementHandler : EventHandler
{
    override void CheckReplacement(ReplaceEvent e)
	{
		let cls = e.Replacee.GetClassName();
        switch (cls)
        {
		case 'ArmorBonus':
			e.Replacement = 'RwArmorBonus';
            break;
        case 'GreenArmor':
			e.Replacement = 'RwGreenArmor';
            break;
        case 'BlueArmor':
			e.Replacement = 'RwBlueArmor';
            break;
        }
	}
}