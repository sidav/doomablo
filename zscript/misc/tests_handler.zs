// When something is need to be tested, put it here.
// This handler is fully safe to delete at any time

class RwTestsHandler : StaticEventHandler
{

	override void OnRegister()
	{
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
