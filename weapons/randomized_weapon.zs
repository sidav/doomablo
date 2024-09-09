class RandomizedWeapon : DoomWeapon {

    mixin Affixable;

    string rwFullName; // Needed for HUD
    string rwbaseName;
    RWStatsClass stats;

    virtual void setBaseStats() {
        // Should be overridden
    }

    override void BeginPlay() {
        setBaseStats();
        Generate();
        SetDescriptionString();
    }

}