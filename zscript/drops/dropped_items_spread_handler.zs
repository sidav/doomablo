// Allows items to "jump" from other drops if too close.
class DroppedItemsSpreadHandler : EventHandler
{
    mixin DropSpreadable;

    int currTick;

    override void WorldTick() {
        currTick++;
        if (currTick % TICRATE != 0) {
            return;
        }
        let ti = ThinkerIterator.Create('Inventory');
        Inventory itm;
        while (itm = Inventory(ti.next())) {
            let isRWInstance = (AffixableDetector.IsAffixableItem(itm));
            if (itm && isRWInstance && rnd.OneChanceFrom(10)) {
                moveItmIfNeeded(itm);
            }
        }
    }

    void moveItmIfNeeded(Inventory itmToMove) {
        let ti = ThinkerIterator.Create('Inventory');
        Inventory itm;
        while (itm = Inventory(ti.next())) {
            let isRWInstance = (AffixableDetector.IsAffixableItem(itm));
            if (itm != itmToMove && itm && isRWInstance) {
                let dist = itmToMove.Distance3D(itm);
                if (dist <= itmToMove.radius) {
                    AssignMinorSpreadVelocityTo(itmToMove);
                }
            }
        }
    }
}