// Those are the affixes which can be applied to any (or almost any) player artifact regardless of its type.
class RwUniversalAffix : Affix abstract {
    override bool isSuffix() {
        return false;
    }
    override bool IsCompatibleWithItem(Inventory item) {
        return !(item is 'RwMonsterAffixator');
    }
    override int getAlignment() {
        return 1;
    }
    override int selectionProbabilityPercentage() {
        return 55;
    }
}

