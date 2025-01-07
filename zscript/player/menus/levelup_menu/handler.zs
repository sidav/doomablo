class LevelupMenuHandler : ZFHandler
{
    // The menu this command handler belongs to.
    // We need this to be able to do anything with our menu.
    RWLevelupMenu link;
    override void buttonClickCommand (ZFButton caller, string command) {

        if (LevelUpButton(caller)) {
            LevelUpButton(caller).OnClick();
            link.DescriptionLabel.text = LevelUpButton(caller).getDescription();
        }
    }
    override void elementHoverChanged (ZFElement caller, string command, bool unhovered) {
        if (LevelUpButton(caller)) {
            if (unhovered) {
                link.DescriptionLabel.text = "";
            } else {
                link.DescriptionLabel.text = LevelUpButton(caller).getDescription();
            }
        }
    }
}