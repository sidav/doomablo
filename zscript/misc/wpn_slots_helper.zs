class WpnSlotsHelper {

    static string getSlotNamePlural(int slotNumber) {
        switch (slotNumber) {
            case 2: return "Pistols";
            case 3: return "Shotguns";
            case 4: return "Machine guns";
            case 5: return "Explosive weapons";
            case 6: return "Energy weapons";
            case 7: return "BFGs";
        }
        debug.panic("Slot "..slotNumber.." not found");
        return "";
    }
}