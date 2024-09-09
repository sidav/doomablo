// When something is need to be tested, put it here.
// This handler is fully safe to delete at any time

class RwTestsHandler : StaticEventHandler
{

	override void OnRegister()
	{
        // testRandom();
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
