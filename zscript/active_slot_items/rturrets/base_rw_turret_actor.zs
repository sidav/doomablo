class BaseRwTurretActor : Actor
{
    int minDmg, maxDmg;
    int additionalDamagePromille; // 153 means "+15.3% damage". Made as a separate stat so that damage values like 4.1 are properly accounted
    int lifetimeTics;
    string BaseName;

    Default {
        obituary "%o was ventilated by an auto-sentry.";
        health 60;
        radius 20;
        height 56;
        mass 10000;
        speed 0;
        MaxTargetRange 2048;
        attacksound "weapons/pistol";
        MONSTER;
        +FLOORCLIP;
        +FRIENDLY;
        +NOBLOOD;
        +LOOKALLAROUND;
        +NEVERRESPAWN;
        +STANDSTILL;
        -COUNTKILL;
    }

    States {
        Spawn:
            SENT AAAAAAAAAAAAAAAA 2 A_Look;
            // SENT A 0 A_StartSound ("Sentry/Active");
            loop;
        See:
            SENT AAAAAAAAAAAAAAAA 2 A_Chase;
            loop;
        Missile:
            SENT A 16 {
                A_FaceTarget();
                A_StartSound ("Sentry/Active");
            }
            SENT B 3 bright {
                A_CustomBulletAttack(12.5, 0, 1, RWRollDamage(), "BulletPuff", 0, CBAF_NORANDOM);
            }
            SENT A 2 A_CposRefire;
            goto Missile+1;
        Death:
            SENT A 35 {
                A_StartSound ("Sentry/Death");
            }
            SENT C 1 {
                A_SpawnItem ("RwTurretExplosion", 0, 48);
            }
            SENT C 512;
        FadeOut:
            SENT C 2 A_FadeOut (0.1);
            loop;
    }

    override void Tick() {
        super.Tick();
        if (lifetimeTics <= 0) {
            A_DamageSelf(1000000);
        }
        if (level.maptime % 3 == 0)
            SetTag(String.format("[%.1f]  ", (gametime.TicksToSeconds(lifetimeTics)))..BaseName);
        lifetimeTics--;
    }

    int damageFractionAccumulator; // needed so that damage values like 4.1 are properly accounted
    int RWRollDamage() {
        let dmg = Random[sentryDamageRoll](minDmg, maxDmg);
        dmg = math.AccumulatedFixedPointMultiply(dmg, 1000+additionalDamagePromille, 1000, damageFractionAccumulator);
        return dmg;
    }
}

class RwTurretExplosion : Actor
{
    Default {
        radius 2;
        height 2;
        renderstyle "Add";
        +NOINTERACTION;
    }

    States {
        Spawn:
            XPL1 A 4 bright A_StartSound ("weapons/rocklx");
            XPL1 BCDEF 4 bright;
            stop;
    }
}