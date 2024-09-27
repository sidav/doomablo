extend class MyCustomHUD {

    void printAffixDescriptionLine(Affix aff) {

        let clr = Font.CR_White;
        if (aff.getAlignment() > 0) {
            clr = Font.CR_GREEN;
        } else if (aff.getAlignment() < 0) {
            clr = Font.CR_RED;
        }

        PrintLine(" * "..aff.getName()..": "..aff.getDescription(),
                mSmallFont, DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT,
                clr);
    }

}