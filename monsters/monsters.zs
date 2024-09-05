class Zlombie : Zombieman // replaces Zombieman
{
    Default
    {
        // radius 20;
        // height 40;
    }
	
	override void BeginPlay() {
		let hscale = rnd.randf(0.5, 1.5);
		let vscale = rnd.randf(0.5, 1.5);
		self.scale = (hscale, vscale);
	}
}