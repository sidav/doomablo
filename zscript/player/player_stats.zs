class RwPlayerStats {
    int statPointsAvailable;

    int vitality;
    int critChancePromille;
    int critDamageFactorPromille;
    int rareFindModifier;
    
    static RwPlayerStats Create() {
        let newStats = new('RwPlayerStats');
        newStats.statPointsAvailable = 0;
        newStats.vitality = 100;
        newStats.critChancePromille = 0;
        newStats.critDamageFactorPromille = 1250;
        newStats.rareFindModifier = 0;
        return newStats;
    }

}