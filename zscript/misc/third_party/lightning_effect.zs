// MIT License

// Copyright (c) 2024 Agent_Ash aka jekyllgrim

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

class ArcSplitController : Inventory
{
	ArcSplitController ac_parentController; // used by controllers created by other controllers
	array <ArcSplitController> ac_childControllers; // used by the first controller only
	array <Actor> lightningVictims; // used by each controller to track which victims it should be able to damage
	bool 	ac_done;			// set by the controller itself when it's time to disappear
	int		ac_stage;			// tracks which arc it is in the chain
	int		ac_maxSplits;		// maximum number of secondary arcs that one arc can split into at once
	int		ac_maxLinks;		// maximum number of links each arc can create in total ("depth")
	int		ac_duration;		// duration of the effect
	int		ac_duration_init;	// initial duration of the effect
	int		ac_delay;			// delay between the controller is given and the effect starts
	int		ac_delay_init;		// initial delay
	int		ac_damagePerArc;	// damage per a single arc
	Actor	ac_damageSource;	// tracks the source actor responsible for the attack
	double	ac_maxDistance;		// max distance an arc can cover (same for all arcs)

	Default
	{
		Inventory.MaxAmount 1;
		+Inventory.UNDROPPABLE
		+Inventory.UNTOSSABLE
	}

	ArcSplitController GetParentController()
	{
		ArcSplitController asc = self;
		while (asc && asc.ac_parentController)
		{
			asc = asc.ac_parentController;
		}
		return asc;
	}

	// Dedicated function accurately calculate the exact point
	// from which player's attack come out. Used by LineTrace()
	// in weapons.
	static double GetAttackHeight(PlayerPawn source)
	{
		if (!source || !source.player)
			return 0;
		
		let player = source.player;
		return source.height*0.5 - source.floorclip + player.mo.AttackZOffset*player.crouchFactor;
	}

	// Allows specifying a relative offset (forward/leftright/updown) and converts it
	// to proper world coordinates:
	// startpos	: initial position
	// viewangles	: angle, pitch, roll
	// offset	: forward/backward, right/left, up/down
	// isPosition	: if true, adds startPos to result (only useful for velocity); otherwise doesn't
	static Vector3 RelativeToGlobalCoords(Vector3 startpos, Vector3 viewAngles, Vector3 offset, bool isPosition = true)
	{
		Quat dir = Quat.FromAngles(viewAngles.x, viewAngles.y, viewAngles.z);
		vector3 ofs = dir * (offset.x, -offset.y, offset.z);
		if (isPosition)
		{
			return Level.vec3offset(startpos, ofs);
		}
		return ofs;
	}

	static Vector3 GetViewAngles(Actor mo)
	{
		return (mo.angle, mo.pitch, mo.roll);
	}

	// Gets the position to which the beam is attached to.
	// By default it's just the center of the source.
	// If source is a player, horOfs and vertOfs are used
	// to define horizontal and vertical offset, like in A_SpawnProjectile
	static Vector3 GetBeamAttachPos(Actor source, double horOfs = 0, double vertOfs = 0)
	{
		if (!source)
			return (0,0,0);
		Vector3 spos;
		if (source.player)
		{
			spos = RelativeToGlobalCoords((source.pos.xy, source.player.viewz), GetViewAngles(source), (source.radius, horOfs, vertOfs), true);
		}
		else
		{
			spos = source.pos + (0,0,source.height * 0.5);
		}
		return spos;
	}

	// Starts a lightning chain. Arguments:
	// damageSource	: the actor responsible for the damage (will be passed to further arcs)
	// victim		: the first victim of the lightning
	// damage		: the damage to deal per one iteration
	// range		: the range of the lightning (will be passed to further arcs)
	// duration		: how long a single arc persists
	// delay		: delay between further arcs are created from the victim
	// maxSplits	: maximum number of arcs that can be fired from a single victim
	// maxlinks		: how many total victims can be hit by a single lightning chain
	// parent		: this is used only by ExtendChain(), to create a new lightning parented to the same controller
	static ArcSplitController StartChain(Actor damageSource, Actor victim, int damage, double range, int duration = 1, int delay = 0, int maxSplits = 1, int maxLinks = 0, ArcSplitController parent = null)
	{
		if (!damageSource || !victim)
			return null;

		ArcSplitController c = ArcSplitController(victim.FindInventory('ArcSplitController'));
		if (!c)
		{
			c = ArcSplitController(victim.GiveInventoryType('ArcSplitController'));
		}
		if (c)
		{
			c.ac_parentController = parent;
			c.ac_stage 			= parent? parent.ac_stage + 1 : 1;
			c.ac_damageSource	= damageSource;
			c.owner				= victim;
			c.ac_maxDistance	= range;
			c.ac_duration		= duration;
			c.ac_duration_init	= c.ac_duration;
			c.ac_damagePerArc	= damage;
			c.ac_delay			= delay;
			c.ac_delay_init		= c.ac_delay;
			c.ac_maxSplits		= Clamp(maxSplits, 1, 300);
			c.ac_maxLinks		= Clamp(maxLinks, 1, 300);

			let ac = c.GetParentController();
			ac.ac_childControllers.Push(c);

			//Console.Printf("ArcSplitController created (\cd%d\c-). First victim: \cd%s\c- | ac_duration: \cd%d\c- | ac_delay: \cd%d\c-", Level.maptime, c.owner? c.owner.GetClassName() : 'none', c.ac_duration_init, c.ac_delay_init);
		}
		return c;
	}

	// Extends the lightning chain from the owner of this item
	// to the other actor:
	void ExtendChainTo(Actor nextVictim)
	{
		if (!nextVictim || !ac_damageSource)
			return;

		StartChain(ac_damagesource, nextVictim, ac_damagePerArc, ac_maxDistance, ac_duration_init, ac_delay_init, ac_maxSplits, ac_maxLinks, self);
	}

	// Gets a bunch of randomly offset points from one position to a nother,
	// then calls DrawLightningSegment() between each of those points to create
	// a jagged particle-based lightning.
	// Arguments are the same as in DrawLightningSegment(), just passed to it.
	static void DrawLightning(Vector3 from, Vector3 to, bool spawnSpark = true, PlayerInfo playersource = null)
	{
		let diff = Level.Vec3Diff(from, to);
		let dir = diff.Unit();
		let dist = diff.Length();
		double nodeDist = Clamp(dist / 10, min(8, dist), min(80, dist));
		int steps = nodeDist < dist? floor(dist / nodeDist) : 1;
		double ofss = nodeDist / 4.0;

		array <double> litPosX;
		array <double> litPosY;
		array <double> litPosZ;
		Vector3 partPos = from;
		Vector3 node;
		for (int i = 1; i <= steps; i++)
		{
			partPos += dir*nodeDist;
			node = partPos;
			if (i < steps)
			{
				node += (frandom[lightningpart](-ofss, ofss), 
						frandom[lightningpart](-ofss, ofss), 
						frandom[lightningpart](-ofss, ofss));
			}
			litPosX.Push(node.x);
			litPosY.Push(node.y);
			litPosZ.Push(node.z);
		}

		steps = min(litPosX.Size(), litPosY.Size(), litPosZ.Size());
		for (int i = 0; i < steps; i++)
		{
			node.x = litPosX[i];
			node.y = litPosY[i];
			node.z = litPosZ[i];
			ArcSplitController.DrawLightningSegment(from, node, density: 1, size: 4, posOfs: 0, spawnSpark: (spawnSpark && i == steps - 1), playersource: playersource);
			from = node;
		}
	}

	// Dedicated function to draw a particle beam between two points.
	// YOU CAN COMPLETELY REPLACE THIS to change the visuals of your lightning.
	// This function is just an example of how a lightning can look (mostly because
	// I just wanted to make a decently-looking lightning using only particles).
	// from			: starting position
	// to			: end position
	// density		: per how many units to draw a particle
	// size			: particle size
	// posOfs		: if non-zero, each particle will be randomly offset within this range
	// spawnSpark	: spawn a spark at the 'from' position, if true
	// playerSource	: pass a PlayerInfo pointer here if this is being fired by the player.
	// (If playerSouce is non-null, PlayerPawn's velocity will be added to particles for
	// interpolatin purposes.)
	static void DrawLightningSegment(Vector3 from, Vector3 to, double density = 8, double size = 10, double posOfs = 2, bool spawnSpark = true, PlayerInfo playerSource = null)
	{
		let diff = Level.Vec3Diff(from, to); // difference between two points
		let dir = diff.Unit(); // direction from point 1 to point 2
		int steps = floor(diff.Length() / density); // how many steps to take:

		// Generic particle properties:
		posOfs = abs(posOfs);
		FSpawnParticleParams pp;
		pp.color1 = 0xFFCCCCFF;
		pp.flags = SPF_FULLBRIGHT|SPF_REPLACE;
		pp.lifetime = 1;
		pp.size = size; // size
		pp.style = STYLE_Add; //additive renderstyle
		pp.startalpha = 1;
		if (playerSource && playerSource.mo)
		{
			pp.vel = playerSource.mo.vel;
		}
		Vector3 partPos = from; //initial position
		for (int i = 0; i <= steps; i++)
		{
			pp.pos = partPos;
			if (posOfs > 0)
			{
				pp.pos + (frandom[lightningpart](-posOfs,posOfs), frandom[lightningpart](-posOfs,posOfs), frandom[lightningpart](-posOfs,posOfs));
			}
			// spawn the particle:
			Level.SpawnParticle(pp);
			// Move position from point 1 topwards point 2:
			partPos += dir*density;
		}

		if (!spawnSpark)
		{
			return;
		}

		// If spawnspark is true, spawn some sparks at the end position:
		pp.size = size * 0.3;
		pp.lifetime = 30;
		pp.sizestep = -(pp.size / pp.lifetime);
		pp.pos = to;
		pp.accel.z = -0.5;
		for (int i = 5; i > 0; i--)
		{
			pp.vel.x = frandom[lightningpart](-3, 3);
			pp.vel.y = frandom[lightningpart](-3, 3);
			pp.vel.z = frandom[lightningpart](2, 6);
			pp.accel.xy = -(pp.vel.xy / pp.lifetime);
			Level.SpawnParticle(pp);
		}
	}

	// Adds an actor to the specified array so they're ordered by their distance 
	// from the 'from' actor:
	static void AddByDistance(Actor toAdd, Actor from, out array<Actor> arr)
	{
		if (arr.Size() <= 0)
		{
			arr.Push(toAdd);
			return;
		}

		double dist = from.Distance3D(toAdd)**2;
		for (int i = 0; i < arr.Size(); i++)
		{
			let v = arr[i];
			if (!v) 
				continue;
			
			if (dist <= from.Distance3DSquared(v))
			{
				arr.Insert(i, toAdd);
				break;
			}
		}
	}

	// Generic check used by lightning to determine if the specified actor
	// is a valid victim for the lightning:
	static bool IsValidVictim(Actor who, Actor source)
	{
		return who && who.bSHOOTABLE && (who.bISMONSTER || who.player) && who.health > 0 && !who.isFriend(source);
	}

	// Called by this controller continuously to find more valid victims:
	void FindVictimsAround()
	{
		let bti = BlockThingsIterator.Create(owner, ac_maxDistance);
		Actor thing;
		double distanceSq = ac_maxDistance**2;
		while (bti.Next())
		{
			thing = bti.thing;
			if (!thing)
				continue;
			// skip conditions:
			if (thing == owner || //is the owner
				thing == ac_damageSource || //is the shooter
				!(thing.bISMONSTER || thing.player) || //not a monster or a player
				thing.health <= 0 || //dead
				thing.FindInventory(self.GetClass()) || // already being hit by lightning
				thing.IsFriend(ac_damageSource) || //not hostile to owner
				owner.Distance3DSquared(thing) > distanceSq || //too far
				!owner.CheckSight(thing) )// owner has no LoS to thing
			{
				continue;
			}
			AddByDistance(thing, owner, lightningVictims);
		}
		// Limit the size of array to maxsplits:
		if (lightningVictims.Size() > ac_maxSplits)
		{
			lightningVictims.Delete(ac_maxSplits, lightningVictims.Size());
			lightningVictims.ShrinkToFit();
		}
	}

	// Updates the array of victims to remove the ones that
	// no longer fit the criteria, then find new ones:
	void UpdateVictims()
	{
		if (lightningVictims.Size() > 0)
		{
			Actor thing;
			double distanceSq = ac_maxDistance**2;
			for (int i = lightningVictims.Size() - 1; i >= 0; i--)
			{
				if (!lightningVictims[i])
				{
					lightningVictims.Delete(i);
					continue;
				}
				thing = lightningVictims[i];
				if (!thing || // null pointer
					owner.Distance3DSquared(thing) > distanceSq || // too far
					!owner.CheckSight(thing) ) // out of LoS
				{
					lightningVictims.Delete(i);
				}
			}
			lightningVictims.ShrinkToFit();
		}
		FindVictimsAround();
	}

	override void Tick()
	{
		if (!owner || !ac_damageSource)
		{
			Destroy();
			return;
		}
		if (owner.IsFrozen())
		{
			return;
		}
		// The first controller gets a signal from child controllers
		// that it's time to disappear:
		if (ac_done && !ac_parentController)
		{
			bool alldone = true;
			for (int i = ac_childControllers.Size() - 1; i >= 0; i--)
			{
				let asc = ac_childControllers[i];
				if (!asc)
				{
					ac_childControllers.Delete(i);
					continue;
				}
				if (!asc.ac_done)
				{
					alldone = false;
					break;
				}
			}
			if (alldone)
			{
				for (int i = ac_childControllers.Size() - 1; i >= 0; i--)
				{
					let asc = ac_childControllers[i];
					if (asc)
					{
						asc.Destroy();
					}
				}
				Destroy();
				return;
			}
		}

		if (!ac_done)
		{
			owner.DamageMobj(self, ac_damageSource, ac_damagePerArc, 'Lightning', DMG_THRUSTLESS);
		}

		if (ac_delay > 0)
		{
			ac_delay--;
		}
		
		else if (ac_duration > 0)
		{
			if (ac_maxLinks <= 0 || ac_stage <= ac_maxLinks)
			{
				UpdateVictims();
				Actor v;
				for (int i = 0; i < lightningVictims.Size(); i++)
				{
					v = lightningVictims[i];
					if (v)
					{
						ExtendChainTo(v);
						DrawLightning(GetBeamAttachPos(owner), GetBeamAttachPos(v));
					}
				}
			}
			ac_duration--;
		}
		// Only the final controller is allowed to trigger
		// destruction of all controllers:
		else
		{
			ac_done = true;
		}
	}
}

// EXAMPLE weapon that uses the above-mentioned functionality:

class LightningGun : PlasmaRifle
{
	// Base attack function
	// useammo		: if true, requires and consumes ammo
	// horofs		: horizontal offset of the lightning (like spawnofs_xy in A_FireProjectile)
	// spawnheight	: vertical offset for the lightning relative to screen center (NOT actor bottom)
	// range		: range of the lightning (will be passed to secondary arcs too)
	// duration		: how long the lightning persists on a single actor
	// delay		: how long the lightning takes between it hit a single actor and can split or link further
	// maxsplits	: how many secondary arcs can be fired from a single victim
	// maxlinks		: how many victims in total can be linked in a single attack
	action void A_FireLightningGun(int damage, bool useammo = true, double horOfs = 0, double spawnheight = 0, double range = 512, int duration = 1, int delay = 0, int maxsplits = 1, int maxlinks = 5)
	{
		if (useammo && !invoker.DepleteAmmo(invoker.bAltFire))
		{
			return;
		}
		// beamstart is where the lightning appears from:
		Vector3 beamstart = ArcSplitController.GetBeamAttachPos(self, horOfs, spawnheight);
		Vector3 beamEnd;

		// hit victim:
		FLineTraceData tr;
		LineTrace(angle, range, pitch, offsetz: ArcSplitController.GetAttackHeight(PlayerPawn(self)), data: tr);
		if (tr.HitType == TRACE_HitActor && tr.hitActor && ArcSplitController.IsValidVictim(tr.hitActor, self))
		{
			beamEnd = ArcSplitController.GetBeamAttachPos(tr.HitActor);
			ArcSplitController.StartChain(self, tr.HitActor, damage, range, duration, delay, maxsplits, maxlinks);
		}
		// hit nothing:
		else
		{
			beamEnd = tr.HitLocation;
		}
		ArcSplitController.DrawLightning(beamstart, beamend, spawnSpark: (tr.HitType != TRACE_HitNone), playersource: player);
	}

	States
	{
	// This is meant to be a sustained lightning attack
	// that you keep up to keep hitting the same victims:
	Fire:
		PLSG A 1 A_FireLightningGun(5, useammo: false, spawnheight: -10, range: 512, duration: 1, delay: 0, maxsplits: 1, maxlinks: 7);
		PLSG A 5 A_ReFire;
		Goto Ready;
	// This is more of a 'shotgun' of sorts; it creates shorter chains,
	// but they split into more arcs per victim:
	AltFire:
		PLSG A 20 A_FireLightningGun(5, useammo: false, spawnheight: -10, range: 512, duration: 30, delay: 20, maxsplits: 4, maxlinks: 3);
		PLSG B 20 A_ReFire;
		Goto Ready;
	}
}