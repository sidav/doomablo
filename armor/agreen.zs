// Green armor --------------------------------------------------------------

class RwGreenArmor : RandomizedArmor
{
	Default
	{
		Inventory.Pickupmessage "$GOTARMOR";
		Inventory.Icon "ARM1A0";
	}
	States
	{
	Spawn:
		ARM1 A 6;
		ARM1 B 7 bright;
		loop;
	}

	override void setBaseStats() {
        rwbaseName = "Green Armor";
    }
}
