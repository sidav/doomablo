class RwProgressionPlayer : RwPlayer {
    default {
        Player.DisplayName "Progressive Drops";
        Health 100;
    }

    override void BeginPlay() {
        super.BeginPlay();
        minItemQuality = 1;
        maxItemQuality = 5;
    }

    override bool ProgressionEnabled() {
        return true;
    }
}