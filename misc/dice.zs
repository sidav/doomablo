class Dice
{
    int Count, Sides, Mod;

    static Dice CreateNew(int c, int s, int m) {
        let newDice = New('Dice');
        newDice.Count = c;
        newDice.Sides = s;
        newDice.Mod = m;
        return newDice;
    }

    // void Modify(int c, int s, int m) {
    //     Count += c;
    //     Sides += s;
    //     Mod += m;
    // }

	int Roll() {
		int accVal = 0;
        for (int i = 0; i < Count; i++) {
            accVal += random(1, sides);
        }
        accVal += Mod;
        return accVal;
	}

    string ToString() {
        if (Mod == 0) {
            return Count.."d"..Sides;
        } else if (Mod < 0) {
            return Count.."d"..Sides.."-"..(-Mod);
        }
        return Count.."d"..Sides.."+"..Mod;
    }
}