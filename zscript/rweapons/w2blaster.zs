class RwBlaster : RandomizedWeapon {
    // A pistol alternative that runs off an internal battery.
    // Instead of ammo, its firerate drops off dramatically as it heats up.
    // The idea is that this is a weapon you want to use in between other weapons; it works best in short bursts and 'cools down' while in your pocket.
    // Partly inspired by the Treasure Tech pistol's altfire--again, high burst damage, but it's at its best when you have other weapons on hand.

    int chargeAcc;
    int chargeTimer;

    default {
        Weapon.SlotNumber 2;
        Weapon.SelectionOrder 3600; // Backup weapon

        Inventory.PickupMessage "$GOTBLASTER";
        Obituary "$OB_MPBLASTER";
        Tag "$TAG_BLASTER";
        // I'd like to set this thing up so that it doesn't autoswitch away
        // when the clip is depleted (since the clip recharges over time),
        // but it looks like I can't do that without making the recharge completely irrelevant,
        // esp. if this thing gets firerate affixes.
    }

    override void DoEffect() {
        super.DoEffect();
        chargeTimer++;
        chargeAcc += stats.reloadSpeedModifier;
        // Charge speed up from reload speed.
        while (chargeAcc > 100) {
            chargeTimer++;
            chargeAcc -= 100;
        }
        // Charge speed down from reload speed penalties.
        if (chargeAcc < -100) {
            chargeTimer--; // can only happen once a frame--you can't go backwards!
            chargeAcc += 100;
        }
        if (chargeTimer >= 3 && currentClipAmmo < stats.clipSize) {
            currentClipAmmo++; // Reloads slowly over time.
            // Base clip size takes ~9 seconds to recharge from empty.
            chargeTimer = 0;
        }
    }

    action state PickBlasterStage() {
        double magfill = double(invoker.CurrentClipAmmo) / double(invoker.stats.clipSize);
        if (magfill > 0.7) {
            return ResolveState("Stage1");
        } else if (magfill > 0.4) {
            return ResolveState("Stage2");
        } else {
            return ResolveState("Stage3");
        }
    }

    states {
        Spawn:
            BLAS A -1;

        Select:
            BLSG A 1 A_Raise;
            Loop;
        DeSelect:
            BLSG A 1 A_Lower;
            Loop;
        
        Ready:
            BLSG A 1 A_WeaponReady; // Does not manually reload!
            Loop;
        
        Fire:
            BLSG A 0 PickBlasterStage;
        
        Stage1:
            BLSG B 1 Bright {
                RWA_ApplyRateOfFire();
                RWA_DoFire();
            }
            BLSG C 1 Bright RWA_ApplyRateOfFire;
            Goto Ready;
        Stage2:
            BLSG B 2 Bright {
                RWA_ApplyRateOfFire();
                RWA_DoFire();
            }
            BLSG C 2 Bright RWA_ApplyRateOfFire;
            Goto Ready;
        Stage3:
            BLSG B 2 Bright {
                RWA_ApplyRateOfFire();
                RWA_DoFire();
            }
            BLSG C 2 Bright RWA_ApplyRateOfFire;
            BLSG A 2 RWA_ApplyRateOfFire;
            Goto Ready;
    }

    override void setBaseStats() {
        stats = RWStatsClass.NewWeaponStats(
            10, 20,
            1,
            10,
            5.0,
            1.0
        );
        stats.clipSize = 100;
        stats.firesProjectiles = true;
        stats.projClass = 'RwBlasterBall';
        rwBaseName = "Blaster";
    }

    override string GetRandomFluffName() {
        static const string specialNames[] =
        {
            "Reserve Shooter",
            "Taser",
            "Zapper",
            "Zapgun",
            "Bolt Thrower",
            "Backup Plan",
            "Phaser",
            "Beamer",
            "Sprayer",
            "Cricket"
        };
        return specialNames[rnd.randn(specialNames.Size())];
    }
}