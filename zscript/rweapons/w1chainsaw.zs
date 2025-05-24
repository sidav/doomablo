class RwChainsaw : RandomizedWeapon
{

    double lastXOffset, lastYOffset;
    const maxXOffset = 7.0;
    const maxYOffset = 4.0;

	Default
	{
        Weapon.SlotNumber 1;
		Weapon.Kickback 0;
		Weapon.SelectionOrder 2200;
		Weapon.UpSound "weapons/sawup";
		Weapon.ReadySound "weapons/sawidle";
		Inventory.PickupMessage "$GOTCHAINSAW";
		Obituary "$OB_MPCHAINSAW";
		Tag "$TAG_CHAINSAW";
		+WEAPON.MELEEWEAPON		
		+WEAPON.NOAUTOSWITCHTO
		RandomizedWeapon.Weight 5;
	}
	States
	{
	Ready:
		SAWG CD 4 A_WeaponReady;
		Loop;
	Deselect:
		SAWG C 1 A_Lower;
		Loop;
	Select:
		TNT1 A 0 A_WeaponOffset(0, 0, WOF_KEEPY | WOF_INTERPOLATE); // Reset the X-offset which may be off because of reload
		SAWG C 1 A_Raise;
		Loop;
	Fire:
		SAWG A 4 {
            RWA_ApplyRateOfFire();
            A_Saw();
            invoker.lastXOffset = rnd.randf(-invoker.maxXOffset, invoker.maxXOffset);
            invoker.lastYOffset = rnd.randf(0, invoker.maxYOffset);
            A_WeaponOffset(invoker.lastXOffset, invoker.lastYOffset, WOF_ADD | WOF_INTERPOLATE);
        }
        SAWG B 4 {
            RWA_ApplyRateOfFire();
            A_Saw();
            A_WeaponOffset(-invoker.lastXOffset, -invoker.lastYOffset, WOF_ADD | WOF_INTERPOLATE);
        }
		SAWG B 0 A_ReFire;
		Goto Ready;
	Spawn:
		CSAW A -1;
		Stop;
	}

	override string GetRandomFluffName() {
        static const string specialNames[] =
        {
			"Ripper",
			"Splitter",
			"Tearer"
        };
        return specialNames[rnd.randn(specialNames.Size())];
    }

    override void setBaseStats() {
		stats = RWStatsClass.NewWeaponStats(
			2, 8,
			1,
			0,
			20.0,
			2.5
		);
        stats.clipSize = 0;
		stats.recoil = 1.5;
        stats.attackRange = 72;
        stats.isMelee = true;
		rwBaseName = "Chainsaw";
    }

    action void A_Saw() {
        if (player == null) {
			return;
		}

        let range = invoker.stats.attackRange;
		double ang = angle + rnd.randf(-invoker.stats.HorizSpread, invoker.stats.HorizSpread);

        FTranslatedLineTarget t;
		double slope = AimLineAttack(ang, range, t) + rnd.randf(-invoker.stats.VertSpread, invoker.stats.VertSpread);

		Actor puff;
		int actualdamage;
		[puff, actualdamage] = LineAttack(ang, range, slope, invoker.RWA_RollDamage(), 'Melee', 'BulletPuff', 0, t);

		if (puff || t.linetarget) {
			RWA_ApplyRecoil(true);
		}

		if (!t.linetarget) {
			A_StartSound ("weapons/sawfull", CHAN_WEAPON);
			return;
		}
		A_StartSound ("weapons/sawhit", CHAN_WEAPON);
			
		// turn to face target
        double anglediff = deltaangle(angle, t.angleFromSource);
        if (anglediff < 0.0) {
            if (anglediff < -4.5)
                angle = t.angleFromSource + 90.0 / 21;
            else
                angle -= 4.5;
        } else {
            if (anglediff > 4.5)
                angle = t.angleFromSource - 90.0 / 21;
            else
                angle += 4.5;
        }
	}
}
