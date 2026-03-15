// This affix does nothing; it's here to add fluff text to unique weapons.
class RwFluffAffix : Affix {
    string description;
    bool countAsSuff;
    Color color;

    static RwFluffAffix Create(string desc, bool countAsSuffix = true, Color clr = Font.CR_FIRE) {
        RwFluffAffix a = new("RwFluffAffix");
        a.description = desc;
        a.countAsSuff = countAsSuffix;
        a.color = clr;
        return a;
    }

    override string getDescription() {
        return description;
    }

    override bool isSuffix() {
        return countAsSuff;
    }

    override string getName() {return ""; }
    override int getAlignment() { return 0; }
    override void InitAndApplyEffectToItem(Inventory item, int quality) {}
    override bool IsCompatibleWithItem(Inventory item) { return true; }
}