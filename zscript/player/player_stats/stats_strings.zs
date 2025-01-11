extend class RwPlayerStats {

    string getStatButtonText(int id) {
        switch (id) {
            case StatVitality: 
                return String.Format("Vitality:   %d", baseStats[StatVitality]);
            case StatCritChance: 
                return String.Format("Crit chance lvl: %d", baseStats[StatCritChance]);
            case StatCritDmg: 
                return String.Format("Crit dmg lvl: %d", baseStats[StatCritDmg]);
            case StatMeleeDmg: 
                return String.Format("Fist dmg lvl: %d", baseStats[StatMeleeDmg]);
            case StatRareFind:
                return String.Format("Rare find chance lvl: %d", baseStats[StatRareFind]);
        }
        debug.print("Unknown stat text: "..id);
        return "";
    }

    string getStatButtonDescription(int id) {
        let newLineString = "---------------------\n";
        switch (id) {
            case StatVitality: 
                return String.Format("Each point of Vitality increases your maximum HP above 100 by 1.75, rounding down.\n"
                ..newLineString
                .."Current max health value: "..GetMaxHealth());

            case StatCritChance: 
                return "Critical hit chance determines the probability to deal increased damage with each hit."
                    .." It is a base stat, which can be further modified by items.\n"
                    ..newLineString
                    ..String.Format("Current crit chance: %.1f%%", double(getCritChancePromille())/10);

            case StatCritDmg: 
                return "Critical hit damage determines how much percent of damage your critical hits will deal."
                    .." It is a base stat, which can be further modified by items.\n"
                    ..newLineString
                    ..String.Format("Your current crit damage: %.1f%%", double(getCritDmgPromille())/10);

            case StatMeleeDmg: 
                int mindmg;
                int maxdmg;
                [mindmg, maxdmg] = GetMinAndMaxMeleeDamage();
                return "This stat increases your min and max base fist damage."
                        .." It also scales with your experience level, so the more points you put there,"
                        .." the bigger damage yield you get.\n"
                        .." Berserk packs synergize with it, dealing further 10x damage.\n"
                        ..newLineString
                        .."Your current fist damage: "..mindmg.."-"..maxdmg;

            case StatRareFind:
                return "Rare Find stat determines your chance to receive an artifact drop of increased rarity.\n"
                        .." The effect is twice as small for each next rarity level.\n"
                        ..newLineString
                        .."Your current chances for increased rarity are:\n\n"
                        ..String.Format("Uncommon: +%.1f%%\n", double(getIncreaseRarityChancePromilleFor(0))/10)
                        ..String.Format("Rare: +%.1f%%\n", double(getIncreaseRarityChancePromilleFor(1))/10)
                        ..String.Format("Epic: +%.1f%%\n", double(getIncreaseRarityChancePromilleFor(2))/10)
                        ..String.Format("Legendary: +%.1f%%\n", double(getIncreaseRarityChancePromilleFor(3))/10)
                        ..String.Format("Mythic: +%.1f%%\n", double(getIncreaseRarityChancePromilleFor(4))/10);
        }
        debug.print("Unknown stat description: "..id);
        return "";
    }
}