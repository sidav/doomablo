class RandomizedWeapon : DoomWeapon {

    string rwFullName; // Needed for HUD
    string rwbaseName;
    RWStatsClass stats;

    array <Affix> appliedAffixes;

    virtual void setBaseStats() {
        // Should be overridden
    }

    override void BeginPlay() {
        setBaseStats();
        Generate();
        SetDescriptionString();
    }

}