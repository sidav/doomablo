class RwGlobalVars {
    static int GetTotalAffixes() {
        let handler = RwGlobalsHandler(StaticEventHandler.Find('RwGlobalsHandler'));
        return handler.totalAffixesClasses;
    }
}

/////////////////////////////////////

class RwGlobalsHandler : StaticEventHandler
{
    int totalAffixesClasses;

	override void OnRegister()
	{
        countAffixesClasses();
	}

    void countAffixesClasses() {
        totalAffixesClasses = 0;
        foreach (cls : AllClasses)  {
            let ba = (class<Affix>)(cls);
            if (ba && ba != 'Affix' && ba != 'Prefix' && ba != 'Suffix')
            {
                totalAffixesClasses++;
            }
        }

        let t = CVar.GetCVar('totalAffixesClasses', null);
        t.SetInt(totalAffixesClasses);
        
        debug.print("RWGH: Found "..totalAffixesClasses.." affix classes.");
    }
}
