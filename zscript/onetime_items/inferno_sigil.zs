// The only difference between this and tome is that this can't be put into inventory.
class InfernoSigil : InfernoBook {
	Default
	{
		Inventory.Pickupmessage "Demonic seal broken! Inferno level increased!";
		// +INVENTORY.ALWAYSPICKUP - should be false
		+Inventory.AUTOACTIVATE
		+BRIGHT
	}
	States
	{
	Spawn:
		TELO ABCD 5;
		loop;
	}
}
