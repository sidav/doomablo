class MonsterReplacementHandler : EventHandler
{
	override void CheckReplacement(ReplaceEvent e)
	{
		let cls = e.Replacee.GetClassName();
        switch (cls)
        {
		case 'Zombieman':
			e.Replacement = 'Zlombie';
            break;
        }
	}
}