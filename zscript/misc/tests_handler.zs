// When something is need to be tested, put it here.
// This handler is fully safe to delete at any time

class RwTestsHandler : StaticEventHandler
{

	override void OnRegister()
	{
        showScalingsFor("Zombie", 20);
        showScalingsFor("Cyberdemon", 3000);

        int lastLvl;
        for (int exp = 0; exp <= 1000; exp++) {
            let currlevel = LevelsExpValues.getCurrentExpLevel(exp);

            if (lastLvl != currlevel) {
                lastLvl = currlevel;
                let neededForNext = LevelsExpValues.getRequiredXPForLevel(currlevel+1);
                debug.print("Experience "..exp..": reached level "..currlevel
                    .."; next level at "..neededForNext.." (diff "..(neededForNext - LevelsExpValues.getRequiredXPForLevel(currlevel))..")");
            }
        }
        // debug.panic("Success");

        // testRemapping();

        // let triesForSum = 10000;
        // for (int i = 0; i <= 100; i++) {
        //     let str = i.."-> ";
        //     let accumulated = 0;
        //     for (let j = 0; j < triesForSum; j++) {
        //         accumulated += math.remapIntRange(i, 0, 100, 0, 10, true);
        //     }
        //     str = str.." mean "..(double(accumulated)/double(triesForSum));
        //     debug.print(str);
        // }
        // debug.panic();

        // for (let try = 0; try < 1000; try++) {
        //     let min1 = -5; let max1 = -1;
        //     let min2 = 5;  let max2 = 8;
        //     let val = rnd.RandInTwoRanges(min1, max1, min2, max2);
        //     debug.print("Value is "..val);
        //     if (val < min1 || (val > max1 && val < min2) || val > max2) {
        //         debug.panic("Bad value.");
        //     }
        // }
        
        // let size = 5;
        // array <int> balances;
        // for (let i = 0; i <= size; i++) {
        //     balances.Push(0);
        // }
        // for (let try = 0; try < 10000; try++) {
        //     let min1 = -5; let max1 = -1;
        //     let min2 = 1;  let max2 = 5;
        //     array <int> res;
            
        //     let bal = rnd.fillArrWithRandsInTwoRanges(res, min1, max1, min2, max2, size, 0, 0);
        //     balances[bal]++;
        //     // debug.print("Value is "..debug.intArrToString(res));
        // }
        // debug.panic("Tests passed. Balances results is "..debug.intArrToString(balances));
	}

    void showScalingsFor(string name, int baseValue) {
        debug.print("Scaling for "..name.." (base val is "..baseValue.."):");
        let valsStr = "";
        for (let i = 1; i <= 100; i++) {
            if (i % 10 != 0 && i != 1) continue;
            valsStr = valsStr.."[LVL "..i..": "..StatsScaler.ScaleIntValueByLevelRandomized(baseValue, i).."]  ";
        }
        debug.print("  VALS: "..valsStr);
        debug.print("  On max level the multiplier is: "..StatsScaler.ScaleIntValueByLevel(1, 100)
            .."; mean max is "..StatsScaler.ScaleIntValueByLevel(baseValue, 100));
    }

    void testRemapping() {
        let fmin = 0;
        let fmax = 10;
        let tmin = 50;
        let tmax = 100;
        let shownVals = 30;
        debug.print("Remapping from "..fmin..".."..fmax.." to range "..tmin..".."..tmax);
        for (int i = fmin; i <= fmax; i++) {
            let str = i.."-> ";
            let minValue = tmax;
            let maxValue = tmin;
            for (let j = 0; j < shownVals; j++) {
                let remapped = math.remapIntRange(i, fmin, fmax, tmin, tmax, true);
                let remappedback = math.remapIntRange(remapped, tmin, tmax, fmin, fmax, false);
                str = str.." "..remapped;
                if (remappedback != i) {
                    str = str.."("..remappedback..")  ";
                }
                if (remapped < minValue) minValue = remapped;
                if (remapped > maxValue) maxValue = remapped;
            }
            debug.print(str.." observed range is ["..minValue..".."..maxValue.."]");
        }
        debug.panic();
    }

    void testRandom() {
        for (let try = 0; try < 5; try++) {
            let valsnum = 50000;
            let str = "Random test: ";
            let sum = 0;
            for (let i = 0; i < valsnum; i++) {
                let val = rnd.weightedRand(0, 0, 0, 0, 0, 0, 1);
                str = str.." "..val;
                sum += val;
            }
            // debug.print(str);
            debug.print(" RANDOM TEST mean is "..(float(sum)/float(valsnum)));
        }
        for (let try = 0; try < 100000; try++) {
            let val = rnd.linearWeightedRand(0, 100, 100, 1);
            if (val == 100) {
                debug.print("LWR Working as intended at i="..try);
                break;
            }
        }
        for (let try = 0; try < 100000; try++) {
            let val = rnd.weightedRand(5, 10, 5, 1);
            if (val == 3) {
                debug.print("WR Working as intended at i="..try);
                break;
            }
        }
        debug.panic("Random tested");
    }
}
